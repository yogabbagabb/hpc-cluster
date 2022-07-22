provider "aws" {
  region = "us-east-1"
}

locals  {
  elastic_ip_names = toset(["A", "B", "C", "D"])

}

module "vpc" {
  source = "./modules/subnet"
}

module "elastic_ip" {
  source = "./modules/elastic_ip"
  count = 4
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  elastic_ip_addresses = [for i, v in module.elastic_ip: "${module.elastic_ip[i].eip_addresses}/32"]
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

module "elastic_ip_associations" {
  source = "./modules/elastic_ip_associations"
  allocation_ids = module.elastic_ip[*].eip_allocation_ids
  instance_ids = module.ec2.instance_ids
}