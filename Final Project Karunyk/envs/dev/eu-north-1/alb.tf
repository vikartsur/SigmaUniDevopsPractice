###
### ALB
###

resource "aws_lb" "app" {
  name               = "${var.env}-${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.default.ids

  tags = merge(var.tags,
    {
      Environment = var.env
      Custom_tag  = "Works like this"
    }
  )
}

resource "aws_lb_target_group" "app" {
  name = "${var.env}-${var.app_name}-app-tg"

  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/readme.html"
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200"
  }
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "app_asg" {
  listener_arn = aws_lb_listener.default.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
