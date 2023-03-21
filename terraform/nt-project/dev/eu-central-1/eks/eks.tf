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
    key    = "dev/eu-central-1/eks/terraform.tfstate"
    region = "eu-west-3"
  }
}

// Explore the resources remote VPC state

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "p81-test-nurkhat-terraform-state"
    key = "dev/eu-central-1/vpc/terraform.tfstate"
    region = "eu-west-3"
  }
}

// Create VPC, subnets, route tables, IGW/NGW

module "eks" {
  source = "../../../../modules/aws_eks"
  project_name       = var.project_name
  public_subnets_id  = data.terraform_remote_state.vpc.outputs.public_subnets[*].id
  private_subnets_id = data.terraform_remote_state.vpc.outputs.private_subnets[*].id
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  eks_inb_ports      = var.eks_inb_ports
  instance_type      = var.instance_type
  desired_size       = var.desired_size
  max_size           = var.max_size
  min_size           = var.min_size
}