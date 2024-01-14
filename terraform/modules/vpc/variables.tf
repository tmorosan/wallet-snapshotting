variable "cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "resource_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}
