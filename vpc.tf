provider "aws" {
    region = "ap-south-1"//ap-south-1 mumbai region it has three subnets
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

data "aws_availability_zones" "azs" {
    //this query from aws how many regions in the zone
}

module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"//Provision Instructions Copy and paste into our Terraform configuration, insert the variables, and run terraform init:

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block

  //best practice one public and private subnet for each availability zone
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs =data.aws_availability_zones.azs.names //use these zone for defined subnets

  enable_nat_gateway = true
  single_nat_gateway = true //all private subnets will route their inyernet traffics through this single NAT gatway
  enable_dns_hostnames = true

  tags = {
    "kubernetes.i0/cluster/myapp-eks-cluster"="shared"
  }

  public_subnet_tags = {
    "kubernetes.i0/cluster/myapp-eks-cluster"="shared"
    "kubernetes.i0/role/elb"=1 //public load balancer

  }

  private_subnet_tags = {
    "kubernetes.i0/cluster/myapp-eks-cluster"="shared"
    "kubernetes.i0/role/private-elb"=1 //private load balancer
  }


}

