# default build target
all::

all:: build
.PHONY: all

SUBDIRS := $(wildcard */. add-ons/*/.)

init:

	for dir in $(SUBDIRS); do \
		name=$$(echo "$$dir" | rev | cut -c3- | rev); \
		( cd $$name && terraform init || false ); \
	done

lint: init

	for dir in $(SUBDIRS); do \
		name=$$(echo "$$dir" | rev | cut -c3- | rev); \
		( cd $$name && tflint --config=$(PWD)/.tflint.hcl || false ); \
	done

	# Run tfdocs and tflint - this requires that all modules have been initialised
	# so we run it after the Terraform init
	pre-commit run -a

apply:

	terraform apply -target module.vpc -auto-approve
	terraform apply -target module.eks -auto-approve
	terraform apply -auto-approve

destroy:

	terraform apply -destroy -target module.addons -auto-approve
	terraform apply -destroy -target module.eks -auto-approve
	terraform apply -destroy -target module.vpc -auto-approve

destroy-all: destroy

	terraform apply -destroy -auto-approve

clean:

	rm -rf site/
	rm -rf **/.terraform/
	rm -f **/.terraform.lock.hcl

.PHONY: init lint apply destroy destroy-all clean
