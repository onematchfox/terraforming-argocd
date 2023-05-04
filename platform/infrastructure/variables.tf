variable "github_user" {
  description = "Github Username - used to correctly set the URL of the repository containing the application manifests."
  type        = string
  default     = "onematchfox"
}

# VPC
variable "vpc_cidr" {
  description = "CIDR block for VPC to create"
  type        = string
  default     = "10.0.0.0/20"
}

variable "num_azs" {
  description = "Number of AZs to deploy VPC and cluster to."
  type        = number
  default     = 2
}

# EKS Cluster
variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster"
  type        = string
  default     = "1.26"
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 90 days"
  type        = number
  default     = 1
}

# EKS Add-ons
variable "argocd_helm_version" {
  description = "Version of the ArgoCD Helm chart to deploy"
  type        = string
  default     = "5.29.1"
}

variable "route53_domain_name" {
  description = "Name of Route53 domain to use when exposing resources in the cluster"
  type        = string
}
