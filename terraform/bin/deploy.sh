#!/bin/bash

set -e

ROOT_DIR=$(pwd)
LAMBDA_DIR="api/lambda"
PROJECT=${PROJECT:-"tmoro-example"}

build_lambdas () {
  for dir in "$LAMBDA_DIR"/*; do
    src_dir="$dir"
    if [ -d "$src_dir" ]; then
      echo "[INFO] Processing $src_dir"
      local lambda_name

      (cd "$src_dir" && sh build.sh)

      if [[ ! -f "$src_dir/package.zip" ]]; then
        >&2 echo "Deployment file package.zip not generated as a result of the build"
        return 1
      fi

      lambda_name="${PROJECT}-$(jq -r ".name" "$src_dir/config.json")"
      zip=$(realpath "$src_dir/package.zip")
      echo -e "Deploying lambda ${lambda_name}\n- Package at ${zip}"
      aws lambda update-function-code \
        --function-name "${lambda_name}" \
        --zip-file "fileb://${zip}" \
        --no-cli-pager

    fi
  done
}

deploy () {
#  build_lambdas

  cd "$ROOT_DIR/terraform"
  # change hardcoded env reference
  terraform "$1" -var-file=develop.tfvars
}

destroy () {
  echo "Destroying infrastructure will delete all data. Only 'yes' will be accepted to confirm."
  read -r CONFIRM
  if [ "$CONFIRM" == "yes" ]; then
      deploy destroy
  else
      echo "Destroy cancelled"
  fi
}

init () {
  cd "$ROOT_DIR/terraform"
  terraform init -backend-config="init.tfvars"
}

command=$1
case $command in
  init)
    init
    ;;
  apply)
    deploy apply
    ;;
  plan)
    deploy plan
    ;;
  destroy)
    destroy
    ;;
  deploy-lambdas)
    build_lambdas
    ;;
  *)
    echo "[ERROR] Usage: $0 [apply | plan]" >&2
    exit 1
    ;;
esac

