#!/bin/bash
set -e

CONNECT_URL="http://localhost:8083"
CONFIG_FILE="/etc/kafka-connect/config/postgres-connector.json"
CONNECTOR_NAME="postgres-connector"

until curl -s -f "$CONNECT_URL/connectors" > /dev/null; do
  echo "Waiting for Kafka Connect"
  sleep 2
done

echo "Kafka Connect is ready"

if curl -s -f "$CONNECT_URL/connectors/$CONNECTOR_NAME" > /dev/null; then
  echo "Connector '$CONNECTOR_NAME' already exists"
else
  curl -s -X POST \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    "$CONNECT_URL/connectors" \
    --data "@$CONFIG_FILE"
  echo
  echo "Connector '$CONNECTOR_NAME' created"
fi