terraform {
  backend "s3" {
    bucket         = "tf-state-03d7dc79-74e1-4100-b66e-55d830971e7b"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tf-state-lock-03d7dc79-74e1-4100-b66e-55d830971e7b"
  }
}

locals {
  tf_backend_suffix = "03d7dc79-74e1-4100-b66e-55d830971e7b"
}

resource "aws_s3_bucket" "tf_backend" {
  bucket = "tf-state-${local.tf_backend_suffix}"
}

resource "aws_s3_bucket_versioning" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_backend" {
  name         = "tf-state-lock-${local.tf_backend_suffix}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
