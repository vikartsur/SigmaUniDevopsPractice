data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ami" {
  most_recent = true
  filter {
    name = "name"
    # values = ["*ubuntu*24*-amd64-server-*"]
    values = ["al2023-ami-2023*x86_64*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["137112412989"]
}


data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  region      = data.aws_region.current.name
  aws_account = data.aws_caller_identity.current.account_id
}
