terraform {
  backend "s3" {
    bucket         = "tf-state-03d7dc79-74e1-4100-b66e-55d830971e7b"
    key            = "terraform.ecf6c096-e2e0-40ce-802e-75364a255260.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tf-state-lock-ecf6c096-e2e0-40ce-802e-75364a255260"
  }
}
