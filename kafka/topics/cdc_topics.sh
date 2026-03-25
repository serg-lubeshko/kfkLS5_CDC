#!/bin/bash

#<database>.<schema>.<table>

BOOTSTRAP="kafka-0:9092"
KAFKA="/opt/bitnami/kafka/bin/kafka-topics.sh"

create_topic () {
   $KAFKA \
    --bootstrap-server $BOOTSTRAP \
    --create \
    --if-not-exists \
    --topic $1 \
    --partitions 3 \
    --replication-factor 3 \
#    --config cleanup.policy=compact
}

create_topic customers.public.users
create_topic customers.public.orders