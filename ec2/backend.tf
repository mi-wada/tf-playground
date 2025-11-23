terraform {
  backend "s3" {
    bucket         = "tf-state-03d7dc79-74e1-4100-b66e-55d830971e7b"
    key            = "terraform.f1f7f560-601b-4643-a295-34b5143309bc.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tf-state-lock-f1f7f560-601b-4643-a295-34b5143309bc"
  }
}
