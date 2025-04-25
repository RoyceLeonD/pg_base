# Include environment variables from .env file
include .env

# Phony targets
.PHONY: help build start stop clean restart logs psql test-features monitor check-extensions publish

# Default target
help:
	@echo "Available commands:"
	@echo "  make build       - Build the PostgreSQL container"
	@echo "  make start       - Start the PostgreSQL container and dependent services"
	@echo "  make stop        - Stop running containers"
	@echo "  make restart     - Restart containers"
	@echo "  make clean       - Remove containers and volumes"
	@echo "  make logs        - Show logs from the PostgreSQL container"
	@echo "  make psql        - Connect to PostgreSQL with psql"
	@echo "  make test-features - Run test script to verify features"
	@echo "  make monitor     - Monitor container status and show logs"
	@echo "  make check-extensions - Check which PostgreSQL extensions are installed"
	@echo "  make publish    - Publish container to docker.antska.com registry"

# Build image
build:
	@echo "Building PostgreSQL container with extensions..."
	docker-compose build

# Start containers
start:
	@echo "Starting PostgreSQL and related services..."
	docker-compose up -d
	@echo "Waiting for PostgreSQL to be ready..."
	sleep 10
	@echo "Services are running!"

# Stop containers
stop:
	@echo "Stopping containers..."
	docker-compose down

# Restart containers
restart: stop start

# Remove containers and volumes
clean:
	@echo "Removing containers and volumes..."
	docker-compose down -v
	@echo "Removed!"

# Show logs
logs:
	docker-compose logs -f postgres

# Connect to PostgreSQL with psql
psql:
	@echo "Connecting to PostgreSQL..."
	docker exec -it $(CONTAINER_NAME) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

# Run test features
test-features:
	@echo "Testing PostgreSQL features..."
	docker exec -i $(CONTAINER_NAME) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) -f /scripts/test-features.sql

# Monitor container status
monitor:
	@echo "Monitoring PostgreSQL container..."
	./scripts/monitor.sh

# Check installed extensions
check-extensions:
	@echo "Checking installed PostgreSQL extensions..."
	./scripts/monitor.sh extensions
	
# Publish container to registry
publish:
	@echo "Publishing container to registry..."
	./scripts/publish.sh