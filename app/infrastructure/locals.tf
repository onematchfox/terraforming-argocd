locals {
  name       = "podinfo"
  redis_port = 6379
  region     = "eu-north-1"

  platform_config = jsondecode(data.aws_ssm_parameter.platform_config.value)

  tags = {
    "repository" = "onematchfox/terraforming-argocd"
  }
}
