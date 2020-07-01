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
  availability_zone = "us-east-1a"
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.viktor_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private_subnet"
  }
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "public_subnet_cidr" {
  value = aws_subnet.public_subnet.cidr_block
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "vpc_id" {
  value = aws_vpc.viktor_vpc.id
}
