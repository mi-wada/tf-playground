terraform {
  backend "s3" {
    bucket         = "tf-state-03d7dc79-74e1-4100-b66e-55d830971e7b"
    key            = "terraform.2e9b888b-0d06-4adb-bf6e-22ab86e57968.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tf-state-lock-2e9b888b-0d06-4adb-bf6e-22ab86e57968"
  }
}
