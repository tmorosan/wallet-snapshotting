variable "key" {
  type = string
  nullable = false
}
variable "bucket" {
  type = string
  nullable = false
}
variable "dynamodb_table" {
  type = string
  nullable = false
}
variable "env" {
  type = string
  nullable = false
}
variable "region" {
  type = string
  nullable = false
}
variable "project" {
  type = string
  nullable = false
}
variable "vpc_cidr" {
  type = string
  nullable = false
}
variable "availability_zones" {
  type = list(string)
  nullable = false
}
# Pretty sure linter is stupid, default values for optional variables have been available
# since terraform 1.3
variable "lambda_configs" {
  type = list(object({
    name    = string
    memory  = optional(number)
    timeout = optional(number)
    runtime = optional(string)
    handler = optional(string)
    env     = optional(map(string))
  }))
  nullable = false
}
