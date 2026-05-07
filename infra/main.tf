terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "ansible" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename        = "${path.root}/../ansible/.generated/ansible-ec2.pem"
  content         = tls_private_key.ansible.private_key_pem
  file_permission = "0600"
}

resource "aws_key_pair" "ansible" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.ansible.public_key_openssh
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "ec2_ssh" {
  name        = "${var.project_name}-ssh"
  description = "Allow SSH access for Ansible tutorial"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ssh"
  }
}

resource "aws_instance" "tutorial" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ansible.key_name
  vpc_security_group_ids = [aws_security_group.ec2_ssh.id]

  tags = {
    Name = "${var.project_name}-ec2"
  }
}

# Terraform writes an inventory file directly into ansible/inventory.
resource "local_file" "ansible_inventory" {
  filename = "${path.root}/../ansible/inventory/hosts.ini"
  content  = <<-EOT
[ec2]
${aws_instance.tutorial.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${path.module}/.generated/ansible-ec2.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT
}

resource "local_file" "ansible_inventory_yaml" {
  filename = "${path.root}/../ansible/inventory/hosts.yml"
  content  = <<-EOT
all:
  hosts:
    ec2_tutorial:
      ansible_host: ${aws_instance.tutorial.public_ip}
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ${path.module}/.generated/ansible-ec2.pem
      ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
  children:
    ec2:
      hosts:
        ec2_tutorial:
EOT
}


resource "random_string" "vault_password" {
  length  = 64
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "local_file" "vault_password" {
  filename = "${path.root}/../ansible/config/vault_pass"
  content  = random_string.vault_password.result
  file_permission = "0600"
}
