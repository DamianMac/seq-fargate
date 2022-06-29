
resource "aws_alb" "ecs-services-lb" {
  name            = "alb-${var.env_prefix}"
  security_groups = [aws_security_group.load_balancers.id]
  subnets         = var.subnets
  idle_timeout    = 30

  tags = {
    Name = var.tag
  }

}


resource "aws_lb_listener" "http_traffic" {
  load_balancer_arn = aws_alb.ecs-services-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_traffic" {
  load_balancer_arn = aws_alb.ecs-services-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}


resource "aws_security_group" "load_balancers" {
  name        = "load-balancers-${var.env_prefix}"
  description = "Allows all traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
