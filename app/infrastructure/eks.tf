module "podinfo" {
  source = "../../platform/modules/eks-application"

  service        = local.name
  argocd_project = "default"

  create_ingress = true
  # create_pod_security_group = true

  container_definition = {
    image_repository = "stefanprodan/podinfo"
    image_tag        = "6.2.0"
    environment_variables = {
      PODINFO_LEVEL    = "debug"
      PODINFO_UI_COLOR = "#adbbca"
      # PODINFO_CACHE_SERVER = "tcp://${aws_elasticache_replication_group.redis.primary_endpoint_address}:${local.redis_port}"
    }
    ports = {
      http = {
        port = 9898
      }
    }
    liveness_probe = {
      path = "/healthz"
    }
    readiness_probe = {
      path = "/readyz"
    }
  }

  replica_count = 2
}

# resource "aws_security_group_rule" "redis_ingress_podinfo" {
#   security_group_id        = aws_security_group.redis.id
#   type                     = "ingress"
#   description              = "Allow access from podinfo service"
#   from_port                = local.redis_port
#   to_port                  = local.redis_port
#   protocol                 = "tcp"
#   source_security_group_id = module.podinfo.pod_security_group_id
# }

# resource "aws_security_group_rule" "podinfo_egress_redis" {
#   security_group_id        = module.podinfo.pod_security_group_id
#   type                     = "egress"
#   description              = "Redis to Elasticache cluster"
#   from_port                = local.redis_port
#   to_port                  = local.redis_port
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.redis.id
# }
