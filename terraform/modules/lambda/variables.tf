variable "lambda_exec_policy" {
  description = "AWS managed policy that allows lambda execution and writing to cloudwatch logs"
  default     = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  type        = string
}
variable "region" {
  type     = string
  nullable = false
}
variable "bucket" {
  type     = string
  nullable = false
}
variable "env" {
  type     = string
  nullable = false
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
