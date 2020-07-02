resource "aws_security_group" "lb_security_group" {
  name = "lb security group"
  vpc_id = module.vpc.vpc_id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
    description = "HTTP access"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}

resource "aws_alb" "viktor_lb" {
  name = "viktorLb"
  internal  = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  // why should i specify both subnets? At least two subnets in two different Availability Zones must be specified
  subnets = [module.vpc.public_subnet_id, module.vpc.public_subnet2_id]
}


resource "aws_alb_target_group" "viktor_lb_tg" {
  name     = "viktorLbTg"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_autoscaling_attachment" "auto_scpublic_auto_scaling_group_attachement" {
  autoscaling_group_name = aws_autoscaling_group.public_auto_scaling_group.id
  alb_target_group_arn = aws_alb_target_group.viktor_lb_tg.arn
}


resource "aws_lb_listener" "viktor_lb_listener" {
  load_balancer_arn = aws_alb.viktor_lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.viktor_lb_tg.arn
  }
}
