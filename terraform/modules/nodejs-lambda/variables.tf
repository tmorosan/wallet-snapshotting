variable "lambda_exec_policy" {
  description = "AWS managed policy that allows lambda execution and writing to cloudwatch logs"
  default     = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  type        = string
}
variable "region" {
  type     = string
}
variable "env" {
  type     = string
}
variable "security_group_id" {
  type     = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "resource_prefix" {
  type = string
}

# linter is stupid, default values for optional variables have been available since terraform 1.3
variable "lambda_configs" {
  type = list(object({
    name    = string
    memory  = optional(number, 128)
    timeout = optional(number, 30)
    runtime = optional(string, "nodejs18.x")
    handler = optional(string, "index.handler")
    env     = optional(map(string), {})
  }))
  nullable = false
}

variable "lambda_global_env" {
  type = map(string)
  default = {}
}