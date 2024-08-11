data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "global-sigma-devops-terraform-state"
    key    = "option2/dev/eu-central-1/vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "alb_sg" {
  backend = "s3"
  config = {
    bucket = "global-sigma-devops-terraform-state"
    key    = "option2/dev/eu-central-1/security_groups/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  vpc_id    = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets   = data.terraform_remote_state.vpc.outputs.subnets
  alb_sg_id = data.terraform_remote_state.alb_sg.outputs.alb_sg_id
}