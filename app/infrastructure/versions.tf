terraform {
  required_version = ">= 1.0"
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 5.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = local.tags
  }
}

provider "argocd" {
  server_addr = local.platform_config.argocd_host
  username    = "admin"
  password    = data.aws_secretsmanager_secret_version.argocd.secret_string
}
