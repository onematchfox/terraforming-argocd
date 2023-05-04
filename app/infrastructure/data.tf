locals {
  platform = jsondecode(data.aws_ssm_parameter.platform_config.value)
}

data "aws_ssm_parameter" "platform_config" {
  name = "platform-config"
}

data "aws_secretsmanager_secret_version" "argocd" {
  secret_id = "argocd"
}
