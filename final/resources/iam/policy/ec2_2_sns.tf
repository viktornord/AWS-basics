resource "aws_iam_policy" "ec2_to_access_sns_role_policy" {
  name = "ec2_to_access_sns"
  policy = data.aws_iam_policy_document.ec2_to_access_sns_policy.json
}

data "aws_iam_policy_document" "ec2_to_access_sns_policy" {
  statement {
    effect = "Allow"
    actions   = [
      "sns:ListSubscriptionsByTopic",
      "sns:Subscribe",
      "sns:Publish",
    ]
    resources = ["arn:aws:sns:us-east-1:*:edu-lohika-training-aws-sns-topic"]
  }
  statement {
    effect = "Allow"
    actions   = [
      "sns:CreateTopic",
      "sns:ListTopics",
      "sns:Unsubscribe",
      "sns:ListSubscriptions",
    ]
    resources = ["*"]
  }
}

output "ec2_2_sns_policy_arn" {
  value = aws_iam_policy.ec2_to_access_sns_role_policy.arn
}
