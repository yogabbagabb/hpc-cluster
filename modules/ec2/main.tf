
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
}
