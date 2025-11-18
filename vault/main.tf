terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.4.0"
    }
  }
}

variable "vault_address" {
  type = string
}

variable "vault_token" {
  type      = string
  sensitive = true
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

resource "vault_generic_secret" "example" {
  path = "secret/hoge"

  data_json = jsonencode(
    {
      "foo"   = "bar",
      "pizza" = "cheesee"
    }
  )
}
