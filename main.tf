provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/subnet"
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "key_pair" {
  source = "./modules/key_pair"
}

module "ec2" {
  depends_on = [module.vpc]
  source = "./modules/ec2"
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_group.security_group_id
  key_name = module.key_pair.key_name
}