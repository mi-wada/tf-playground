resource "aws_s3_bucket" "staticweb" {
  bucket_prefix = "staticweb"
}

resource "aws_s3_bucket_versioning" "staticweb" {
  bucket = aws_s3_bucket.staticweb.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "staticweb_bucket" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.staticweb.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.staticweb.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "staticweb" {
  bucket = aws_s3_bucket.staticweb.id
  policy = data.aws_iam_policy_document.staticweb_bucket.json
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.staticweb.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/index.html")
}
