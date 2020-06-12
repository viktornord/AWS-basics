provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "my_security_group" {
  name = "my security group"
  description = "test security group"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
     cidr_blocks = ["0.0.0.0/0"]
     from_port = 0
     to_port = 0
     protocol = "-1"
  }
}

resource "aws_instance" "my_ec2_instance" {
  ami = "ami-0323c3dd2da7fb37d"
  key_name = "test-key-pair"
  security_groups = [aws_security_group.my_security_group.name]
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.my_instance_profile.name
  user_data = file("user_data.sh")
}

resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my_instance_profile_x"
  role = aws_iam_role.my_iam_role.name
}

resource "aws_iam_role" "my_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy" "my_role_policy" {
  name = "ec2_to_read_s3"
  role = aws_iam_role.my_iam_role.id
  policy = data.aws_iam_policy_document.ec2_s3_read_policy.json
}
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "ec2_s3_read_policy" {
  statement {
    effect = "Allow"
    actions   = ["s3:Get*"]
    resources = ["arn:aws:s3:::vurbanas-bucket/*"]
  }
}
