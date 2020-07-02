resource "aws_launch_configuration" "aws_linux" {
  name = "auto scaling launch configuration for public instances"
  instance_type = "t2.micro"
  image_id = "ami-0323c3dd2da7fb37d"
  //  security_groups = []
  key_name = "test-key-pair"
  security_groups    = [aws_security_group.ssh_and_web_4_public.id]
  iam_instance_profile = aws_iam_instance_profile.viktor_instance_profile.name
  user_data = file("resources/user_data_public.sh")
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
  ingress {
    cidr_blocks = [module.vpc.private_subnet_cidr]
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
  iam_instance_profile = aws_iam_instance_profile.viktor_instance_profile.name
  vpc_security_group_ids = [aws_security_group.ssh_and_web_4_private.id]
  user_data = file("resources/user_data_private.sh")
}

resource "aws_iam_instance_profile" "viktor_instance_profile" {
  name = "viktor_instance_profile"
  role = module.iam.ec2_role
}
