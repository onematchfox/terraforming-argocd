output "hostname" {
  description = "Hostname on which the application is exposed if `var.create_ingress` is `true`."
  value       = local.ingress_host
}

output "service_account_iam_role_arn" {
  description = "ARN of the IAM role created for, and attached to, the Kubernetes `ServiceAccount`."
  value       = local.service_account_iam_role_arn
}

output "pod_security_group_id" {
  description = "ID of the security group created for and attached to all pods."
  value       = local.pod_security_group_id
}
