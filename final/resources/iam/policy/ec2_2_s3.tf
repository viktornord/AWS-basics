resource "aws_iam_policy" "ec2_to_access_s3_role_policy" {
  name = "ec2_to_access_s3"
  policy = data.aws_iam_policy_document.ec2_s3_read_policy.json
}


data "aws_iam_policy_document" "ec2_s3_read_policy" {
  statement {
    effect = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::vurbanas-bucket/*"]
  }
  statement {
    effect = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::vurbanas-bucket"]
  }
}

output "ec2_2_s3_policy_arn" {
  value = aws_iam_policy.ec2_to_access_s3_role_policy.arn
}
