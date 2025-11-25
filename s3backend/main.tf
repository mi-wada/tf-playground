# How to use:
# 1. Add random id to local.projects
# 2. Add this to project's backend.tf
#
# terraform {
#   backend "s3" {
#     bucket         = "tf-state-03d7dc79-74e1-4100-b66e-55d830971e7b"
#     key            = "terraform.<id>.tfstate"
#     region         = "ap-northeast-1"
#     dynamodb_table = "tf-state-lock-<id>"
#   }
# }

terraform {
  required_version = "1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.1"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "local" {
  }
}

locals {
  s3_suffix = "03d7dc79-74e1-4100-b66e-55d830971e7b"
  projects = {
    staticweb = {
      id = "2e9b888b-0d06-4adb-bf6e-22ab86e57968"
    }
    ec2 = {
      id = "f1f7f560-601b-4643-a295-34b5143309bc"
    }
    ecs = {
      id = "ecf6c096-e2e0-40ce-802e-75364a255260"
    }
    ecsp = {
      id = "d734e537-0bb3-45cb-aa37-28f2852dc08d"
    }
  }
}

resource "aws_s3_bucket" "tf_backend" {
  bucket = "tf-state-${local.s3_suffix}"
}

resource "aws_s3_bucket_versioning" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_backend" {
  for_each     = local.projects
  name         = "tf-state-lock-${each.value.id}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
