variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Prefix used in resource names"
  type        = string
  default     = "devops-pipeline"
}

variable "vpc_cidr" {
  description = "IP range of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IP range of the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR form, allowed to SSH (for example 1.2.3.4/32)"
  type        = string
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/devops-key.pub"
}

variable "state_bucket_name" {
  description = "Bucket the server may read from (app-config/ prefix only)"
  type        = string
  default     = "devops-pipeline-tfstate-198233241679"
}
