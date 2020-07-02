resource "aws_iam_policy" "ec2_to_access_sqs_role_policy" {
  name = "ec2_to_access_sqs"
  policy = data.aws_iam_policy_document.ec2_to_access_sqs_policy.json
}

data "aws_iam_policy_document" "ec2_to_access_sqs_policy" {
  statement {
    effect = "Allow"
    actions   = [
      "sqs:DeleteMessage",
      "sqs:GetQueueUrl",
      "sqs:DeleteMessageBatch",
      "sqs:SendMessageBatch",
      "sqs:PurgeQueue",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:SetQueueAttributes",
    ]
    resources = ["arn:aws:sqs:us-east-1:*:edu-lohika-training-aws-sqs-queue"]
  }
  statement {
    effect = "Allow"
    actions   = [
      "sqs:ListQueues",
    ]
    resources = ["*"]
  }
}

output "ec2_2_sqs_policy_arn" {
  value = aws_iam_policy.ec2_to_access_sqs_role_policy.arn
}
