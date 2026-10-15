# ==============================================================================
# Alam El Marateb Backend — one-command Docker workflow
#
#   make build      full local stack (cert + build + up)      [default path]
#   make deploy     production path on the server (cert + pull/build + up -d)
#   make help       list every target
#
# Env overrides: IMAGE_NAME=... TAG=... REGISTRY=... DOMAIN=... make <target>
# Local dev uses a self-signed cert (browsers warn, curl needs -k).
# Production: place Let's Encrypt files at docker/nginx/ssl/fullchain.pem +
# privkey.pem (or terminate at Cloudflare) and re-run `make deploy`.
# ==============================================================================
SHELL := /bin/bash
COMPOSE := docker compose
CERT_DIR := docker/nginx/ssl
DOMAIN ?= localhost

-include .env
export

.DEFAULT_GOAL := help
.PHONY: help build up down restart ps logs image release deploy cert nginx-test clean

##@ General
help: ## Show this help (make help)
	@awk 'BEGIN {FS = ":.*##"; printf "\nTargets:\n"} /^[a-zA-Z0-9_%-]+:.*##/ {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Examples:"
	@echo "  make build                       # local: cert + build + start (foreground logs)"
	@echo "  make deploy                      # server: cert + build + start detached"
	@echo "  IMAGE_NAME=myorg/app TAG=v1 make release   # tag + push to registry"

##@ Local
build: cert ## Full local stack: cert + build images + start with logs (Ctrl-C stops)
	$(COMPOSE) build app
	$(COMPOSE) up

up: cert ## Start stack detached (nginx :80/:443 + app :8080 + postgres + redis)
	$(COMPOSE) up -d
	@$(MAKE) --no-print-directory ps

down: ## Stop stack (keep volumes/data)
	$(COMPOSE) down

restart: ## Restart app + nginx only
	$(COMPOSE) restart app nginx

ps: ## Show container status
	$(COMPOSE) ps

logs: ## Tail logs (all services; Ctrl-C to exit)
	$(COMPOSE) logs -f --tail=200

##@ Release
image: ## Build versioned backend image (IMAGE_NAME / TAG)
	docker build -t $(IMAGE_NAME):$(TAG) .
	@docker images $(IMAGE_NAME):$(TAG) --format "Built {{.Repository}}:{{.Tag}} ({{.Size}})"

release: image ## Tag + push backend image to registry (REGISTRY required)
	@test -n "$(REGISTRY)" || (echo "ERROR: set REGISTRY=... (e.g. REGISTRY=ghcr.io/myorg make release)"; exit 1)
	docker tag $(IMAGE_NAME):$(TAG) $(REGISTRY)/$(IMAGE_NAME):$(TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG)
	@echo "Released $(REGISTRY)/$(IMAGE_NAME):$(TAG)"

deploy: cert ## Production deploy on the server: cert + build + start detached
	$(COMPOSE) build app
	$(COMPOSE) up -d
	@$(MAKE) --no-print-directory ps
	@echo ""
	@echo "Verify:  curl -k -I https://$(DOMAIN)/healthz            # expect HTTP/2 or HTTP/1.1"
	@echo "         curl -k --http3 -I https://$(DOMAIN)/healthz      # expect HTTP/3 (UDP/443 open)"
	@echo "         curl -I http://$(DOMAIN)/healthz                 # expect 301 -> https"

##@ Maintenance
cert: ## Generate self-signed cert for Nginx if missing (dev only; DOMAIN=...)
	@if [ -f "$(CERT_DIR)/fullchain.pem" ] && [ -f "$(CERT_DIR)/privkey.pem" ]; then \
		echo "Cert exists: $(CERT_DIR)/ (skip)"; \
	else \
		echo "Generating self-signed cert for CN=$(DOMAIN) ..."; \
		mkdir -p "$(CERT_DIR)"; \
		openssl req -x509 -newkey rsa:2048 -nodes -days 825 \
			-keyout "$(CERT_DIR)/privkey.pem" \
			-out "$(CERT_DIR)/fullchain.pem" \
			-subj "/CN=$(DOMAIN)"; \
		chmod 600 "$(CERT_DIR)/privkey.pem"; \
		echo "Wrote $(CERT_DIR)/fullchain.pem + privkey.pem"; \
	fi

nginx-test: ## Validate nginx.conf syntax inside the nginx image (no stack needed)
	# --add-host stubs the `app` upstream: `nginx -t` only needs the name to
	# resolve, real DNS happens on the compose network at runtime.
	docker run --rm --add-host app:127.0.0.1 \
		-v "$$(pwd)/docker/nginx/nginx.conf:/etc/nginx/nginx.conf:ro" \
		-v "$$(pwd)/docker/nginx/ssl:/etc/nginx/ssl:ro" \
		nginx:1.29-alpine nginx -t

clean: ## Stop stack AND delete volumes (DATA LOSS: postgres/redis/minio/...)
	@echo "This deletes ALL compose volumes (databases). Ctrl-C now to abort; continuing in 5s..."
	@sleep 5
	$(COMPOSE) down -v
