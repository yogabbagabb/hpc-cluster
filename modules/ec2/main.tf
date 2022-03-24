
variable "private_subnet_ids" {
  type = map
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
  for_each  =  var.private_subnet_ids
  subnet_id = each.value
  ami           = data.aws_ami.example.id
  instance_type = "t3.micro"
  user_data = <<-EOF
            #! /bin/bash
          sudo yum install epel-release
          sudo yum update -y
          sudo amazon-linux-extras enable nginx1.12
          sudo yum -y install nginx
          sudo systemctl start nginx
          sudo systemctl enable nginx
          chmod 2775 /usr/share/nginx/html
          find /usr/share/nginx/html -type d -exec chmod 2775 {} \;
          find /usr/share/nginx/html -type f -exec chmod 0664 {} \;
          echo "<h3> Nginx server</h3>" > /usr/share/nginx/html/index.html
  EOF
}
