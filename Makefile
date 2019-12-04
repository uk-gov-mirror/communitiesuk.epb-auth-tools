.DEFAULT_GOAL := help
SHELL := /bin/bash

.PHONY: help
help: ## Print help documentation
	@echo -e "Makefile Help for epb-auth-tools"
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: test
test: ## Run all tests
	@rake spec

.PHONY: format
format: ## Format ruby files using .editorconfig
	@bundle exec rbprettier --write '**/*.rb'
