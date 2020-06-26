variable "availability_zones" {
  type = list(string)
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}