provider "aws" {
  region = "eu-north-1"
  default_tags {
    tags = {
      Application = "Sigma DevOps Course"
    }
  }
}

terraform {
  required_version = ">= 1.7.0"
  backend "s3" {
    bucket         = "global-sigma-devops-terraform-state"
    key            = "final/dev"
    region         = "eu-north-1"
    dynamodb_table = "global-sigma-devops-terraform-lock"

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.39.1"
    }
  }
}
###
