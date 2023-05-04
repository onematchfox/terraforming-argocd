resource "aws_ssm_parameter" "this" {
  name = "platform-config"
  type = "SecureString"
  value = jsonencode({
    # ArgoCD
    argocd_host = local.argocd_host

    # EKS
    eks_cluster_name       = module.eks.cluster_name
    node_security_group_id = module.eks.node_security_group_id

    # VPC
    elasticache_subnet_group_name = module.vpc.elasticache_subnet_group_name
    public_subnets                = module.vpc.public_subnets
    private_subnets               = module.vpc.private_subnets
    vpc_id                        = module.vpc.vpc_id

    # DNS
    route53_zone_id = data.aws_route53_zone.selected.zone_id
  })
}
