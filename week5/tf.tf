provider "aws" {
  region = "us-east-1"
}

resource "aws_sqs_queue" "test_sqs" {
  name = "viktor_sqs"
  fifo_queue = false
  tags = {
    Environment = "vikor_sqs"
  }
}
resource "aws_sns_topic" "test_sns" {
  name = "email_notification_topic"
}
