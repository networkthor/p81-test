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
    key    = "dev/eu-central-1/ecr/terraform.tfstate"
    region = "eu-west-3"
  }
}

// Create Elastic Container Registry

module "ecr" {
  source = "../../../../modules/aws_ecr"
  project_name     = var.project_name
  reponame         = var.reponame
  image_mutability = var.image_mutability
  encrypt_type     = var.encrypt_type
  tags             = var.tags
}
