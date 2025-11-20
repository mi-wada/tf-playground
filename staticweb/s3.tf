resource "aws_s3_bucket" "staticweb" {
  bucket_prefix = "staticweb"
}

resource "aws_s3_bucket_website_configuration" "staticweb" {
  bucket = aws_s3_bucket.staticweb.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "staticweb" {
  bucket = aws_s3_bucket.staticweb.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "staticweb" {
  bucket                  = aws_s3_bucket.staticweb.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "staticweb" {
  bucket = aws_s3_bucket.staticweb.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.staticweb.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.staticweb]
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.staticweb.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/index.html")
}
