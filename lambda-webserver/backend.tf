terraform {
  backend "s3" {
    bucket       = "tf-state-03d7dc79-74e1-4100-b66e-55d830971e7b"
    key          = "terraform.842e6c1a-5a05-4bcf-8d95-675a5618daaf.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}
