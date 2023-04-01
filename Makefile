graph_node := $(or $(graph_node), '')
network := $(or $(network), 'sepolia')
smart_contract_address := $(or $(smart_contract_address), '')

.PHONY: help
.DEFAULT_GOAL := help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: prepare
prepare: ## Install prerequisites
	@apt update
	@apt install nodejs npm yq -y

	@npm install -g @graphprotocol/graph-cli
	@npm install
	
.PHONY: test
test: ## Run tests
	@graph test . -v 0.5.4

.PHONY: build
build: ## Build smart contracts
ifneq ($(smart_contract_address), '')
	@yq e -i '.dataSources[0].network = "$(network)"' subgraph.yaml
	@yq e -i '.dataSources[0].source.address = "$(smart_contract_address)"' subgraph.yaml
	@graph codegen
	@graph build
else
	@echo "Smart contract address is required to be specified with the help of 'smart_contract_address' parameter"
endif

.PHONY: deploy
deploy: build test ## Deploy smart contracts to the given network(default: sepolia)
ifneq ($(graph_node), '')
	@graph create -g $(graph_node) dex_subgraph 
	@graph deploy -g $(graph_node) --product hosted_service --version-label  0.0.1 dex_subgraph
else
	@echo "Graph node URL is required to be specified with the help of 'graph_node' parameter"
endif