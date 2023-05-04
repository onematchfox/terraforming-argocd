# EKS Application module

Terraform module wrapping the [`eks-application` Helm
chart](../../charts/eks-application) within this repository. The module aims to
simplify deploying an application to an EKS cluster. It caters to common
requirements such as:
- creating an `Ingress` resource using the AWS Load Balancer controller and
  External DNS (note: expects a wildcard cert to exist already)
- the creation of `ServiceAccount` and, where needed, an IAM Role for the service
  account
- provision of `SecurityGroupPolicy` for pods (aka security groups for pods)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | >= 5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_project"></a> [argocd\_project](#input\_argocd\_project) | ArgoCD project in which to create the application. | `string` | n/a | yes |
| <a name="input_container_definition"></a> [container\_definition](#input\_container\_definition) | Map containing the configuration for the container being deployed. | <pre>object({<br>    image_repository = string<br>    image_tag        = string<br>    command          = optional(list(string), null)<br>    args             = optional(list(string), null)<br>    cpu              = optional(string, "100m")<br>    memory           = optional(string, "128Mi")<br>    essential        = optional(bool, true)<br>    ports = optional(<br>      map(<br>        object({<br>          port     = number<br>          protocol = optional(string, "TCP")<br>        })<br>      ),<br>      {<br>        http = {<br>          port = 80<br>        }<br>      }<br>    )<br>    liveness_probe = optional(object({<br>      path = optional(string, "/")<br>      port = optional(string, "http")<br>    }), null)<br>    readiness_probe = optional(object({<br>      path = optional(string, "/")<br>      port = optional(string, "http")<br>    }), null)<br>    health_check_protocol = optional(string, "HTTP")<br>    protocol              = optional(string, "HTTP")<br>    environment_variables = optional(map(string), null)<br>  })</pre> | n/a | yes |
| <a name="input_create_ingress"></a> [create\_ingress](#input\_create\_ingress) | (Optional) Boolean indicating whether Ingress should be created for the application. | `bool` | `true` | no |
| <a name="input_create_pod_security_group"></a> [create\_pod\_security\_group](#input\_create\_pod\_security\_group) | (Optional) Boolean indicating whether the pods in this application should have a security group attached to them. | `bool` | `false` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | (Optional) Boolean indicating whether or not a service account should be created for the application. If `true` both a Kubernetes `ServiceAccount` and an IAM role for the service account will be created. This is useful is your application needs to make use of other AWS managed services. | `bool` | `false` | no |
| <a name="input_destination_namespace"></a> [destination\_namespace](#input\_destination\_namespace) | (Optional) Namespace in which the application should be deployed. Defaults to `var.service`. | `string` | `null` | no |
| <a name="input_destination_server"></a> [destination\_server](#input\_destination\_server) | (Optional) URL of the cluster to which the application should be deployed. | `string` | `null` | no |
| <a name="input_helm_values"></a> [helm\_values](#input\_helm\_values) | (Optional) Map containing any additional values that should be supplied when templating the Helm chart. Map will simply be yaml encoded and appended to the root of the Helm chart values. | `any` | `{}` | no |
| <a name="input_ingress_domain"></a> [ingress\_domain](#input\_ingress\_domain) | Root domain for exposed services. | `string` | `"aws.midnite.se"` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | (Optional) Number of replicas to run. | `number` | `1` | no |
| <a name="input_service"></a> [service](#input\_service) | Resource service tag. | `string` | n/a | yes |
| <a name="input_source_path"></a> [source\_path](#input\_source\_path) | (Optional) Path within repository where application manifests reside. | `string` | `"platform/charts/eks-application"` | no |
| <a name="input_source_repo_url"></a> [source\_repo\_url](#input\_source\_repo\_url) | (Optional) URL of the repository containing the application manifests. | `string` | `"git@github.com:onematchfox/terraforming-argocd.git"` | no |
| <a name="input_source_target_revision"></a> [source\_target\_revision](#input\_source\_target\_revision) | (Optional) Revision (commit, tag, or branch) of the chart/repository to sync the application to. | `string` | `"HEAD"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | Hostname on which the application is exposed if `var.create_ingress` is `true`. |
| <a name="output_pod_security_group_id"></a> [pod\_security\_group\_id](#output\_pod\_security\_group\_id) | ID of the security group created for and attached to all pods. |
| <a name="output_service_account_iam_role_arn"></a> [service\_account\_iam\_role\_arn](#output\_service\_account\_iam\_role\_arn) | ARN of the IAM role created for, and attached to, the Kubernetes `ServiceAccount`. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
