module "addons" {
  source = "git@github.com:/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.30.0"

  eks_cluster_id       = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_provider    = module.eks.oidc_provider
  eks_cluster_version  = module.eks.cluster_version
  eks_cluster_domain   = var.route53_domain_name

  # Wait on the `kube-system` profile before provisioning addons
  data_plane_wait_arn = join(",", [for prof in module.eks.fargate_profiles : prof.fargate_profile_arn])

  # Add-ons
  enable_argocd                       = true
  enable_aws_load_balancer_controller = true
  enable_cert_manager                 = true
  enable_external_dns                 = true
  # enable_external_secrets = true

  # ArgoCD
  argocd_manage_add_ons = true
  argocd_applications = {
    addons = {
      path                = "platform/charts/add-ons"
      repo_url            = local.repo_url
      add_on_application  = true # Indicates the root add-on application.
      ssh_key_secret_name = aws_secretsmanager_secret.github_ssh_key.name
      values = {
        repoUrl = local.repo_url
        ingress = {
          domain         = var.route53_domain_name
          certificateArn = data.aws_acm_certificate.ingress.arn
        }
      }
    }
  }
  argocd_helm_config = {
    set_sensitive = [
      {
        name  = "configs.secret.argocdServerAdminPassword"
        value = bcrypt_hash.argo.id
      }
    ]
    timeout = 300
    values = [templatefile("${path.module}/argocd/values.yaml", {
      argocd_host     = local.argocd_host
      certificate_arn = data.aws_acm_certificate.ingress.arn
    })]
    version = var.argocd_helm_version
  }

  # External DNS
  external_dns_helm_config = {
    txtOwnerId = local.name
    # domainFilters = [var.route53_domain_name]
    policy   = "sync"
    logLevel = "debug"
  }

  depends_on = [
    module.eks,
    aws_secretsmanager_secret.github_ssh_key,
  ]
}
