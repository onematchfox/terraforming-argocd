locals {
  pod_security_group_id = var.create_pod_security_group ? module.pod_security_group[0].security_group_id : null
}

module "pod_security_group" {
  count  = var.create_pod_security_group ? 1 : 0
  source = "./pod-sg"

  node_security_group_id = local.node_security_group_id
  probe_ports = distinct([
    var.container_definition.ports[try(var.container_definition.liveness_probe.port, "http")].port,
    var.container_definition.ports[try(var.container_definition.readiness_probe.port, "http")].port,
  ])
  security_group_name = var.service
}
