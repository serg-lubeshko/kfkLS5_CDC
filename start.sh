#!/usr/bin/env bash
set -e

echo "Ensuring Docker network exists..."
docker network create proxynet || true

echo "Starting Kafka in demon..."
docker compose -f docker-compose.yml up
#docker compose -f docker-compose.yml up -d

echo "!All services are up!"
