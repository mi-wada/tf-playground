terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.21.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }

  cloud {
    organization = "miwada"

    workspaces {
      name = "aws-infra"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "random_string" "s3_bucket_suffix" {
  length  = 12
  special = false
  upper   = false
}

resource "aws_s3_bucket" "main" {
  bucket = "test-${random_string.s3_bucket_suffix.result}"
}
