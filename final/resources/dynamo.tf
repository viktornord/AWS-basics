resource "aws_dynamodb_table" "viktor_dynamo" {
  name = "edu-lohika-training-aws-dynamodb"
  hash_key = "UserName"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "UserName"
    type = "S"
  }
}
