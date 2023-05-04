locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.num_azs)
  az_subnets = {
    for name in local.azs : name => cidrsubnet(var.vpc_cidr, 2, index(data.aws_availability_zones.available.names, name))
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = var.vpc_cidr

  azs = local.azs

  public_subnets = [for az, cidr in local.az_subnets : cidrsubnet(cidr, 2, 1)] # `/24` - 256 hosts
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    "subnet-type"            = "public"
  }

  private_subnets = [for az, cidr in local.az_subnets : cidrsubnet(cidr, 2, 2)] # `/24` - 256 hosts
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "subnet-type"                     = "private"
  }

  elasticache_subnets = [for az, cidr in local.az_subnets : cidrsubnet(cidr, 2, 3)] # `/24` - 256 hosts

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }
}
