.PHONY: help
.DEFAULT_GOAL := help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: prepare
prepare: ## Install prerequisites
	apt install go -y

.PHONY: build
build: prepare ## Build script
	go build main.go

.PHONY: run
run: build ## Run script
	./main --ethereum_node_url=$(ethereum_node_url) --smart_contract_address=$(smart_contract_address)