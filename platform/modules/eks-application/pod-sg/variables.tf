variable "node_security_group_id" {
  description = "ID of the node shared security group. It is expected that CoreDNS will be running using this node security group and any probes will originate from this security group."
  type        = string
}

variable "probe_ports" {
  description = "List of ports for which Kubernetes liveness/readiness probes are configured"
  type        = list(number)
  default     = []
}

variable "security_group_name" {
  description = "Name of the security group to create"
  type        = string
}
