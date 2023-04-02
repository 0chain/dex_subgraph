graph_deploy := $(or $(graph_deploy), '')
graph_index := $(or $(graph_index), '')
ethereum_node_url := $(or $(ethereum_node_url), '')
network := $(or $(network), 'goerli')
smart_contract_address := $(or $(smart_contract_address), '')

.ONESHELL:

.PHONY: help
.DEFAULT_GOAL := help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: prepare
prepare: ## Install prerequisites
	@apt update
	@apt install nodejs npm jq -y
	@wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
	@chmod a+x /usr/local/bin/yq

	@npm install -g @graphprotocol/graph-cli
	@npm install
	
.PHONY: test
test: ## Run tests
	@graph test . -v 0.5.4

.PHONY: build
build: prepare ## Build subgraph
ifneq ($(smart_contract_address), '')
ifneq ($(ethereum_node_url), '')
	@make -C vendor/get_smart_contract_creation_block build
	$(eval BLOCK_NUMBER = $(shell ./vendor/tools/get_smart_contract_creation_block/get_smart_contract_creation_block --ethereum_node_url=$(ethereum_node_url) \
		--smart_contract_address=$(smart_contract_address)))
ifeq ($(shell echo $(BLOCK_NUMBER) | grep -E "^[0-9]+$$"),$(BLOCK_NUMBER))	
	@yq e -i '.dataSources[0].source.startBlock = $(BLOCK_NUMBER)' subgraph.yaml
	@yq e -i '.dataSources[0].network = "$(network)"' subgraph.yaml
	@yq e -i '.dataSources[0].source.address = "$(smart_contract_address)"' subgraph.yaml
	@graph codegen
	@graph build
else
	@echo "Block number of smart contract is not valid"
endif
else
	@echo "Ethereum node URL is required to be specified with the help of 'ethereum_node_url' parameter"
endif
else
	@echo "Smart contract address is required to be specified with the help of 'smart_contract_address' parameter"
endif

.PHONY: deploy
deploy: build test ## Deploy subgraph
ifneq ($(graph_deploy), '')
ifneq ($(graph_index), '')
	@graph create -g $(graph_deploy) dex_subgraph 
	@graph deploy -g $(graph_deploy) --product hosted-service --version-label 0.0.1 dex_subgraph
	@./vendor/bin/wait_until_synced.sh $(graph_index) "dex_subgraph"
else
	@echo "Graph node index URL is required to be specified with the help of 'graph_index' parameter"
endif
else
	@echo "Graph node deploy URL is required to be specified with the help of 'graph_deploy' parameter"
endif