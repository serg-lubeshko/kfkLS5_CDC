#!/bin/bash
set -e

BOOTSTRAP="kafka-0:9092"
KAFKA="/opt/bitnami/kafka/bin/kafka-topics.sh"

echo "Waiting for Kafka..."

for i in {1..60}; do
  $KAFKA --bootstrap-server $BOOTSTRAP --list >/dev/null 2>&1 && break
  sleep 2
done

echo "Kafka is ready"

echo "Creating CDC topics..."

bash /kafka/topics/cdc_topics.sh

echo "All topics created."