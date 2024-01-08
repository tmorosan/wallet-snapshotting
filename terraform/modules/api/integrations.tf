# apparently v2 api only needs integration and route, very coolter
resource "aws_apigatewayv2_integration" "test_post" {
  count = length(var.lambdas)
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_method = "POST"
  integration_uri  = var.lambdas[count.index].arn
}

resource "aws_apigatewayv2_route" "test_post" {
  api_id    = aws_apigatewayv2_api.api.id
  count = length(var.lambdas)
  route_key = "GET /${var.lambdas[count.index].function_name}"
  target    = "integrations/${aws_apigatewayv2_integration.test_post[count.index].id}"
}

# this allows api gateway to execute any lambda function
resource "aws_lambda_permission" "test_post" {
  action        = "lambda:InvokeFunction"
  count = length(var.lambdas)
  function_name = var.lambdas[count.index].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*"
}