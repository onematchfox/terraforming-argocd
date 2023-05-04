resource "github_repository_deploy_key" "this" {
  title      = "ArgoCD"
  repository = local.repo_name
  key        = tls_private_key.this.public_key_openssh
  read_only  = true
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
