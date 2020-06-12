provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "viktor_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "viktor_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.viktor_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.viktor_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "viktro_gw" {
  vpc_id = aws_vpc.viktor_vpc.id
  tags = {
    Name = "viktro_gw"
  }
}

resource "aws_route_table" "viktor_rt" {
  vpc_id = aws_vpc.viktor_vpc.id
  tags = {
    Name = "viktor_rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.viktro_gw.id
  }
}

resource "aws_route_table_association" "viktor_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.viktor_rt.id
}

resource "aws_security_group" "ssh_and_web_4_public" {
  vpc_id = aws_vpc.viktor_vpc.id
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
  ingress {
    cidr_blocks = [aws_subnet.private_subnet.cidr_block]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}

resource "aws_security_group" "ssh_and_web_4_private" {
  vpc_id = aws_vpc.viktor_vpc.id
  name = "private security group"
  ingress {
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "SSH access"
  }
  ingress {
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
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
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
    from_port = -1
    to_port = -1
    protocol = "icmp"
    description = "PING"
  }
}

resource "aws_instance" "viktor_public_ec2" {
  ami = "ami-0323c3dd2da7fb37d"
  key_name = "test-key-pair"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_and_web_4_public.id]
  tags = {
    Name = "viktor_public_ec2"
  }
  user_data = file("user_data_public.sh")
}

resource "aws_instance" "viktor_nat_ec2" {
  ami = "ami-02623b65d521fbd30"
  key_name = "test-key-pair"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_and_web_4_public.id]
  source_dest_check = false
  tags = {
    Name = "viktor_nat_ec2"
  }
}

resource "aws_route_table" "viktor_rt4nat" {
  vpc_id = aws_vpc.viktor_vpc.id
  tags = {
    Name = "viktor_rt4nat"
  }

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.viktor_nat_ec2.id
  }
}

resource "aws_route_table_association" "viktor_rta4nat" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.viktor_rt4nat.id
}

resource "aws_instance" "viktor_private_ec2" {
  ami = "ami-0323c3dd2da7fb37d"
  key_name = "test-key-pair"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_and_web_4_private.id]
  tags = {
    Name = "viktor_private_ec2"
  }
  user_data = file("user_data_private.sh")
}

resource "aws_lb_target_group" "viktor_lb_tg" {
  name     = "viktorLbTg"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.viktor_vpc.id
}
//
resource "aws_lb_target_group_attachment" "viktor_lb_t_private" {
  target_group_arn = aws_lb_target_group.viktor_lb_tg.arn
  target_id = aws_instance.viktor_private_ec2.id
  port = 80
}

resource "aws_lb_target_group_attachment" "viktor_lb_t_public" {
  target_group_arn = aws_lb_target_group.viktor_lb_tg.arn
  target_id = aws_instance.viktor_public_ec2.id
  port = 80
}

resource "aws_lb" "viktor_lb" {
  name = "viktorLb"
  internal  = false
  load_balancer_type = "application"
  subnets = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
}

//
//resource "aws_lb_listener" "viktor_lb_tg" {
//  load_balancer_arn = aws_lb.viktor_lb.arn
//  port = "80"
//  protocol = "HTTP"
//
//  default_action {
//    type = "forward"
//    target_group_arn = aws_lb_target_group.viktor_lb_tg.arn
//  }
//}
