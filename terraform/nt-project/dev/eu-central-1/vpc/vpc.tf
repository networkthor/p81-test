terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

// Use S3 as the remote state backend

terraform {
  backend "s3" {
    bucket = "p81-test-nurkhat-terraform-state"
    key    = "dev/eu-central-1/vpc/terraform.tfstate"
    region = "eu-west-3"
  }
}

// Create VPC, subnets, route tables, IGW/NGW

module "vpc" {
  source          = "../../../../modules/aws_vpc"
  vpc_cidr        = var.vpc_cidr
  project_name    = var.project_name
  region          = var.region
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}
