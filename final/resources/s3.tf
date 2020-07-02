resource "aws_s3_bucket" "viktor_bucket" {
  bucket = "vurbanas-bucket"
  acl    = "private"
}
