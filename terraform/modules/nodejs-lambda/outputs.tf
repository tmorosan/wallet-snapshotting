output "lambda_arns" {
  value = {
    for lambda in aws_lambda_function.lambda : lambda.function_name => lambda.arn
  }
}
