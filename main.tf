provider "aws" {
  region = var.region-master
}

module "SG" {
  source = "./modules/SG"

  sg-name = "${var.project[terraform.workspace]}-SG-${terraform.workspace}"
  vpc-id  = module.VPC.vpc-id
}

module "VPC" {
  source = "./modules/VPC"

  vpc-name = "${var.project[terraform.workspace]}-VPC-${terraform.workspace}"
}