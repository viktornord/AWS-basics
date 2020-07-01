module "vpc" {
  source = "../vpc"
}

//-----------------------       EC2      ---------------------------------

resource "aws_launch_configuration" "aws_linux" {
  name = "auto scaling launch configuration for public instances"
  instance_type = "t2.micro"
  image_id = "ami-0323c3dd2da7fb37d"
  //  security_groups = []
  key_name = "test-key-pair"
  user_data = file("./user_data_public.sh")
  security_groups    = [aws_security_group.ssh_and_web_4_public.id]
}
resource "aws_autoscaling_group" "public_auto_scaling_group" {
  launch_configuration = aws_launch_configuration.aws_linux.name
  availability_zones = ["us-east-1a"]
  vpc_zone_identifier = [module.vpc.public_subnet_id]
  max_size = 2
  min_size = 2
}

resource "aws_security_group" "ssh_and_web_4_public" {
  vpc_id = module.vpc.vpc_id
  name = "public security group"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "SSH access"
  }
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
resource "aws_security_group" "ssh_and_web_4_private" {
  vpc_id = module.vpc.vpc_id
  name = "private security group"
  ingress {
    cidr_blocks = [module.vpc.public_subnet_cidr]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "SSH access"
  }
  ingress {
    cidr_blocks = [module.vpc.public_subnet_cidr]
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
  ingress {
    cidr_blocks = [module.vpc.public_subnet_cidr]
    from_port = -1
    to_port = -1
    protocol = "icmp"
    description = "PING"
  }
}
resource "aws_instance" "viktor_private_ec2" {
  ami = "ami-0323c3dd2da7fb37d"
  key_name = "test-key-pair"
  instance_type = "t2.micro"
  subnet_id = module.vpc.private_subnet_id
  tags = {
    Name = "viktor_private_ec2"
  }
}

//-----------------------       LB      ---------------------------------

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
  subnets = [module.vpc.public_subnet_id, module.vpc.private_subnet_id]
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


resource "aws_internet_gateway" "viktro_gw" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "viktro_gw"
  }
}

resource "aws_route_table" "viktor_rt" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "viktor_rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.viktro_gw.id
  }
}

resource "aws_route_table_association" "viktor_rta" {
  subnet_id = module.vpc.public_subnet_id
  route_table_id = aws_route_table.viktor_rt.id
}
