provider "aws" {
  region = var.region
}

/**
 AWS Region in which to create the EC2 instances
*/
variable region {
  type = string
}

/**
  Names for each Elastic IP address. One Elastic IP address will be associated to each instance
*/
variable elastic_ip_names {
  type = list(string)
}

/**
  List of Availability Zones for the instances. The first member corresponds to the first instance; the second member to the second instance and so forth.
*/
variable azs {
  type = list(string)
}

/**
  List of private subnets for the instances. The first private subnet corresponds to the first instance; the second private subnet to the second instance and so forth.
*/
variable private_subnets {
  type = list(string)
}

/**
  List of public subnets for the instances. The first public subnet corresponds to the first instance; the second public subnet to the second instance and so forth.
*/
variable public_subnets {
  type = list(string)
}

/**
  The cidr address range for the single VPC housing all the subnets
*/
variable cidr {
  type = string
}

/**
  The IP address of the machine from which you can SSH into an of the instances
*/
variable homeIPAddress {
  type = string
}

/**
  An SSH Public Key that corresponds to the machine sitting at var.homeIPAddress
*/
variable public_key {
  type = string
}


module "vpc" {
  source = "./modules/subnet"
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  cidr = var.cidr
}

module "elastic_ip" {
  source = "./modules/elastic_ip"
  count = length(var.elastic_ip_names)
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  elastic_ip_addresses = [for i, v in module.elastic_ip: "${module.elastic_ip[i].eip_addresses}/32"]
  homeIPAddress = var.homeIPAddress
}

module "key_pair" {
  source = "./modules/key_pair"
  public_key = var.public_key
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
