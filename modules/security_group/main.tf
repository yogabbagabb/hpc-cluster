
variable "homeIPAddress" {
  type = string
  default = "149.241.72.250/32"
}

variable "vpc_id" {
  type = string
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