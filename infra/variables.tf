variable "project_name" {
  description = "Prefix used for created resources"
  type        = string
  default     = "tutorial-ansible"
}

variable "aws_region" {
  description = "AWS region where resources are created"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance size for the tutorial host"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH into the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
