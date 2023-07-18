graph_deploy := $(or $(graph_deploy), '')
graph_index := $(or $(graph_index), '')
graph_ipfs := $(or $(graph_ipfs), 'https://ipfs.network.thegraph.com')
ethereum_node_url := $(or $(ethereum_node_url), '')
network := $(or $(network), 'goerli')
smart_contract_address := $(or $(smart_contract_address), '')
skip_sync := $(or $(skip_sync), false)

SHELL := /bin/bash
.ONESHELL:

.PHONY: help
.DEFAULT_GOAL := help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: prepare
prepare: ## Install prerequisites
	$(MAKE) -C vendor/tools/get_smart_contract_creation_block build

	@npm install -g @graphprotocol/graph-cli
	@npm install
	
.PHONY: test
test: ## Run tests
	@graph test . -v 0.5.4

.PHONY: build
build: ## Build subgraph
ifneq ($(smart_contract_address), '')
ifneq ($(ethereum_node_url), '')
	$(eval BLOCK_NUMBER = $(shell ./vendor/tools/get_smart_contract_creation_block/get_smart_contract_creation_block --ethereum_node_url=$(ethereum_node_url) \
		--smart_contract_address=$(smart_contract_address)))
	
	$(eval BLOCK_NUMBER_VALIDATION = $(shell echo $(BLOCK_NUMBER) | grep -Eq '^[0-9]+$\' && echo 1 || echo 0))
	
	@if [ "$(BLOCK_NUMBER_VALIDATION)" = "0" ]; then \
        printf 'Block number of smart contract is not valid\n' >&2; \
        exit 1; \
    fi

	@yq e -i '.dataSources[0].source.startBlock = $(BLOCK_NUMBER)' subgraph.yaml
	@yq e -i '.dataSources[0].network = "$(network)"' subgraph.yaml
	@yq e -i '.dataSources[0].source.address = "$(smart_contract_address)"' subgraph.yaml
	@graph codegen
	@graph build
else
	$(error "Ethereum node URL is required to be specified with the help of 'ethereum_node_url' parameter")
endif
else
	$(error "Smart contract address is required to be specified with the help of 'smart_contract_address' parameter")
endif

.PHONY: deploy
deploy: build test ## Deploy subgraph
ifneq ($(graph_deploy), '')
ifneq ($(graph_index), '')
	@graph create -g $(graph_deploy) dex_subgraph 
	@graph deploy -g $(graph_deploy) -i $(graph_ipfs) --product hosted-service --version-label 0.0.1 dex_subgraph
ifneq ($(skip_sync), true)
	@./vendor/bin/wait_until_synced.sh $(graph_index) "dex_subgraph"
	@echo "Subgraph synchronization has been started, please wait..."
endif
else
	$(error "Graph node index URL is required to be specified with the help of 'graph_index' parameter")
endif
else
	$(error "Graph node deploy URL is required to be specified with the help of 'graph_deploy' parameter")
endif
