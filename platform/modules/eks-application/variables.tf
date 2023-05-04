variable "service" {
  description = "Resource service tag."
  type        = string
}

# ArgoCD
variable "argocd_project" {
  description = "ArgoCD project in which to create the application."
  type        = string
}

variable "destination_server" {
  description = "(Optional) URL of the cluster to which the application should be deployed."
  type        = string
  default     = null
}

variable "destination_namespace" {
  description = "(Optional) Namespace in which the application should be deployed. Defaults to `var.service`."
  type        = string
  default     = null
}

variable "helm_values" {
  description = "(Optional) Map containing any additional values that should be supplied when templating the Helm chart. Map will simply be yaml encoded and appended to the root of the Helm chart values."
  type        = any
  default     = {}
}

variable "source_repo_url" {
  description = "(Optional) URL of the repository containing the application manifests."
  type        = string
  default     = "git@github.com:onematchfox/terraforming-argocd.git"
}

variable "source_path" {
  description = "(Optional) Path within repository where application manifests reside."
  type        = string
  default     = "platform/charts/eks-application"
}

variable "source_target_revision" {
  description = "(Optional) Revision (commit, tag, or branch) of the chart/repository to sync the application to."
  type        = string
  default     = "HEAD"
}

# Deployment
variable "container_definition" {
  description = "Map containing the configuration for the container being deployed."
  type = object({
    image_repository = string
    image_tag        = string
    command          = optional(list(string), null)
    args             = optional(list(string), null)
    cpu              = optional(string, "100m")
    memory           = optional(string, "128Mi")
    essential        = optional(bool, true)
    ports = optional(
      map(
        object({
          port     = number
          protocol = optional(string, "TCP")
        })
      ),
      {
        http = {
          port = 80
        }
      }
    )
    liveness_probe = optional(object({
      path = optional(string, "/")
      port = optional(string, "http")
    }), null)
    readiness_probe = optional(object({
      path = optional(string, "/")
      port = optional(string, "http")
    }), null)
    health_check_protocol = optional(string, "HTTP")
    protocol              = optional(string, "HTTP")
    environment_variables = optional(map(string), null)
  })
}

variable "replica_count" {
  description = "(Optional) Number of replicas to run."
  type        = number
  default     = 1
}

# Ingress
variable "create_ingress" {
  description = "(Optional) Boolean indicating whether Ingress should be created for the application."
  type        = bool
  default     = true
}

variable "ingress_domain" {
  description = "Root domain for exposed services."
  type        = string
  default     = "aws.midnite.se"
}

# Security Group
variable "create_pod_security_group" {
  description = "(Optional) Boolean indicating whether the pods in this application should have a security group attached to them."
  type        = bool
  default     = false
}

# Service Account
variable "create_service_account" {
  description = "(Optional) Boolean indicating whether or not a service account should be created for the application. If `true` both a Kubernetes `ServiceAccount` and an IAM role for the service account will be created. This is useful is your application needs to make use of other AWS managed services."
  type        = bool
  default     = false
}
