output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "subnets" {
  value = data.aws_subnets.default.ids
}

output "ami_id" {
  value = data.aws_ami.ami.id
}