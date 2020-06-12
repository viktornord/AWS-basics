provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_security_group" "my_security_group" {
  name = "my security group"
  description = "test group"

  ingress {
    description = "SSH access"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  }
  ingress {
    description = "HTTP access"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  }
}

resource "aws_launch_configuration" "aws_linux" {
  name = "my auto scaling launch configuration"
  instance_type = "t2.micro"
  image_id = "ami-0323c3dd2da7fb37d"
  security_groups = [aws_security_group.my_security_group.name]
  key_name = "test-key-pair"
}
resource "aws_autoscaling_group" "my_auto_scaling_group" {
  launch_configuration = aws_launch_configuration.aws_linux.name
  availability_zones = ["us-east-1a"]
  max_size = 2
  min_size = 2
}
