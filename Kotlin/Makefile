# ==============================================================================
# Alam El Marateb Backend granular Docker workflow
#
# Pick exactly what you need; every step also runs standalone:
#
#   make image          build backend image only (no containers)
#   make release        image -> tag -> push to registry
#   make deploy         deploy only: pull released image + restart (no build)
#   make deploy-build   build on the server + restart (no registry)
#   make up-search      start only core + Meilisearch profile
#   make smoke          verify H1/H2/H3 + health through Nginx
#
# Short aliases: build-image (image), build-run / build-and-run, pull-image (pull)
#
# Env overrides: IMAGE_NAME=... TAG=... REGISTRY=... DOMAIN=... make <target>
# Local dev uses a self-signed cert (browsers warn, curl needs -k).
# Production: place Let's Encrypt files at docker/nginx/ssl/fullchain.pem +
# privkey.pem (or terminate at Cloudflare) and re-run deploy.
# ==============================================================================
SHELL := /bin/bash
COMPOSE := docker compose
CERT_DIR := docker/nginx/ssl
DOMAIN ?= localhost
HOST ?= localhost
HTTP_PORT ?= 80
HTTPS_PORT ?= 443
IMAGE_NAME ?= alamelmarateb/backend
TAG ?= latest
REGISTRY ?=
FULL_IMAGE := $(if $(REGISTRY),$(REGISTRY)/$(IMAGE_NAME):$(TAG),$(IMAGE_NAME):$(TAG))

-include .env
export

.DEFAULT_GOAL := help
.PHONY: help build up up-all up-replica up-kafka up-minio up-clickhouse up-search \
	down restart restart-% ps logs logs-app logs-nginx logs-db pull \
	image image-nc build-image tag push release deploy deploy-build update \
	build-run build-and-run \
	cert cert-check nginx-test compose-check audit smoke env-check \
	jar test dev db-shell db-backup db-restore redis-shell \
	shell-app shell-nginx clean clean-images prune

##@ General
help: ## Show this help (make help)
	@awk 'BEGIN {FS = ":.*##"; printf "\nTargets:\n"} /^[a-zA-Z0-9_/%-]+:.*##/ {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Examples:"
	@echo "  make build                       # local: cert + build + start (foreground logs)"
	@echo "  make image TAG=v1.2.0            # build backend image only, no containers"
	@echo "  make release REGISTRY=ghcr.io/myorg TAG=v1.2.0   # image -> tag -> push"
	@echo "  make deploy                      # server: pull released image + restart (no build)"
	@echo "  make up-search && make smoke    # search profile + verify H1/H2/H3"

##@ Local lifecycle
build: cert ## Full local stack: cert + build images + start with logs (Ctrl-C stops)
	@echo "🔨 [backend] Building app image ..."
	$(COMPOSE) build app
	@echo "🚀 [backend] Starting stack (Ctrl-C to stop) ..."
	$(COMPOSE) up

build-run: cert ## Build images then run the whole stack detached
	@echo "🔨 [backend] Building app image ..."
	$(COMPOSE) build app
	@echo "🚀 [backend] Starting stack detached ..."
	$(COMPOSE) up -d
	@$(MAKE) --no-print-directory ps
	@echo "✅ Stack is up."

build-and-run: build-run ## Alias for build-run

up: cert ## Start core stack detached (nginx + app + postgres + redis)
	@echo "🚀 [backend] Starting core stack ..."
	$(COMPOSE) up -d
	@$(MAKE) --no-print-directory ps

up-all: cert ## Start core + ALL opt-in profiles (replica, kafka, minio, clickhouse, search)
	@echo "🚀 [backend] Starting core stack + all profiles ..."
	$(COMPOSE) --profile replica --profile kafka --profile minio --profile clickhouse --profile search up -d
	@$(MAKE) --no-print-directory ps

up-replica: ## Start core + postgres read-replica (:5433)
	@echo "🚀 [backend] Starting stack with postgres replica ..."
	$(COMPOSE) --profile replica up -d

up-kafka: ## Start core + Kafka event transport (:9092)
	@echo "🚀 [backend] Starting stack with Kafka ..."
	$(COMPOSE) --profile kafka up -d

up-minio: ## Start core + MinIO S3 storage (:9000, console :9001)
	@echo "🚀 [backend] Starting stack with MinIO ..."
	$(COMPOSE) --profile minio up -d

up-clickhouse: ## Start core + ClickHouse analytics (:8123)
	@echo "🚀 [backend] Starting stack with ClickHouse ..."
	$(COMPOSE) --profile clickhouse up -d

up-search: ## Start core + Meilisearch catalog search (:7700)
	@echo "🚀 [backend] Starting stack with Meilisearch ..."
	$(COMPOSE) --profile search up -d

down: ## Stop stack (keep volumes/data)
	@echo "🛑 [backend] Stopping stack (volumes kept) ..."
	$(COMPOSE) down

restart: ## Restart app + nginx only
	@echo "🔄 [backend] Restarting app + nginx ..."
	$(COMPOSE) restart app nginx

restart-%: ## Restart one service, e.g. make restart-app / restart-nginx / restart-postgres
	@echo "🔄 [backend] Restarting $* ..."
	$(COMPOSE) restart $*

pull: ## Pull images from registries (no build; pairs with deploy)
	@echo "📥 [backend] Pulling images ..."
	$(COMPOSE) pull

pull-image: ## Alias for pull (fetch images)
	@echo "📥 [backend] Pulling images ..."
	$(MAKE) pull

update: pull ## Pull latest images then recreate containers (no build)
	@echo "🚀 [backend] Recreating containers with pulled images ..."
	$(COMPOSE) up -d
	@$(MAKE) --no-print-directory ps
	@echo "✅ Update done."

rebuild: ## Rebuild changed images then restart (uses cache)
	@echo "🔨 [backend] Rebuilding changed images ..."
	$(COMPOSE) up -d --build
	@$(MAKE) --no-print-directory ps
	@echo "✅ Rebuild done."

ps: ## Show container status
	@echo "📋 [backend] Container status:"
	$(COMPOSE) ps

logs: ## Tail logs, all services (Ctrl-C to exit)
	@echo "📜 [backend] Tailing all service logs (Ctrl-C to exit) ..."
	$(COMPOSE) logs -f --tail=200

logs-app: ## Tail backend logs only
	@echo "📜 [backend] Tailing app logs (Ctrl-C to exit) ..."
	$(COMPOSE) logs -f --tail=200 app

logs-nginx: ## Tail edge proxy logs only
	@echo "📜 [backend] Tailing nginx logs (Ctrl-C to exit) ..."
	$(COMPOSE) logs -f --tail=200 nginx

logs-db: ## Tail postgres logs only
	@echo "📜 [backend] Tailing postgres logs (Ctrl-C to exit) ..."
	$(COMPOSE) logs -f --tail=200 postgres

##@ Image & release (build / tag / push separately or together)
image: ## Build backend image only (no containers): IMAGE_NAME / TAG
	@echo "🔨 [backend] Building image $(IMAGE_NAME):$(TAG) ..."
	docker build -t $(IMAGE_NAME):$(TAG) .
	@docker images $(IMAGE_NAME):$(TAG) --format "✅ Image ready: {{.Repository}}:{{.Tag}} ({{.Size}})"

image-nc: ## Rebuild backend image from scratch (no cache)
	@echo "🔨 [backend] Building image $(IMAGE_NAME):$(TAG) from scratch (--no-cache --pull) ..."
	docker build --no-cache --pull -t $(IMAGE_NAME):$(TAG) .
	@docker images $(IMAGE_NAME):$(TAG) --format "✅ Image ready: {{.Repository}}:{{.Tag}} ({{.Size}})"

build-image: image ## Alias for image (build the backend image)

tag: ## Tag local image for registry (needs REGISTRY=...): REGISTRY / TAG
	@test -n "$(REGISTRY)" || (echo "❌ ERROR: set REGISTRY=... (e.g. REGISTRY=ghcr.io/myorg make tag)"; exit 1)
	@echo "🏷️  [backend] Tagging $(IMAGE_NAME):$(TAG) → $(FULL_IMAGE) ..."
	docker tag $(IMAGE_NAME):$(TAG) $(FULL_IMAGE)
	@echo "✅ Tagged $(FULL_IMAGE)"

push: ## Push image to registry (needs REGISTRY=...): REGISTRY / TAG
	@test -n "$(REGISTRY)" || (echo "❌ ERROR: set REGISTRY=... (e.g. REGISTRY=ghcr.io/myorg make push)"; exit 1)
	@echo "⬆️  [backend] Pushing $(FULL_IMAGE) ..."
	docker push $(FULL_IMAGE)
	@echo "✅ Pushed $(FULL_IMAGE)"

release: image tag push ## Full release: build image -> tag -> push (needs REGISTRY=...)
	@echo "✅ Released $(FULL_IMAGE)"

deploy: cert ## Deploy only: pull released image + restart, NO build (server path)
	@echo "📥 [backend] Pulling released images ..."
	$(COMPOSE) pull app nginx 2>/dev/null || $(COMPOSE) pull
	@echo "🚀 [backend] Recreating containers ..."
	$(COMPOSE) up -d
	@$(MAKE) --no-print-directory ps
	@echo ""
	@echo "Verify:  curl -k -I https://$(HOST):$(HTTPS_PORT)/healthz"
	@echo "         curl -k --http3 -I https://$(HOST):$(HTTPS_PORT)/healthz"

deploy-build: cert ## Deploy by building on the server (no registry needed)
	@echo "🔨 [backend] Building image on the server ..."
	$(COMPOSE) build app
	@echo "🚀 [backend] Recreating containers ..."
	$(COMPOSE) up -d
	@$(MAKE) --no-print-directory ps
	@echo ""
	@echo "Verify:  curl -k -I https://$(DOMAIN)/healthz            # expect HTTP/2 or HTTP/1.1"
	@echo "         curl -k --http3 -I https://$(DOMAIN)/healthz      # expect HTTP/3 (UDP/443 open)"
	@echo "         curl -I http://$(DOMAIN)/healthz                 # expect 301 -> https"

##@ TLS & checks
cert: ## Generate self-signed cert for Nginx if missing (dev only; DOMAIN=...)
	@if [ -f "$(CERT_DIR)/fullchain.pem" ] && [ -f "$(CERT_DIR)/privkey.pem" ]; then \
		echo "🔐 Cert exists: $(CERT_DIR)/ (skip)"; \
	else \
		echo "🔐 Generating self-signed cert for CN=$(DOMAIN) ..."; \
		mkdir -p "$(CERT_DIR)"; \
		openssl req -x509 -newkey rsa:2048 -nodes -days 825 \
			-keyout "$(CERT_DIR)/privkey.pem" \
			-out "$(CERT_DIR)/fullchain.pem" \
			-subj "/CN=$(DOMAIN)"; \
		chmod 600 "$(CERT_DIR)/privkey.pem"; \
		echo "✅ Wrote $(CERT_DIR)/fullchain.pem + privkey.pem"; \
	fi

cert-check: ## Show cert expiry + SAN (catch expired self-signed/LE certs)
	@test -f "$(CERT_DIR)/fullchain.pem" || (echo "❌ ERROR: no cert at $(CERT_DIR)/ (run make cert)"; exit 1)
	@echo "🔐 Certificate details:"
	@openssl x509 -in $(CERT_DIR)/fullchain.pem -noout -subject -enddate

compose-check: ## Validate docker-compose.yaml interpolation + schema
	@echo "🔎 Validating docker-compose.yaml ..."
	@$(COMPOSE) config --quiet && echo "✅ compose: OK"

nginx-test: ## Validate nginx.conf syntax inside the nginx image (no stack needed)
	# --add-host stubs the `app` upstream: `nginx -t` only needs the name to
	# resolve, real DNS happens on the compose network at runtime.
	@echo "🔎 Validating nginx.conf syntax ..."
	@docker run --rm --add-host app:127.0.0.1 \
		-v "$$(pwd)/docker/nginx/nginx.conf:/etc/nginx/nginx.conf:ro" \
		-v "$$(pwd)/docker/nginx/ssl:/etc/nginx/ssl:ro" \
		nginx:1.29-alpine nginx -t
	@echo "✅ nginx: OK"

audit: compose-check nginx-test ## Config audit: compose schema + nginx syntax
	@echo "✅ audit: OK"

smoke: ## Verify edge live: 80->301, H2 ALPN, Alt-Svc H3, H1+H2+H3 bodies (HOST/ports overridable)
	@echo "🧪 [backend] Edge smoke test against $(HOST) ..."
	@echo "== 80 -> 301 redirect"; curl -s -o /dev/null -w "%{http_code} -> %{redirect_url}\n" http://$(HOST):$(HTTP_PORT)/healthz
	@echo "== ALPN version (want 2)"; curl -sk -o /dev/null -w "%{http_version}\n" https://$(HOST):$(HTTPS_PORT)/healthz
	@echo "== Alt-Svc (want h3)"; curl -skI https://$(HOST):$(HTTPS_PORT)/healthz | grep -i "alt-svc" || (echo "❌ MISSING Alt-Svc!"; exit 1)
	@echo "== HTTP/1.1 fallback"; curl -sk --http1.1 -o /dev/null -w "%{http_code} v%{http_version}\n" https://$(HOST):$(HTTPS_PORT)/healthz
	@echo "== HTTP/2 body"; curl -sk --http2 https://$(HOST):$(HTTPS_PORT)/healthz; echo ""
	@echo "== HTTP/3 (best effort)"; curl -sk --http3 -o /dev/null -w "%{http_code} v%{http_version}\n" https://$(HOST):$(HTTPS_PORT)/healthz || echo "⚠️  (no H3 client support or UDP blocked — H1/H2 fallback unaffected)"
	@echo "✅ Smoke test finished."

scan: ## Scan backend image with Trivy (if installed): IMAGE_NAME / TAG
	@command -v trivy >/dev/null || (echo "❌ ERROR: trivy not installed (https://trivy.dev)"; exit 1)
	@echo "🔎 [backend] Scanning $(IMAGE_NAME):$(TAG) with Trivy ..."
	trivy image --severity HIGH,CRITICAL $(IMAGE_NAME):$(TAG)

env-check: ## Warn about dev-default secrets before production deploy
	@echo "🔎 Checking .env for production-unsafe defaults ..."
	@test -f .env || echo "⚠️  WARN: no .env file — compose falls back to LOCAL-ONLY dev defaults"
	@grep -q "CHANGE-ME" .env 2>/dev/null && echo "⚠️  WARN: .env still contains CHANGE-ME placeholders" || true
	@grep -q "^DOCS_ENABLED=true" .env 2>/dev/null && echo "⚠️  WARN: DOCS_ENABLED=true exposes Swagger UI (set false in prod)" || true
	@grep -q "^DB_PASSWORD=root" .env 2>/dev/null && echo "⚠️  WARN: DB_PASSWORD is still the dev default" || true
	@echo "✅ env-check done (warnings only — fix before exposing to the internet)"

##@ Backend without Docker (Gradle)
jar: ## Build Spring Boot jar locally (no Docker): ./gradlew bootJar
	@echo "🔨 [backend] Building Spring Boot jar (Gradle) ..."
	./gradlew bootJar --no-daemon -x test
	@echo "✅ Jar ready → build/libs/"

test: ## Run backend unit tests: ./gradlew test
	@echo "🧪 [backend] Running unit tests ..."
	./gradlew test --no-daemon
	@echo "✅ Tests done."

dev: ## Run backend locally without Docker (needs local postgres/redis)
	@echo "🚀 [backend] Starting Spring Boot locally (bootRun) ..."
	./gradlew bootRun --no-daemon

##@ Data & shells
db-shell: ## Open psql shell in postgres container
	@echo "🐘 Opening psql shell in postgres ..."
	$(COMPOSE) exec postgres psql -U $${DB_USER:-root} -d $${DB_NAME:-mydatabase}

db-backup: ## pg_dump -> backups/backup-TAG-timestamp.sql.gz (needs stack running)
	@echo "💾 [backend] Dumping database ..."
	@mkdir -p backups
	$(COMPOSE) exec -T postgres pg_dump -U $${DB_USER:-root} $${DB_NAME:-mydatabase} | gzip > backups/backup-$(TAG)-$$(date +%Y%m%d-%H%M%S).sql.gz
	@echo "✅ Backup written to backups/"

db-restore: ## Restore: make db-restore FILE=backups/<file>.sql.gz (STOPS app first)
	@test -n "$(FILE)" || (echo "❌ ERROR: FILE=... required (e.g. make db-restore FILE=backups/backup-latest-20240101.sql.gz)"; exit 1)
	@echo "⏸️  [backend] Stopping app before restore ..."
	$(COMPOSE) stop app
	@echo "💾 Restoring $(FILE) into postgres ..."
	gunzip -c $(FILE) | $(COMPOSE) exec -T postgres psql -U $${DB_USER:-root} -d $${DB_NAME:-mydatabase}
	@echo "🚀 Starting app again ..."
	$(COMPOSE) start app
	@echo "✅ Restored $(FILE)"

redis-shell: ## Open redis-cli in redis container
	@echo "🧠 Opening redis-cli in redis ..."
	$(COMPOSE) exec redis redis-cli

shell-app: ## Shell into backend container (debug)
	@echo "🐚 Opening shell in app ..."
	$(COMPOSE) exec app sh

shell-nginx: ## Shell into edge proxy container (debug)
	@echo "🐚 Opening shell in nginx ..."
	$(COMPOSE) exec nginx sh

##@ Cleanup
clean: ## Stop stack AND delete volumes (DATA LOSS: postgres/redis/minio/...)
	@echo "🧹 This deletes ALL compose volumes (databases). Ctrl-C now to abort; continuing in 5s..."
	@sleep 5
	$(COMPOSE) down -v
	@echo "✅ Stack and volumes removed."

clean-images: ## Remove locally built backend images (keeps volumes/data)
	@echo "🧹 Removing local image $(IMAGE_NAME):$(TAG) ..."
	@docker rmi $(IMAGE_NAME):$(TAG) 2>/dev/null || echo "⚠️  no local image $(IMAGE_NAME):$(TAG)"
	@echo "✅ Done."

prune: ## Prune unused Docker data (dangling images/networks/build cache)
	@echo "🧹 This prunes ALL unused Docker data system-wide. Ctrl-C now to abort; continuing in 5s..."
	@sleep 5
	docker system prune -f
	@echo "✅ Docker pruned."
