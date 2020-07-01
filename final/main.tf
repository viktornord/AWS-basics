provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source = "./ec2"
}
//
//module "s3" {
//  source = "./s3"
//}

resource "aws_sns_topic" "vikto_topic" {
  name = "edu-lohika-training-aws-sns-topic"
}

resource "aws_sqs_queue" "viktor_queue" {
  name = "edu-lohika-training-aws-sqs-queue"
}
