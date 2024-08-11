data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "global-sigma-devops-terraform-state"
    key    = "option2/dev/eu-central-1/rds/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "global-sigma-devops-terraform-state"
    key    = "option2/dev/eu-central-1/alb/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  alb_dns_name = data.terraform_remote_state.alb.outputs.alb_dns
  rds_address  = data.terraform_remote_state.rds.outputs.rds_address
}