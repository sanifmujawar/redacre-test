resource "aws_lb" "alb" {
  name_prefix        = "alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = aws_subnet.public.*.id
  idle_timeout       = 30
  ip_address_type    = "dualstack"

  tags = {
    "Name" = "${var.default_tag.Project}-alb"
  }
}

# User facing Client Target group
resource "aws_lb_target_group" "aws_tg" {
  name                 = "awstg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 30
  target_type          = "ip"

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 15
    interval            = 30
    protocol            = "HTTP"
  }

  tags = {
    "Name" = "${var.default_tag.Project}-alb"
  }
}

resource "aws_lb_target_group" "aws_tg-api-5000" {
  name                 = "awstg-api-5000"
  port                 = 5000
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 30
  target_type          = "ip"

  health_check {
    enabled             = true
    path                = "/stats"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 15
    interval            = 30
    protocol            = "HTTP"
  }

  tags = {
    "Name" = "${var.default_tag.Project}-alb"
  }
}

resource "aws_lb_listener" "listener_http_80" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_tg.arn
  }

}

resource "aws_lb_listener" "listener_http_5000" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_tg-api-5000.arn
  }

}