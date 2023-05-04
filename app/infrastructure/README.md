# App Infrastructure

Terraform code used to deploy `podinfo` to EKS cluster defined in
[../../platform/infrastructure](../../platform/infrastructure/).

Application is deployed using the
[../../platform/modules/eks-application/](../../platform/modules/eks-application/)
Terraform module which wraps the Helm chart
[../../platform/charts/eks-application/](../../platform/charts/eks-application/).

See commented lines in [eks.tf](eks.tf) for extending the default deployment to connect to the Elasticache Redis cluster by:
- configuring the deployment with the connection string for the Elasticache Redis cluster
- adding a security group to the application pods
- adding ingress/egress security group rules to allow communication between the pods and the Elasticache Redis cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | >= 5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
