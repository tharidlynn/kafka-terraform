#!/usr/bin/env bash

broker_id=$1

sudo apt-get update
sudo apt-get install openjdk-8-jdk -y

# add directories that support kafka
mkdir -p /opt/kafka
mkdir -p /var/run/kafka
mkdir -p /var/log/kafka

# Install Kafka
echo "Installing kafka"
cd /tmp
curl -LkO https://www-us.apache.org/dist/kafka/2.0.0/kafka_2.11-2.0.0.tgz
cd /opt/kafka
tar xzf /tmp/kafka_2.11-2.0.0.tgz
rm /tmp/kafka_2.11-2.0.0.tgz
cd kafka_2.11-2.0.0

# configure the server
cat config/server.properties \
    | sed "s|broker.id=0|broker.id=$broker_id|" \
    | sed 's|log.dirs=/tmp/kafka-logs|log.dirs=${mount_point}/kafka-logs|' \
    | sed 's|num.partitions=1|num.partitions=${num_partitions}|' \
    | sed 's|log.retention.hours=168|log.retention.hours=${log_retention}|' \
    | sed 's|zookeeper.connect=localhost:2181|zookeeper.connect=${zookeeper_connect}|' \
    > /tmp/server.properties
echo "# enable topic deletion" >> /tmp/server.properties
echo "delete.topic.enable = true" >> /tmp/server.properties
echo "# replication factor" >> /tmp/server.properties
echo "default.replication.factor=${repl_factor}" >> /tmp/server.properties
mv /tmp/server.properties config/server.properties