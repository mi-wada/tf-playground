output "backend_tf" {
  value = {
    for key, value in local.projects :
    key => <<-EOF
terraform {
  backend "s3" {
    bucket         = "${aws_s3_bucket.tf_backend.bucket}"
    key            = "terraform.${value.id}.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tf-state-lock-${value.id}"
  }
}
    EOF
  }
}
