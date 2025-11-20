terraform {
  backend "s3" {
    bucket         = "tf-state-e3628bbc-80d4-47b4-a3d5-08324833ad8c"
    key            = "tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform_lock"
  }
}
