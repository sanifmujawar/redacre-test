resource "aws_security_group" "allow_http" {
  name_prefix = "${var.default_tag.Project}-allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.main.id
}
resource "aws_security_group_rule" "allow_http_rule_in" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.allow_http.id
  description       = "Allow HTTP trafic"
}
resource "aws_security_group_rule" "allow_http_rule_in-5000" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.allow_http.id
  description       = "Allow HTTP trafic"
}
resource "aws_security_group_rule" "allow_http_rule_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.allow_http.id
  description       = "Allow any outbout trafic"
}

resource "aws_security_group" "allow_ecs_80" {
  name_prefix = "${var.default_tag.Project}-allow_containerTrafic"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "allow_80_rule_in_1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.allow_ecs_80.id
  description       = "Allow trafic on port 80"
}

resource "aws_security_group_rule" "allow_ecs_80_rule_in_2" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = aws_security_group.allow_ecs_80.id
  description       = "Allow trafic from resources within this sg"
}
resource "aws_security_group_rule" "allow_ecs_80_rule_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.allow_ecs_80.id
  description       = "Allow any outbout trafic"
}

resource "aws_security_group" "allow_http-api" {
  name_prefix = "${var.default_tag.Project}-allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "allow_http_rule_in-api" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  source_security_group_id = aws_security_group.allow_http.id
  security_group_id = aws_security_group.allow_http-api.id
  description       = "Allow HTTP trafic on port 5000"
}

resource "aws_security_group_rule" "allow_http_rule_out-api" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_http-api.id
  description       = "Allow any outbout trafic"
}




