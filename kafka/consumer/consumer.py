import json
from confluent_kafka import Consumer

conf = {
    "bootstrap.servers": "localhost:9094",
    "group.id": "test-consumer",
    "auto.offset.reset": "earliest"
}

consumer = Consumer(conf)

consumer.subscribe([
    "customers.public.users",
    "customers.public.orders"
])

print("Listening for CDC events...\n")

while True:
    msg = consumer.poll(1)

    if msg is None:
        continue

    if msg.error():
        print(msg.error())
        continue

    data = json.loads(msg.value().decode("utf-8"))

    payload = data["payload"]
    op = payload["op"]
    after = payload["after"]

    print(f"Topic: {msg.topic()} | Operation: {op}")
    print("Data:", after)
    print("-" * 40)