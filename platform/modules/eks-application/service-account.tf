locals {
  service_account_helm_values = {
    create = var.create_service_account
    name   = var.service
    annotations = {
      "eks.amazonaws.com/role-arn" = local.service_account_iam_role_arn
    }
  }

  service_account_iam_role_arn = var.create_service_account ? aws_iam_role.service_account[0].arn : null
}

resource "aws_iam_role" "service_account" {
  count = var.create_service_account ? 1 : 0

  name = local.full_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${data.aws_iam_openid_connect_provider.cluster.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(data.aws_arn.oidc_provider.resource, "oidc-provider/", "")}:sub": "system:serviceaccount:${var.service}:${var.service}"
        }
      }
    }
  ]
}
POLICY
}
