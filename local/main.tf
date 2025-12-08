terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.6.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
  required_version = "1.14.0"
}

resource "random_integer" "name" {
  max = 1
  min = 0
}

resource "local_file" "txt" {
  count           = random_integer.name.result
  filename        = "hoge.txt"
  content         = "hello\n"
  file_permission = "0600"
}
