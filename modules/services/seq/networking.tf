resource "aws_security_group" "private-ports" {
  name        = "seq-priv"
  description = "Private Ports"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_alb_target_group" "seq" {
  name_prefix          = "seq"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 0
  slow_start           = 0
  target_type          = "ip"


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 20
    path                = "/health"
  }

  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_lb_listener_rule" "seq" {
  listener_arn = var.https_listener_arn
  priority     = 91

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.seq.arn
  }

  condition {
    host_header {
      values = ["seq.*"]
    }

  }
  lifecycle {
    create_before_destroy = true
  }
}
