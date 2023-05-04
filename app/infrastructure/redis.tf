resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = local.name
  description          = local.name

  engine               = "redis"
  node_type            = "cache.t3.micro"
  engine_version       = "7.0"
  port                 = local.redis_port
  parameter_group_name = "default.redis7"

  automatic_failover_enabled = false
  multi_az_enabled           = false
  num_node_groups            = 1

  subnet_group_name  = local.platform.elasticache_subnet_group_name
  security_group_ids = [aws_security_group.redis.id]
}

resource "aws_security_group" "redis" {
  name_prefix = "${local.name}-redis-"
  vpc_id      = local.platform.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}
