ethereum_node_url := $(or $(ethereum_node_url), '')
smart_contract_address := $(or $(smart_contract_address), '')

SHELL := /bin/bash
.ONESHELL:

.PHONY: help
.DEFAULT_GOAL := help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build script
	@go get github.com/ethereum/go-ethereum/common
	@go get github.com/ethereum/go-ethereum/ethclient
	@go build -o get_smart_contract_creation_block main.go 
