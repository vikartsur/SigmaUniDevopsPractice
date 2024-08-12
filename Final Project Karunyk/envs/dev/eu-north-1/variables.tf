variable "app_name" {
  type        = string
  default     = "app1"
  description = "Application name"
}

variable "db_name" {
  type        = string
  default     = "wordpress"
  description = "Application name"
}

variable "db_username" {
  type        = string
  default     = "admin"
  description = "Application name"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Environment name"
}

variable "asg_ec2_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Instance type for the ASG"
}


variable "tags" {
  type        = map(any)
  default     = {}
  description = "Default tags"
}

