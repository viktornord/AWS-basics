resource "aws_dynamodb_table" "viktor_dynamo" {
  name = "edu-lohika-training-aws-dynamodb"
  hash_key = "UserName"
  attribute {
    name = "UserName"
    type = "String"
  }
}
