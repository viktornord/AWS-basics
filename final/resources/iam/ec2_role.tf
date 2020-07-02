module "policy" {
  source = "./policy"
}

resource "aws_iam_role" "ec2_role" {
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_to_access_dynamo_role_policy_attach" {
  policy_arn = module.policy.ec2_2_dynamo_policy_arn
  role = aws_iam_role.ec2_role.name
}
resource "aws_iam_role_policy_attachment" "ec2_to_access_sqs_role_policy_attach" {
  policy_arn = module.policy.ec2_2_sqs_policy_arn
  role = aws_iam_role.ec2_role.name
}
resource "aws_iam_role_policy_attachment" "ec2_to_access_sns_role_policy_attach" {
  policy_arn = module.policy.ec2_2_sns_policy_arn
  role = aws_iam_role.ec2_role.name
}
resource "aws_iam_role_policy_attachment" "ec2_to_access_s3_role_policy_attach" {
  policy_arn = module.policy.ec2_2_s3_policy_arn
  role = aws_iam_role.ec2_role.name
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

output "ec2_role" {
  value = aws_iam_role.ec2_role.name
}
