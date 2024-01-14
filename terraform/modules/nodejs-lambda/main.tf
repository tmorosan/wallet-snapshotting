locals {
  lambdas = {for lambda in var.lambda_configs : lambda.name => lambda}
}

resource "aws_lambda_function" "lambda" {
  for_each      = local.lambdas
  role          = aws_iam_role.lambda_role.arn
  function_name = "${var.resource_prefix}-${each.value.name}-${var.env}"

  filename         = "${path.module}/dist.zip"
  source_code_hash = filebase64sha256("${path.module}/dist.zip")

  memory_size = each.value.memory
  timeout     = each.value.timeout
  runtime     = each.value.runtime
  handler     = each.value.handler

  vpc_config {
    security_group_ids = [var.security_group_id]
    subnet_ids         = var.subnet_ids
  }
  environment {
    variables = each.value.env
    # also add ENV and REGION here
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  for_each          = aws_lambda_function.lambda
  name              = "/aws/lambda/${each.value.function_name}"
  retention_in_days = 30
}