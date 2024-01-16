# chose regional endpoint type because the only client (cc) will be in the same region ?
# this should be v2 http api instead, as it is cheaper and we don't need the features of v1
resource "aws_apigatewayv2_api" "api" {
  name          = "${var.resource_prefix}-api-${var.env}"
  protocol_type = "HTTP"
  # this is not ideal, adding a lambda should only mean defining the route in the swagger file
  body = templatefile(yamldecode(".${path.root}/api/swagger.yaml"),
    { for k, v in var.lambdas : "lambda_${k}" => v}
  )
}


#resource "aws_apigatewayv2_authorizer" "api_authorizer" {
#  api_id          = ""
#  authorizer_type = "JWT"
#  name            = ""
#}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.api.id
  name = var.env
  auto_deploy = true
}
