FROM debezium/connect:2.5

USER root

RUN mkdir -p /etc/kafka-connect/jars /opt/jmx-exporter

COPY jmx-exporter/jmx_prometheus_javaagent.jar /opt/jmx-exporter/jmx_prometheus_javaagent.jar
COPY jmx-exporter/config.yml /opt/jmx-exporter/config.yml

USER kafka