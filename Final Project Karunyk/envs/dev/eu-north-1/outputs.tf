
output "vpc_id" {
  value = data.aws_vpc.default.id
}
output "vpc_cidr_block" {
  value = data.aws_vpc.default.cidr_block
}

output "vpc_subnets_ids" {
  value = data.aws_subnets.default.ids
}

output "ami_id" {
  value = data.aws_ami.ami.id
}

output "load_balancer_dns" {
  value = try(aws_lb.app.dns_name, "")
}

output "db_dns" {
  value = try(aws_db_instance.db.address, "")
}