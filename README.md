# Практическая работа 5. Kafka Change Data Capture (CDC) Project

Debezium Connector для передачи данных из базы данных PostgreSQL в Apache Kafka с использованием механизма Change Data Capture (CDC).
Цель практической работы — закрепить знания о работе с коннекторами, а также научиться собирать и анализировать метрики.

## Структура проекта

### 1. Kafka (`/kafka`)
- `consumer/`: Сonsumer для чтения сообщений из Kafka.
- `topics/`: Скрипты для управления топиками Kafka.
  - `00_create-topics.sh`: Главный скрипт для инициализации всех необходимых топиков.

### 2. Connector (`/connector`)
Конфигурация и управление Kafka Connect.
- `build/`: Файлы для сборки образа Kafka Connect (Dockerfile, JMX Exporter). JMX Exporter снимает JMX-метрики с Kafka Connect/JVM и отдает их в формате, который читает Prometheus. Java agent нужен, чтобы Kafka Connect отдал JMX-метрики в формате Prometheus.
- `config/`: JSON конфигурации для коннекторов (`postgres-connector.json`).
- `confluent-hub-components/`: Директория с JAR-файлами плагинов Kafka Connect (Debezium).
- `register-connector.sh`: Скрипт для регистрации коннектора через REST API Kafka Connect.

### 3. PostgreSQL (`/postgres`)
- `init-scripts/`: SQL скрипты для инициализации схем и наполнения бд при старте. Таблицы, которые будут использоваться для работы — users и orders.
- `custom-config.conf`: Спец. настройки Postgres для поддержки логической репликации для Debezium.

### 4. Мониторинг и Инфраструктура
- `docker-compose.yml`: Описывает все сервисы: Kafka (3 брокера), Postgres, Kafka Connect, Prometheus, Grafana, Kafka UI.
- `monitoring/`: Конфигурации для мониторинга (Prometheus).

## Основные URL сервисов

- **Kafka UI:** [http://localhost:8080](http://localhost:8080) —просмотр топиков и сообщений.
- **Kafka Connect API:** [http://localhost:8083](http://localhost:8083) — управление коннекторами.
- **Prometheus:** [http://localhost:9090](http://localhost:9090) — сбор метрик.
- **Grafana:** [http://localhost:3001](http://localhost:3001) — визуализация метрик (логин: `admin`, пароль: `admin`).

## Как запустить

1. Запустите инфраструктуру:
   ```bash
   ./start.sh
   ```
2. (Опционально) Зарегистрируйте коннектор вручную, !!!если!!! это не произошло автоматически:
   ```bash
   ./connector/register-connector.sh
   ```

## Проверка работы

### 1. Ручной запуск консьюмера (Consumer)
Для того чтобы увидеть события CDC в консоли, запустите Python-потребитель:
```bash
# Убедитесь, что установлены зависимости (confluent-kafka)
# Можно запустить напрямую:
python3 kafka/consumer/main_consumer.py
```

### 2. Генерация данных в БД
Для проверки работы CDC можно выполнить SQL-запросы из файла `postgres/init-scripts/002_data.sql` вручную или через консоль контейнера:
```bash
docker exec -it postgres psql -U postgres-user -d customers -f /docker-entrypoint-initdb.d/002_data.sql
```
После этой команды консьюмер должен отобразить события вставки данных.

### 3. Проверка состояния Kafka Connect
Полезные команды для проверки работы коннектора:
```bash
# Проверка списка зарегистрированных коннекторов
curl http://localhost:8083/connectors

# Детальный статус коннектора postgres-connector
curl http://localhost:8083/connectors/postgres-connector/status | jq

# Список установленных плагинов
curl http://localhost:8083/connector-plugins | jq
```

## Мониторинг в Grafana

Чтобы увидеть метрики в Grafana:
1. Зайти на [http://localhost:3001](http://localhost:3001) (admin/admin).
2. Перейдите в **Connections -> Data Sources** и добавьте Prometheus (`http://prometheus:9090`).
3. Создать новый Dashboard и добавить панель.
4. В поле запроса ввести, например:
   `kafka_connect_connector_metrics_connector_class`
   Это покажет класс запущенного коннектора. Также можно искать метрики по префиксу `kafka_connect_`.

## Как остановить

```bash
./stop.sh
```
