# Provision a Private Cluster of EC2 Instances

## Description

High Permance Computing (HPC) workloads often require multiple instances to perform work. Moreoever, HCP workloads need to remain relatively isolated from the internet.

This module allows one to create an arbitrary number of EC2 instances, where the instances are:

- Held behind a common security group such that:
    - They are only accessible through SSH from a single machine (e.g. your development machine)
    - Capable of communicating with each other via HTTP or HTTPS
    - Incapable of receiving HTTP/HTTPS calls from the internet except when a call is a response to a request initiated by some instance
- Capable of running a start up script
- Capable of being placed in arbitrary subnets and availability zones (facilitating redundancy) within a single region.

A common scenario is:

- You spin up a master server
- Through this module, you spin up several instances, each of which executes a script
- Through the script, each instance does a job dispensed by the master server.
- For example, I developed a docker image for running a flask instance [here](https://github.com/yogabbagabb/nginx-docker). At present, the image is run on each EC2 instance.

![Alt text](/readmeAssets/masterSlave.png "A Common Scenario")

## Usage

- For this module to work, you need to have installed terraform and configured terraform to use your aws account.
- This module relies on the 8 arguments documented below.

If collected into a variables file, like [terraform.tfvars](/terraform.tfvars), then one can run the module using: 

`terraform apply -var-file="terraform.tfvars"`


```terraform

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


```

Finally, it should be noted that the ec2 instances are initialized from Ubuntu AMIs. They also each run a docker image whose configuration is available [here](https://github.com/yogabbagabb/nginx-docker). These settings can be managed at [./modules/ec2/main.tf](./modules/ec2/main.tf).

## Contributing

### Roadmap

This project has a few needs:

- The configuration of each instance is presently expressed through a collection of arrays. In other words, given two arrays `A` and `B`, `A[0]` and `B[0]` both describe the first instance, while `A[1]` and `B[1]` both describe the second instance.
  - It would be neater to describe the configuration of each instance through an array of objects, where each object corresponds to an instance


## License

The MIT License (MIT)

Copyright © 2022 <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

