provider "aws" {
  region = "us-east-1"
}

locals  {
  elastic_ip_names = toset(["A", "B", "C", "D"])
}

variable elastic_ip_names {
  type = set(string)
}

variable azs {
  type = list(string)
}

variable private_subnets {
  type = list(string)
}

variable public_subnets {
  type = list(string)
}

variable cidr {
  type = string
}

variable homeIpAddress {
  type = string
}

variable public_key {
  type = string
}


module "vpc" {
  source = "./modules/subnet"
  azs = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]
  cidr = "10.0.0.0/16"
}

module "elastic_ip" {
  source = "./modules/elastic_ip"
  count = 4
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  elastic_ip_addresses = [for i, v in module.elastic_ip: "${module.elastic_ip[i].eip_addresses}/32"]
  homeIPAddress = "51.182.57.44/32"
}

module "key_pair" {
  source = "./modules/key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDyIX0QZx749JxbjSBubyf9viXO4baSMmRJaqPSvkDVzqs08I9/jzmbs/5LBFJt7bL07j3hkIPi++k2uXrYuaejUx9rr8/F3oGX4PvUDXs1bF3nO0wmRbZmfSthTbYTLRuVPCCxvkfxrCc1o6D6ycLA+uX6rSYqaPPEz8SLTshfnZm2GZWznMyMUH0trKHRLdpSBjLT6hn5s9az6vxWjj/ksaqhMwGR3uxgksbt4hZR1/gIrhCQpS1P1k384r0V0MmTkwcnKLFZW6B1KnrbuYe4K9cetEHKz3OUKyUidXGc2eMqCYSNAbAAKKGbfgx5oXO8FIq2DnHxkPx0dVxZZ1s92ySAOjBwSo/I9OgkfukXBNYsN+RGAeHPJGeL6AYoNMof46PBxdMyM7k4+VgO+0xoKkmT2ekg16EP9CQ1rkq8zEw+POu/oOrNSFJx5t9pvbsgI3B2zqHbpPMhEKBfp4t3HOydPQFzC/KCHBucuO/dYtHw+pFvhNRC1sEI5eGqKE= anjaliagrawal@Anjalis-Air-2"
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