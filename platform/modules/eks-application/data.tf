data "aws_eks_cluster" "selected" {
  name = local.cluster_name
}

data "aws_iam_openid_connect_provider" "cluster" {
  url = data.aws_eks_cluster.selected.identity[0].oidc[0].issuer
}

data "aws_region" "current" {}

data "aws_route53_zone" "selected" {
  zone_id = local.platform_config.route53_zone_id
}

data "aws_ssm_parameter" "platform_config" {
  name = "platform-config"
}

data "aws_arn" "oidc_provider" {
  arn = data.aws_iam_openid_connect_provider.cluster.arn
}
