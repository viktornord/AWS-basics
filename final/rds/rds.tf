resource "aws_db_instance" "my_db_instance" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "postgres"
  name = "EduLohikaTrainingAwsRds",
  instance_class = "db.t2.micro"
  username = "rootuser"
  password = "rootuser"
  skip_final_snapshot = true
//  vpc_security_group_ids = [aws_security_group.db_security_group.id]
}
