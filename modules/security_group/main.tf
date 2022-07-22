
variable "homeIPAddress" {
  type = string
  default = "51.182.57.44/32"
}

variable "vpc_id" {
  type = string
}

variable "elastic_ip_addresses" {
  type = list(string)
}

resource "aws_security_group" "ssh_group" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH into VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.homeIPAddress]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.elastic_ip_addresses
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

output "security_group_id" {
  value = aws_security_group.ssh_group.id
}