resource "aws_s3_bucket" "viktor_bucket" {
  bucket = "vurbanas-bucket"
  acl    = "private"
  force_destroy = true
}

resource "aws_s3_bucket_object" "calc_jar" {
  bucket = "vurbanas-bucket"
  key    = "calc-0.0.1-SNAPSHOT.jar"
  source = "calc-0.0.1-SNAPSHOT.jar"
}
resource "aws_s3_bucket_object" "persist_jar" {
  bucket = "vurbanas-bucket"
  key    = "persist3-0.0.1-SNAPSHOT.jar"
  source = "persist3-0.0.1-SNAPSHOT.jar"
}
