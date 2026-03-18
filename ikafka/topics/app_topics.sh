#!/bin/bash

BOOTSTRAP="kafka-0:9092"

create_topic () {
  /opt/kafka/bin/kafka-topics.sh \
    --bootstrap-server $BOOTSTRAP \
    --create \
    --if-not-exists \
    --topic $1 \
    --partitions 3 \
    --replication-factor 3 \
    --config retention.ms=604800000
}

create_topic messages
create_topic filtered_messages