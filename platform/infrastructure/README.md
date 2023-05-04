# Platform Infrastructure

Contains setup for base infrastructure including VPC, EKS cluster + add-ons. 

To deploy cluster run:

``` sh
make apply
```

Note: You will need to supply the domain name of an existing Route53 hosted zone to use when exposing services deployed to the cluster. 

and to teardown run:
``` sh
make destroy
```

## Required environment variables

| Name | Purpose |
|---|---|
| `GITHUB_TOKEN` | Needed to be able to create a deploy key within the repository to allow ArgoCD access to it. |
| `AWS_` | AWS Credentials must be available. Either in the form of environment variables or via a credentials file. |

## Log in to ArgoCD UI

Once applied, ArgoCD should be available at https://argocd.${route53_domain_name}. 

The admin password can be retrieved via the following command:

``` sh
aws secretsmanager --region eu-north-1 get-secret-value --secret-id argocd | jq -r .SecretString
``` 

### Troubleshooting

If there you have issues connecting to the ArgoCD UI then port-forward the
service via the command below, log in via https://loclhost:8080 and check that
all applications have synced successfully.

``` sh
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_bcrypt"></a> [bcrypt](#requirement\_bcrypt) | >= 0.1.2 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_helm_version"></a> [argocd\_helm\_version](#input\_argocd\_helm\_version) | Version of the ArgoCD Helm chart to deploy | `string` | `"5.29.1"` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Number of days to retain log events. Default retention - 90 days | `number` | `1` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes `<major>.<minor>` version to use for the EKS cluster | `string` | `"1.26"` | no |
| <a name="input_github_user"></a> [github\_user](#input\_github\_user) | Github Username - used to correctly set the URL of the repository containing the application manifests. | `string` | `"onematchfox"` | no |
| <a name="input_num_azs"></a> [num\_azs](#input\_num\_azs) | Number of AZs to deploy VPC and cluster to. | `number` | `2` | no |
| <a name="input_route53_domain_name"></a> [route53\_domain\_name](#input\_route53\_domain\_name) | Name of Route53 domain to use when exposing resources in the cluster | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for VPC to create | `string` | `"10.0.0.0/20"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_argocd_admin_password"></a> [argocd\_admin\_password](#output\_argocd\_admin\_password) | n/a |
| <a name="output_configure_kubectl"></a> [configure\_kubectl](#output\_configure\_kubectl) | Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
