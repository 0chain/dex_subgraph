ethereum_node_url := $(or $(ethereum_node_url), '')
smart_contract_address := $(or $(smart_contract_address), '')

.PHONY: help
.DEFAULT_GOAL := help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: prepare
prepare: ## Install prerequisites
	@apt install golang -y

.PHONY: build
build: prepare ## Build script
	@go get github.com/ethereum/go-ethereum/common
	@go get github.com/ethereum/go-ethereum/ethclient
	@go build -o get_smart_contract_creation_block main.go 

.PHONY: run
run: ## Run script
ifneq ($(smart_contract_address), '')
ifneq ($(ethereum_node_url), '')
	@./main --ethereum_node_url=$(ethereum_node_url) --smart_contract_address=$(smart_contract_address)
else
	@echo "Ethereum node URL is required to be specified with the help of 'ethereum_node_url' parameter"
endif
else
	@echo "Smart contract address is required to be specified with the help of 'smart_contract_address' parameter"
endif
