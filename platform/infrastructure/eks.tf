module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.5"

  cluster_name                   = local.name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    # aws-ebs-csi-driver = {}
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      most_recent = true
      configuration_values = jsonencode({
        env = {
          ENABLE_POD_ENI = "true"
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    initial = {
      instance_types = ["c6i.large", "c5.large"]
      capacity_type  = "SPOT"

      # Not required nor used - avoid tagging two security groups with same tag as well
      create_security_group = false

      min_size     = 2
      max_size     = 2
      desired_size = 2
    }
  }

  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
}
