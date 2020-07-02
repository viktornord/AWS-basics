resource "aws_iam_policy" "ec2_to_access_dynamo_role_policy" {
  name = "ec2_to_access_dynamo"
  policy = data.aws_iam_policy_document.ec2_to_access_dynamo_policy.json
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

output "ec2_2_dynamo_policy_arn" {
  value = aws_iam_policy.ec2_to_access_dynamo_role_policy.arn
}
