terraform {
  backend "s3" {
    bucket       = "tf-state-03d7dc79-74e1-4100-b66e-55d830971e7b"
    key          = "terraform.035676e5-3e4b-47cb-ba25-6e6c6cb1f7d5.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}
