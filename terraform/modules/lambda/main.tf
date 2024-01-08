data "archive_file" "lambda" {
  type        = "zip"
  count       = length(var.lambdas)
  #  source_dir = ".${path.root}/api/lambda/testResponse/src/"
  #  output_path = ".${path.root}/api/lambda/testResponse/dist/dist.zip"
  source_dir  = "${var.lambdas[count.index].path}/src/"
  output_path = "${var.lambdas[count.index].path}/dist/dist.zip"
}

resource "aws_s3_object" "lambda" {
  bucket = var.bucket
  count = length(var.lambdas)
  key    = "lambda/${var.lambdas[count.index].name}.zip"
  source = data.archive_file.lambda[count.index].output_path
  etag   = filemd5(data.archive_file.lambda[count.index].output_path)
}

resource "aws_lambda_function" "lambda" {
  count         = length(var.lambdas)
  function_name = "${var.lambdas[count.index].name}-${var.env}"
  role          = aws_iam_role.lambda_role.arn

  s3_bucket = var.bucket
  s3_key    = aws_s3_object.lambda[count.index].key

  memory_size = var.lambdas[count.index].memory
  timeout = var.lambdas[count.index].timeout
  runtime = var.lambdas[count.index].runtime
  handler = var.lambdas[count.index].handler

  source_code_hash = data.archive_file.lambda[count.index].output_base64sha256

  environment {
    variables = var.lambdas[count.index].env
    # also add ENV and REGION here
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  count             = length(var.lambdas)
  name              = "/aws/lambda/${aws_lambda_function.lambda[count.index].function_name}"
  retention_in_days = 30
}