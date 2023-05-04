resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = "${var.security_group_name} Pod SG"
  vpc_id      = data.aws_security_group.node.vpc_id
  tags = {
    "Name" = var.security_group_name
  }
}

resource "aws_security_group_rule" "this_ingress_self" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  description       = "All from self"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  self              = true
}

resource "aws_security_group_rule" "this_ingress_probes" {
  count = length(var.probe_ports)

  security_group_id        = aws_security_group.this.id
  type                     = "ingress"
  description              = "Kubernetes probes from nodes"
  from_port                = var.probe_ports[count.index]
  to_port                  = var.probe_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "this_egress_dns_udp" {
  security_group_id        = aws_security_group.this.id
  type                     = "egress"
  description              = "CoreDNS (UDP) to nodes"
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "this_egress_dns_tcp" {
  security_group_id        = aws_security_group.this.id
  type                     = "egress"
  description              = "CoreDNS (TCP) to nodes"
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "node_ingress_this_dns_udp" {
  security_group_id        = var.node_security_group_id
  type                     = "ingress"
  description              = "CoreDNS from ${var.security_group_name}"
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
  source_security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "node_ingress_this_dns_tcp" {
  security_group_id        = var.node_security_group_id
  type                     = "ingress"
  description              = "CoreDNS from ${var.security_group_name}"
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this.id
}
