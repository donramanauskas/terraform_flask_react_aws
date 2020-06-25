variable "flask_react_demo_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_tenancy" {
  type    = string
  default = "default"
}

variable "availability_zones" {
  type = list(string)
}