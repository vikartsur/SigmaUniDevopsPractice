provider "aws" {
  region = "eu-central-1"
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
    key            = "option2/dev/eu-central-1/asg/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "global-sigma-devops-terraform-lock"

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.39.1"
    }
  }
}
