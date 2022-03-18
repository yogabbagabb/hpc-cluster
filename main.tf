provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "aws_vpc_count" {
    count = 4
    cidr = format("10.%d.0.0/16", 16 + count.index)
us-east-1a
us-east-1b
us-east-1c
us-east-1d

}

