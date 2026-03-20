from kafka.consumer.consumer import setup_logging, run_consumer


def main() -> None:
    setup_logging()
    run_consumer()


if __name__ == "__main__":
    main()