output "asg_sg_id" {
  value = aws_security_group.allow_all.id
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}