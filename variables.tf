variable "vpc_cidr" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "project_location" {
  type = string
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}