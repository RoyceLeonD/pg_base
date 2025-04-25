#!/bin/bash

# A monitoring script to check the status of various components

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

check_docker() {
  echo -e "${YELLOW}Checking Docker status...${NC}"
  if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Docker is not running or not installed.${NC}"
    return 1
  else
    echo -e "${GREEN}Docker is running.${NC}"
    return 0
  fi
}

check_container_status() {
  local container_name=$1
  echo -e "${YELLOW}Checking container $container_name status...${NC}"
  
  if docker ps -q -f name="$container_name" | grep -q .; then
    echo -e "${GREEN}Container $container_name is running.${NC}"
    return 0
  elif docker ps -a -q -f name="$container_name" | grep -q .; then
    echo -e "${RED}Container $container_name exists but is not running.${NC}"
    return 1
  else
    echo -e "${YELLOW}Container $container_name does not exist.${NC}"
    return 2
  fi
}

check_extensions() {
  local container_name=$1
  local db_name=$2
  local user_name=$3
  
  echo -e "${YELLOW}Checking installed PostgreSQL extensions...${NC}"
  
  if ! check_container_status "$container_name"; then
    echo -e "${RED}Cannot check extensions because container is not running.${NC}"
    return 1
  fi
  
  echo -e "${YELLOW}Installed extensions:${NC}"
  docker exec -it "$container_name" psql -U "$user_name" -d "$db_name" -c "SELECT name, default_version, installed_version FROM pg_available_extensions WHERE installed_version IS NOT NULL ORDER BY name;"
}

main() {
  # Source .env file to get variables
  if [ -f .env ]; then
    source .env
  else
    echo -e "${RED}.env file not found.${NC}"
    exit 1
  fi
  
  check_docker || exit 1
  
  echo -e "${YELLOW}Monitoring PostgreSQL build:${NC}"
  
  if [ "$1" = "extensions" ]; then
    check_extensions "$CONTAINER_NAME" "$POSTGRES_DB" "$POSTGRES_USER"
  else
    check_container_status "$CONTAINER_NAME"
    
    if [ $? -eq 0 ]; then
      echo -e "${YELLOW}Container logs:${NC}"
      docker logs --tail 20 "$CONTAINER_NAME"
    fi
  fi
}

main "$@"