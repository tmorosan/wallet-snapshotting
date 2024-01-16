variable "env" {
  type     = string
  nullable = false
}
variable "region" {
  type     = string
  nullable = false
}
variable "lambdas" {
  type = map(string)
}
variable "resource_prefix" {
  type     = string
}