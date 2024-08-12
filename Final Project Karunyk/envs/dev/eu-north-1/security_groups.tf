###
### Security groups
###

# ASG
resource "aws_security_group" "asg" {
  name        = "${var.env}-${var.app_name}-asg-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${var.env}-${var.app_name}-asg-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id            = aws_security_group.asg.id
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.asg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# ALB
resource "aws_security_group" "alb" {
  name        = "${var.env}-${var.app_name}-alb-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${var.env}-${var.app_name}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# RDS
resource "aws_security_group" "db" {
  name        = "${var.env}-${var.app_name}-db-sg"
  description = "Allow inbound traffic for DB and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = merge(var.tags,
    {
      Name = "${var.env}-${var.app_name}-db-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_3306_ipv4" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.asg.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}


# resource "aws_vpc_security_group_ingress_rule" "db" {
#   security_group_id = aws_security_group.db.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 3306
#   ip_protocol       = "tcp"
#   to_port           = 3306
# }

resource "aws_vpc_security_group_egress_rule" "db" {
  security_group_id = aws_security_group.db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
