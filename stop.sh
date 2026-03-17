#!/usr/bin/env bash
set -e

#echo "Stopping application..."
#docker compose down --remove-orphans

echo "Stopping Kafka..."
docker compose -f docker-compose.yml down

echo "All services are stopped"
