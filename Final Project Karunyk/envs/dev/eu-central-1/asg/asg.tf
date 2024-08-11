###
### ASG
###

resource "aws_launch_template" "app" {
  name                   = "${var.env}-${var.app_name}"
  image_id               = local.ami_id
  instance_type          = var.asg_ec2_instance_type
  vpc_security_group_ids = [local.asg_sg_id]

  user_data = base64encode(<<-EOF
  #!/bin/bash

  sudo yum update -y
  sudo yum install -y docker
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -a -G docker ec2-user

  sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  mkdir -p /app/final

  export DB_PASSWORD=$(aws ssm get-parameter --name "/${var.env}/db-${var.app_name}/password" --with-decryption --query "Parameter.Value" --output text)
  export DB_USERNAME=$(aws ssm get-parameter --name "/${var.env}/db-${var.app_name}/username" --with-decryption --query "Parameter.Value" --output text)
  export DB_URL=$(aws ssm get-parameter --name "/${var.env}/db-${var.app_name}/url" --with-decryption --query "Parameter.Value" --output text)
  export DB_NAME=$(aws ssm get-parameter --name "/${var.env}/db-${var.app_name}/name" --with-decryption --query "Parameter.Value" --output text)

  docker run -d \
    --name wordpress \
    -p 80:80 \
    --restart always \
    -e WORDPRESS_DB_HOST=$DB_URL \
    -e WORDPRESS_DB_USER=$DB_USERNAME \
    -e WORDPRESS_DB_PASSWORD=$DB_PASSWORD \
    -e WORDPRESS_DB_NAME=$DB_NAME \
    wordpress:latest

  EOF
  )

  iam_instance_profile {
    arn = local.ec2_instance_profile_arn
  }

  block_device_mappings {
    # Root volume
    device_name = "/dev/xvda"
    no_device   = 0
    ebs {
      delete_on_termination = true
      encrypted             = false
      volume_size           = 20
      volume_type           = "gp3"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name             = "${var.env}-${var.app_name}"
  desired_capacity = 1
  max_size         = 3
  min_size         = 1

  health_check_grace_period = 300
  health_check_type         = "ELB"

  vpc_zone_identifier = local.subnets
  target_group_arns   = [local.target_group_arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Terraform"
    value               = "True"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.app_name}"
    propagate_at_launch = true
  }
}