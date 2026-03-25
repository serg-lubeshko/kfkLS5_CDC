#!/usr/bin/env bash
set -e

echo "Ensuring Docker network exists..."
docker network create proxynet || true

echo "Starting Kafka in demon..."
#docker compose -f docker-compose.yml up --build
docker compose up --build

echo "!All services are up!"
