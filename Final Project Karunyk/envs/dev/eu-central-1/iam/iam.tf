###
### IAM Role for EC2 Launch Template
###

resource "aws_iam_instance_profile" "app" {
  name = "${var.env}-${var.app_name}-ec2-lt-role"
  role = aws_iam_role.ec2.name
}

data "aws_iam_policy_document" "ec2" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2" {
  name               = "${var.env}-${var.app_name}-ec2-lt-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
}

resource "aws_iam_policy" "read_ssm_params" {
  name        = "${var.env}-ec2-asg-read-ssm-params"
  path        = "/"
  description = "Allow to get params from SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter*",
          "ssm:GetParameterHistory",
          "ssm:DescribeParameters"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ssm:${local.region}:${local.aws_account}:parameter/${var.env}/*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "read_parameters" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.read_ssm_params.arn
}
