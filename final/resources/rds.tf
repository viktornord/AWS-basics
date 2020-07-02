resource "aws_security_group" "db_security_group" {
  vpc_id = module.vpc.vpc_id
  name = "db security group"
  ingress {
    cidr_blocks = [module.vpc.private_subnet_cidr]
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name = "my_db_subnet_group"
  subnet_ids = [module.vpc.private_subnet_id, module.vpc.public_subnet2_id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "my_db_instance" {
  identifier = "viktor-db"
  allocated_storage = 20
  storage_type = "gp2"
  engine = "postgres"
  name = "EduLohikaTrainingAwsRds"
  instance_class = "db.t2.micro"
  username = "rootuser"
  password = "rootuser"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
}
