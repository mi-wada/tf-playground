terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.21.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# module "s3" {
#   source = "./s3"
#   bucket = "fu-safal124l130ugajsjlfal"
# }
