variable "env" {
  type = string
  nullable = false
}
variable "region" {
  type = string
  nullable = false
}
variable "vpc_arn" {
  type = string
  nullable = false
}
# these two could be replaced by lists,
# only other necessary change would be to add a list of the routes
#variable "lambda_arn" {
#  type = string
#  nullable = false
#}
#variable "lambda_name" {
#  type = string
#  nullable = false
#}

# add type
variable "lambdas" { }