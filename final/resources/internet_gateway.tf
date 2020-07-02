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
