
variable "public_subnet_ids" {
  type = map
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}

data "aws_ami" "example" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "web" {
  for_each  = var.public_subnet_ids
  subnet_id = each.value
  associate_public_ip_address = true
  vpc_security_group_ids = [var.security_group_id]
  ami           = data.aws_ami.example.id
  key_name = var.key_name
  instance_type = "t3.micro"
  user_data = <<-EOT
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    systemctl status nginx
  EOT

}

output "instance_ids" {
  value = [for k, v in var.public_subnet_ids: aws_instance.web[k].id]
}