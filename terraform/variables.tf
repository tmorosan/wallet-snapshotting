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
variable "vpc_cidr" {
  type = string
  nullable = false
}
variable "public_subnets_cidr" {
  type        = list(string)
  nullable    = false
}
variable "private_subnets_cidr" {
  type        = list(string)
  nullable    = false
}
# Pretty sure linter is stupid, default values for optional variables have been available
# since terraform 1.3
variable "lambdas" {
  type = list(object({
    name    = string
    path    = string
    memory  = optional(number, 128)
    timeout = optional(number, 30)
    runtime = optional(string, "nodejs18.x")
    handler = optional(string, "index.handler")
    env     = optional(map(string), {})
  }))
  nullable = false
}
