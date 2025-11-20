resource "terraform_data" "example" {
  provisioner "local-exec" {
    command = "echo \"Hello, Terraform ${terraform_data.var1.input}\""
  }
  lifecycle {
    replace_triggered_by = [terraform_data.var1.input]
  }
}

locals {
  revision = {
    default = 6
    stg     = 6
    prod    = 11
  }
}

resource "terraform_data" "var1" {
  input = local.revision[terraform.workspace]
}

resource "terraform_data" "only_prod" {
  count = terraform.workspace == "prod" ? 1 : 0
  provisioner "local-exec" {
    command = "echo \"Hello, Prod\""
  }
}
