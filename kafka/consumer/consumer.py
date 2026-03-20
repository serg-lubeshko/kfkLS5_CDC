import json
import logging

from confluent_kafka import Consumer

logger = logging.getLogger(__name__)


def setup_logging() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
    )


def create_consumer() -> Consumer:
    conf = {
        "bootstrap.servers": "localhost:9094",
        "group.id": "test-consumer",
        "auto.offset.reset": "earliest",
    }

    consumer = Consumer(conf)
    consumer.subscribe([
        "customers.public.users",
        "customers.public.orders",
    ])
    return consumer


def process_message(msg) -> None:
    raw_value = msg.value()
    if raw_value is None:
        logger.warning("Empty message received from topic=%s", msg.topic())
        return

    data = json.loads(raw_value.decode("utf-8"))

    payload = data.get("payload")
    if not payload:
        logger.warning("Message without payload. topic=%s data=%s", msg.topic(), data)
        return

    op = payload.get("op")
    after = payload.get("after")
    before = payload.get("before")

    event_data = before if op == "d" else after

    logger.info(
        "CDC event received | topic=%s partition=%s offset=%s operation=%s data=%s",
        msg.topic(), msg.partition(), msg.offset(), op, event_data, )


def run_consumer() -> None:
    consumer = create_consumer()
    logger.info("!!!!!Listening for CDC events!!!!")

    try:
        while True:
            msg = consumer.poll(1.0)

            if msg is None:
                continue

            if msg.error():
                logger.error("Kafka error: %s", msg.error())
                continue

            try:
                process_message(msg)
            except Exception:
                logger.exception("Error | topic=%s partition=%s offset=%s",
                                 msg.topic(), msg.partition(), msg.offset())
    except KeyboardInterrupt:
        logger.info("Consumer stopped by user")
    finally:
        consumer.close()
        logger.info("Consumer closed")
