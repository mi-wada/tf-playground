resource "aws_s3_bucket" "binary" {
  bucket_prefix = "binary"
}

resource "aws_s3_object" "binary" {
  bucket = aws_s3_bucket.binary.bucket
  key    = "helloserver"
  source = "./helloserver/helloserver"
}
