terraform {
  required_version = "1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.24.0"
    }
  }
}

locals {
  port = 8080
}

data "aws_ami" "linux_2023_x86" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_autoscaling_group" "example" {
  name                = "${var.cluster_name}-asg"
  min_size            = 2
  max_size            = 2
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.asg.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "tf-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "example" {
  name_prefix   = "tf-example-"
  image_id      = data.aws_ami.linux_2023_x86.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.example.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
    nohup python3 -m http.server ${local.port} &
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "example" {
  name               = "${var.cluster_name}-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "${var.cluster_name}-tg"
  port     = local.port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_security_group" "alb" {
}

resource "aws_security_group_rule" "alb_in_http" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_eg_http" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "example" {
}

resource "aws_security_group_rule" "allow_http_8080" {
  security_group_id = aws_security_group.example.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = local.port
  to_port           = local.port
  cidr_blocks       = ["0.0.0.0/0"]
}
