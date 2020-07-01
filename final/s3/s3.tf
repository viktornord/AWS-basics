resource "aws_s3_bucket" "viktor_bucket" {
  bucket = "viktor-bucket"
  acl    = "private"
  region = "us-east-1"

  versioning {
    enabled = true
  }
}
