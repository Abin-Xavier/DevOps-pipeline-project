variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "my_ip_cidr" {
  type = string
}

variable "ssh_open_to_world" {
  type    = bool
  default = false
}
