# ==============================================================================
# Alam El Marateb Flutter apps
#
# Every app is auto-detected: any sub-folder with a pubspec.yaml is a target.
# Today that is Admin; drop a Customer app in Flutter/Customer and it shows up
# automatically (no Makefile edit needed).
#
#   make build                 build the default app (Admin) for every
#                              platform folder that this host can build
#   make build-all             build EVERY detected app
#   make build-admin           build only one app
#   make build-customer        build only one app (once it exists)
#   make build-apk             Android APK only (release)
#   make build-appbundle       Android App Bundle only (release)
#   make build-ios             iOS (macOS only)
#   make build-web             Web
#   make build-windows         Windows (Windows host only)
#   make build-linux           Linux (Linux host only)
#   make build-macos           macOS (macOS host only)
#
# Env overrides: APP=Admin BUILD_MODE=debug make build
#                FLUTTER=/path/to/flutter make build
# ==============================================================================
SHELL := /bin/bash

FLUTTER ?= flutter
BUILD_MODE ?= release
APP ?= Admin
OS := $(shell uname -s 2>/dev/null || echo unknown)
PLATFORMS := android ios web windows linux macos

# Any direct child folder containing pubspec.yaml is considered an app.
APPS := $(patsubst %/pubspec.yaml,%,$(wildcard */pubspec.yaml))
ifeq ($(strip $(APPS)),)
$(error No Flutter app found: expected at least one */pubspec.yaml)
endif

# Folder names keep their case (Admin); convenience targets are lowercase.
lower = $(shell echo $(1) | tr '[:upper:]' '[:lower:]')
APP_TARGETS := $(foreach app,$(APPS),build-$(call lower,$(app)))

.DEFAULT_GOAL := help
.PHONY: help all build build-all build-platforms build-android build-apk \
	build-appbundle build-ios build-web build-windows build-linux build-macos \
	pub-get pub-upgrade clean clean-all analyze test doctor devices run \
	$(APP_TARGETS)

##@ General
help: ## Show this help (make help)
	@awk 'BEGIN {FS = ":.*##"; printf "\nTargets:\n"} /^[a-zA-Z0-9_/%-]+:.*##/ {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Detected apps : $(APPS)"
	@echo "Default app   : $(APP)"
	@echo "Build mode    : $(BUILD_MODE)"
	@echo ""
	@echo "Examples:"
	@echo "  make build                     # default app, every platform this host supports"
	@echo "  make build-all                 # every detected app"
	@echo "  make build-customer            # one app by folder name"
	@echo "  make build-apk BUILD_MODE=debug"
	@echo "  make run DEVICE=chrome"

all: build-all ## Alias for build-all

##@ Build (all platforms)
build: build-platforms ## Build APP for every platform folder available on this host

build-all: ## Build every detected app (Admin + Customer when present)
	@set -e; for app in $(APPS); do \
		echo ""; echo "==> $$app"; \
		$(MAKE) --no-print-directory build-platforms APP=$$app; \
	done

build-platforms: ## Build APP for each platform folder present and supported by this host
	@set -e; built=0; \
	[ -f "$(APP)/pubspec.yaml" ] || { echo "ERROR: app '$(APP)' not found ($(APP)/pubspec.yaml)"; exit 1; }; \
	for p in $(PLATFORMS); do \
		if [ ! -d "$(APP)/$$p" ]; then echo "SKIP $$p: $(APP)/$$p missing"; continue; fi; \
		case $$p in \
			ios|macos) \
				[ "$(OS)" = "Darwin" ] || { echo "SKIP $$p: requires a macOS host (host is $(OS))"; continue; } ;; \
			windows) \
				case "$(OS)" in MINGW*|MSYS*|CYGWIN*) ;; *) echo "SKIP windows: requires a Windows host (host is $(OS))"; continue ;; esac ;; \
			linux) \
				[ "$(OS)" = "Linux" ] || { echo "SKIP linux: requires a Linux host (host is $(OS))"; continue; } ;; \
		esac; \
		echo ""; echo "==> $(APP) / $$p"; \
		$(MAKE) --no-print-directory build-$$p APP=$(APP) BUILD_MODE=$(BUILD_MODE) FLUTTER=$(FLUTTER); \
		built=1; \
	done; \
	if [ $$built -eq 0 ]; then echo "WARN: no buildable platform for $(APP) on $(OS)"; fi

# `make build-admin` / `make build-customer` / any folder name (case-insensitive).
$(APP_TARGETS):
	@set -e; want="$(patsubst build-%,%,$@)"; app=""; \
	for dir in $(APPS); do \
		if [ "$$(echo $$dir | tr '[:upper:]' '[:lower:]')" = "$$want" ]; then app="$$dir"; fi; \
	done; \
	[ -n "$$app" ] || { echo "ERROR: no app matching '$$want'. Detected: $(APPS)"; exit 1; }; \
	$(MAKE) --no-print-directory build-platforms APP="$$app" BUILD_MODE=$(BUILD_MODE) FLUTTER=$(FLUTTER)

##@ Build (single platform)
build-android: build-apk build-appbundle ## Android: APK + App Bundle

build-apk: ## Build Android APK (BUILD_MODE=release|debug|profile)
	cd $(APP) && $(FLUTTER) build apk --$(BUILD_MODE)

build-appbundle: ## Build Android App Bundle for Play Store
	cd $(APP) && $(FLUTTER) build appbundle --$(BUILD_MODE)

build-ios: ## Build iOS bundle (macOS host only)
	@[ "$(OS)" = "Darwin" ] || { echo "SKIP ios: requires a macOS host (host is $(OS))"; exit 0; }
	@[ -d "$(APP)/ios" ] || { echo "SKIP ios: $(APP)/ios missing"; exit 0; }
	cd $(APP) && $(FLUTTER) build ios --$(BUILD_MODE) --no-codesign

build-web: ## Build web release bundle (build/web)
	@[ -d "$(APP)/web" ] || { echo "SKIP web: $(APP)/web missing"; exit 0; }
	cd $(APP) && $(FLUTTER) build web --$(BUILD_MODE)

build-windows: ## Build Windows desktop app (Windows host only)
	@case "$(OS)" in MINGW*|MSYS*|CYGWIN*) ;; *) echo "SKIP windows: requires a Windows host (host is $(OS))"; exit 0 ;; esac
	@[ -d "$(APP)/windows" ] || { echo "SKIP windows: $(APP)/windows missing"; exit 0; }
	cd $(APP) && $(FLUTTER) build windows --$(BUILD_MODE)

build-linux: ## Build Linux desktop app (Linux host only)
	@[ "$(OS)" = "Linux" ] || { echo "SKIP linux: requires a Linux host (host is $(OS))"; exit 0; }
	@[ -d "$(APP)/linux" ] || { echo "SKIP linux: $(APP)/linux missing"; exit 0; }
	cd $(APP) && $(FLUTTER) build linux --$(BUILD_MODE)

build-macos: ## Build macOS desktop app (macOS host only)
	@[ "$(OS)" = "Darwin" ] || { echo "SKIP macos: requires a macOS host (host is $(OS))"; exit 0; }
	@[ -d "$(APP)/macos" ] || { echo "SKIP macos: $(APP)/macos missing"; exit 0; }
	cd $(APP) && $(FLUTTER) build macos --$(BUILD_MODE)

##@ App lifecycle
pub-get: ## Resolve dependencies for APP
	cd $(APP) && $(FLUTTER) pub get

pub-upgrade: ## Upgrade dependencies for APP
	cd $(APP) && $(FLUTTER) pub upgrade

analyze: ## Static analysis for APP
	cd $(APP) && $(FLUTTER) analyze

test: ## Run tests for APP
	cd $(APP) && $(FLUTTER) test

run: ## Run APP on DEVICE (e.g. DEVICE=chrome; default: Flutter's picker)
	cd $(APP) && $(FLUTTER) run $(if $(DEVICE),-d $(DEVICE),)

doctor: ## Show Flutter / toolchain health
	$(FLUTTER) doctor -v

devices: ## List devices Flutter can target
	$(FLUTTER) devices

##@ Cleanup
clean: ## Clean build artifacts for APP
	cd $(APP) && $(FLUTTER) clean

clean-all: ## Clean every detected app
	@set -e; for app in $(APPS); do \
		echo "==> cleaning $$app"; \
		cd "$$app" && $(FLUTTER) clean && cd ..; \
	done
