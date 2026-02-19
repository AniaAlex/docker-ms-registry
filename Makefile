# MS Registry Containerized Deployment Makefile

.PHONY: help build clean

# Default target
help: ## Show this help message
	@echo "MS Registry - Docker Image Build"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	@echo "Building docker-ms-registry containerized image..."
	docker build -f Dockerfile --build-arg MS_REGISTRY_VERSION=main -t docker-ms-registry:latest .

clean: ## Remove the built image
	@echo "Removing docker-ms-registry image..."
	docker rmi docker-ms-registry:latest || true
