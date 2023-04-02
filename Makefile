graph_node := $(or $(graph_node), '')
graph_index := $(or $(graph_index), '')
ethereum_node_url := $(or $(ethereum_node_url), '')
network := $(or $(network), 'sepolia')
smart_contract_address := $(or $(smart_contract_address), '')

.PHONY: help
.DEFAULT_GOAL := help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: prepare
prepare: ## Install prerequisites
	@apt update
	@apt install nodejs npm yq jq -y

	@npm install -g @graphprotocol/graph-cli
	@npm install
	
.PHONY: test
test: ## Run tests
	@graph test . -v 0.5.4

.PHONY: build
build: ## Build smart contracts
ifneq ($(smart_contract_address), '')
ifneq ($(ethereum_node_url), '')
	# BLOCK_NUMBER := $(shell curl --request POST \
	# 	--url $(ethereum_node_url) \
	# 	--header 'accept: application/json' \
	# 	--header 'content-type: application/json' \
	# 	--data '{"id":1,"jsonrpc":"2.0","params":["$(smart_contract_address)"],"method":"eth_getTransactionReceipt"}' | jq .blockNumber)
	BLOCK_NUMBER := $(shell make -c vendor/get_smart_contract_creation_block run)
ifneq ($(BLOCK_NUMBER), 'null')
	@yq e -i '.dataSources[0].source.startBlock = "$(BLOCK_NUMBER)"' subgraph.yaml
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
deploy: prepare build test ## Deploy smart contracts to the given network(default: sepolia)
ifneq ($(graph_node), '')
	@graph create -g $(graph_node) dex_subgraph 
	@graph deploy -g $(graph_node) --product hosted_service --version-label  0.0.1 dex_subgraph
else
	@echo "Graph node URL is required to be specified with the help of 'graph_node' parameter"
endif