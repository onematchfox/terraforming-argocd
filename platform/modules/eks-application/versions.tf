terraform {
  required_version = ">= 1.3"
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 5.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}
