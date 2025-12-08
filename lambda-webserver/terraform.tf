terraform {
  required_version = "1.14.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.1"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Project = "image-process"
    }
  }
}
