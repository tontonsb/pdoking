SHELL := /bin/bash

.DEFAULT_GOAL := help

MAKEFLAGS += --no-print-directory

## These are always actions, run them even if such files exist
.PHONY: install test help

install: ## Install backend dependencies.
	@docker compose run php composer --no-interaction --optimize-autoloader install

test: ## Run tests.
	@docker compose run php composer test

build: ## reBuild image.
	@docker compose build php

help: ## Show this help.
	@printf "\033[33mUsage:\033[0m\n  make [target]\n\n\033[33mTargets:\033[0m\n"
	@grep -E '^[-a-zA-Z0-9_\.\/]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-15s\033[0m %s\n", $$1, $$2}'

%:
	@echo 'Invalid command'
	@make help
