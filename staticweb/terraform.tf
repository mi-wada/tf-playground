terraform {
  required_version = "1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
