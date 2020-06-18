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
resource "aws_security_group" "db_security_group" {
  name = "db security group"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
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

resource "aws_dynamodb_table" "test_dynamo_table" {
  name = "testdb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"
  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_db_instance" "my_db_instance" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "postgres"
  instance_class = "db.t2.micro"
  username = "qwerty"
  password = "qwerty123456"
  skip_final_snapshot = true
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
}

resource "aws_iam_role" "my_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_to_read_s3_role_policy_attach" {
  policy_arn = aws_iam_policy.ec2_to_read_s3_role_policy.arn
  role = aws_iam_role.my_iam_role.name
}
resource "aws_iam_role_policy_attachment" "ec2_to_access_dynamo_role_policy_attach" {
  policy_arn = aws_iam_policy.ec2_to_access_dynamo_role_policy.arn
  role = aws_iam_role.my_iam_role.name
}

resource "aws_iam_policy" "ec2_to_read_s3_role_policy" {
  name = "ec2_to_read_s3"
  policy = data.aws_iam_policy_document.ec2_s3_read_policy.json
}

resource "aws_iam_policy" "ec2_to_access_dynamo_role_policy" {
  name = "ec2_to_access_dynamo"
  policy = data.aws_iam_policy_document.ec2_to_access_dynamo_policy.json
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
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::vurbanas-bucket/*"]
  }
  statement {
    effect = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::vurbanas-bucket"]
  }
}

data "aws_iam_policy_document" "ec2_to_access_dynamo_policy" {
  statement {
    effect = "Allow"
    actions   = ["dynamodb:Query", "dynamodb:Scan", "dynamodb:BatchWriteItem"]
    resources = ["arn:aws:dynamodb:us-east-1:*:table/testdb"]
  }
  statement {
    effect = "Allow"
    actions   = ["dynamodb:ListTables"]
    resources = ["arn:aws:dynamodb:us-east-1:*:*"]
  }
}
