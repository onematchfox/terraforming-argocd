locals {
  region = "eu-north-1"

  name = random_pet.this.id

  tags = {
    "repository" = local.repo
  }

  argocd_host = "argocd.${var.route53_domain_name}"

  repo_name = "terraforming-argocd"
  repo      = "${var.github_user}/${local.repo_name}"
  repo_url  = "git@github.com:${local.repo}.git"
}

resource "random_pet" "this" {}
