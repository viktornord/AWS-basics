resource "aws_instance" "viktor_nat_ec2" {
  ami = "ami-02623b65d521fbd30"
  key_name = "test-key-pair"
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnet_id
  vpc_security_group_ids = [aws_security_group.ssh_and_web_4_public.id]
  source_dest_check = false
  tags = {
    Name = "viktor_nat_ec2"
  }
}

resource "aws_route_table" "viktor_rt4nat" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "viktor_rt4nat"
  }

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.viktor_nat_ec2.id
  }
}

resource "aws_route_table_association" "viktor_rta4nat" {
  subnet_id      = module.vpc.private_subnet_id
  route_table_id = aws_route_table.viktor_rt4nat.id
}

