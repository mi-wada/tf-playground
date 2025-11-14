terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# resource "aws_instance" "test_server" {
#   ami           = "ami-0e68e34976bb4db93" # Amazon Linux 2023 kernel-6.1 AMI
#   instance_type = "t3.micro"

#   tags = {
#     Name = "TestServer"
#   }
# }
