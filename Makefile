# ==============================================================================
# Alam El Marateb monorepo entry point
#
# Wraps the two sub-projects so everything can be driven from the repo root:
#
#   Kotlin/    Spring Boot backend + Docker Compose stack
#   Flutter/   Admin app (and any future app dropped next to it)
#
# Every sub-project target is reachable with a prefix, and the sub-Makefiles
# stay the single source of truth (no duplicated recipes here):
#
#   make kotlin-<target>     e.g. make kotlin-image / kotlin-build-run
#   make flutter-<target>    e.g. make flutter-build-admin / flutter-build-apk
#   make kotlin-help         full backend target list
#   make flutter-help        full Flutter target list
# ==============================================================================
SHELL := /bin/bash

KOTLIN_DIR := Kotlin
FLUTTER_DIR := Flutter

.DEFAULT_GOAL := help
.PHONY: help all build build-all kotlin flutter kotlin-help flutter-help \
	check up down logs ps clean

##@ Everything
help: ## Show this help (make help)
	@awk 'BEGIN {FS = ":.*##"; printf "\nTargets:\n"} /^[a-zA-Z0-9_/%-]+:.*##/ {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Delegate to a sub-project (any target it defines):"
	@echo "  make kotlin-<target>          e.g. make kotlin-image, make kotlin-build-run"
	@echo "  make flutter-<target>         e.g. make flutter-build-admin, make flutter-build-apk"
	@echo "  make kotlin-help              all backend targets"
	@echo "  make flutter-help             all Flutter targets + detected apps"
	@echo ""
	@echo "Examples:"
	@echo "  make build                    # backend image + Flutter default app"
	@echo "  make build-all                # backend image + every Flutter app"
	@echo "  make up                       # start the backend stack detached"
	@echo "  make flutter-build-customer   # once Flutter/Customer exists"

all: build-all ## Build everything (alias for build-all)

build: kotlin-build-image flutter-build ## Backend image + default Flutter app

build-all: kotlin-build-image flutter-build-all ## Backend image + every Flutter app

check: ## Validate compose config and run Flutter static analysis
	$(MAKE) -C $(KOTLIN_DIR) compose-check
	$(MAKE) -C $(FLUTTER_DIR) analyze

##@ Backend shortcuts (full list: make kotlin-help)
up: ## Start backend stack detached (docker compose up -d)
	$(MAKE) -C $(KOTLIN_DIR) up

down: ## Stop backend stack (keeps volumes)
	$(MAKE) -C $(KOTLIN_DIR) down

logs: ## Tail backend logs
	$(MAKE) -C $(KOTLIN_DIR) logs

ps: ## Show backend container status
	$(MAKE) -C $(KOTLIN_DIR) ps

clean: ## Clean Flutter artifacts and stop the backend stack (keeps volumes)
	$(MAKE) -C $(FLUTTER_DIR) clean-all
	$(MAKE) -C $(KOTLIN_DIR) down

##@ Delegation
kotlin: ## Run `make -C Kotlin` with TARGET=... (e.g. make kotlin TARGET=help)
	@test -n "$(TARGET)" || (echo "ERROR: set TARGET=... (e.g. make kotlin TARGET=help)"; exit 1)
	$(MAKE) -C $(KOTLIN_DIR) $(TARGET)

flutter: ## Run `make -C Flutter` with TARGET=... (e.g. make flutter TARGET=help)
	@test -n "$(TARGET)" || (echo "ERROR: set TARGET=... (e.g. make flutter TARGET=help)"; exit 1)
	$(MAKE) -C $(FLUTTER_DIR) $(TARGET)

kotlin-help: ## Show the backend Makefile help
	$(MAKE) -C $(KOTLIN_DIR) help

flutter-help: ## Show the Flutter Makefile help
	$(MAKE) -C $(FLUTTER_DIR) help

kotlin-%: ## Delegate kotlin-<target> to Kotlin/Makefile
	$(MAKE) -C $(KOTLIN_DIR) $*

flutter-%: ## Delegate flutter-<target> to Flutter/Makefile
	$(MAKE) -C $(FLUTTER_DIR) $*
