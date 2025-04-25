#!/bin/bash

# A script to publish the PostgreSQL image to a registry

# Load environment variables
source .env

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting the publishing process to ${REGISTRY_URL}/${REGISTRY_IMAGE}:${REGISTRY_TAG}${NC}"

# Build the image directly with the registry tag
echo -e "${YELLOW}Building image...${NC}"
docker build -t ${REGISTRY_URL}/${REGISTRY_IMAGE}:${REGISTRY_TAG} .

# Check if build was successful
if [ $? -ne 0 ]; then
  echo -e "${RED}Build failed, cannot publish.${NC}"
  exit 1
fi

# Push to registry
echo -e "${YELLOW}Pushing to registry...${NC}"
docker push ${REGISTRY_URL}/${REGISTRY_IMAGE}:${REGISTRY_TAG}

# Check if push was successful
if [ $? -ne 0 ]; then
  echo -e "${RED}Push failed.${NC}"
  exit 1
else
  echo -e "${GREEN}Image successfully published to ${REGISTRY_URL}/${REGISTRY_IMAGE}:${REGISTRY_TAG}${NC}"
fi