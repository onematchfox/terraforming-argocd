locals {
  full_name = "${var.service}-${local.cluster_name}"

  platform_config = jsondecode(data.aws_ssm_parameter.platform_config.value)

  cluster_name           = local.platform_config.eks_cluster_name
  node_security_group_id = local.platform_config.node_security_group_id

  common_labels = {
    "example.com/version"       = var.container_definition.image_tag
    "app.kubernetes.io/part-of" = var.service
  }

  helm_values = merge(
    {
      nameOverride = var.service,
      image = {
        repository = var.container_definition.image_repository
        tag        = var.container_definition.image_tag
      }
      podSecurityGroup = var.create_pod_security_group ? module.pod_security_group[0].security_group_id : null
    },
    var.helm_values,
    {
      additionalLabels = merge(
        local.common_labels,
        try(var.helm_values.additionalLabels, {}),
      )
    },
    {
      container = merge(
        {
          args    = var.container_definition.args
          command = var.container_definition.command
          env = [
            for key, value in var.container_definition.environment_variables : {
              name  = key
              value = value
            }
          ],
          ports = [
            for key, value in var.container_definition.ports : {
              containerPort = value.port
              name          = key
              protocol      = value.protocol
            }
          ],
          resources = {
            limits = {
              memory = var.container_definition.memory
            }
            requests = {
              cpu    = var.container_definition.cpu
              memory = var.container_definition.memory
            }
          }
        },
        var.container_definition.liveness_probe != null ? {
          livenessProbe = {
            httpGet = var.container_definition.liveness_probe
          }
        } : {},
        var.container_definition.readiness_probe != null ? {
          readinessProbe = {
            httpGet = var.container_definition.readiness_probe
          }
        } : {},
        try(var.helm_values.container, {}),
      )
    },
    {
      ingress = merge(
        local.ingress_helm_values,
        try(var.helm_values.ingress, {}),
        {
          annotations = merge(
            local.ingress_helm_values.annotations,
            try(var.helm_values.ingress.annotations, {}),
          )
        }
      )
    },
    {
      serviceAccount = merge(
        local.service_account_helm_values,
        try(var.helm_values.serviceAccount, {}),
      )
    },
  )
}
