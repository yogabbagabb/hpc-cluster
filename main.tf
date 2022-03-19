provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/subnet"
}

module "ec2" {
  depends_on = [module.vpc]
  source = "./modules/ec2"
  private_subnet_ids = module.vpc.private_subnet_ids
}