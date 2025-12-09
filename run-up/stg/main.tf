terraform {
  required_version = "1.14.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.24.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket       = "tf-state-03d7dc79-74e1-4100-b66e-55d830971e7b"
    key          = "terraform.9f56f81d-9f4b-4819-babc-552db086926b.stg.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "webserver_cluster" {
  source       = "github.com/mi-wada/tf-playground//run-up/modules/webserver-cluster?ref=b252c817b1863f3dc243a01016ce4fffd4e9a288"
  cluster_name = "stg"
}

output "alb_dns" {
  value = module.webserver_cluster.alb_dns
}
