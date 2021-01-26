# ------------ Infra and RKE State Filepaths ----------------#

infra_state=state
cluster_state=cluster
sockshop_init=manifests
stackrox_init=stackrox

# ------------ Cluster Lifecycle Commands ----------------#

.PHONY: init
init: log-init
	@terraform init 

.PHONY: validate
validate: init validate 
	@terraform validate && echo "OK"

.PHONY: plan
plan: log-plan 
	@terraform plan -state $(infra_state)/terraform.tfstate -out $(infra_state)/terraform.tfplan 

.PHONY: apply
apply: log-apply plan
	@terraform apply -state-out $(infra_state)/terraform.tfstate $(infra_state)/terraform.tfplan

.PHONY: rke-up
rke-up: log-rke-up
	@rke up --config $(cluster_state)/cluster.yml

.PHONY: kube-config
kube-config: log-kube-config
	-cp $(cluster_state)/kube_config_cluster.yml ~/.kube/config

.PHONY: sockshop
sockshop: log-sockshop
	- kubectl create -f $(sockshop_init)/sock-shop-ns.yaml
	- kubectl create -f $(sockshop_init)/

.PHONY: rke-remove
rke-remove: log-rke-remove
	@rke remove --config $(cluster_state)/cluster.yml

.PHONY: destroy
destroy: log-destroy 
	@terraform destroy -state $(infra_state)/terraform.tfstate
	-rm $(cluster_state)/*
	-rm $(infra_state)/*

#=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
.PHONY: help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE_COLOR)%-20s$(NO_COLOR) %s\n", $$1, $$2}'

.PHONY: checkfmt
checkfmt: log-checkfmt ## Check configs format
	@terraform fmt -recursive -check=true && echo "OK"

log-%:
	@grep -h -E '^$*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BLUE_COLOR)==> %s$(NO_COLOR)\n", $$2}'
