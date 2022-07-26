variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "cidr" {
  type = string
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.cidr
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_dns_hostnames = true
}

output public_subnet_ids {
  value = {for index, id in module.vpc.public_subnets : format("%s-%s", "subnet", index) => id}
}

output vpc_id {
  value = module.vpc.vpc_id
}