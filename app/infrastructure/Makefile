all::

all:: apply
.PHONY: all

apply:
	terraform apply -auto-approve

reset:
	terraform apply -auto-approve -destroy -target aws_elasticache_replication_group.redis
	terraform apply -auto-approve -target aws_security_group_rule.redis_ingress_podinfo -target module.podinfo
	terraform apply -auto-approve

