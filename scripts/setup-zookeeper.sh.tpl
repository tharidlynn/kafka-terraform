#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install openjdk-8-jdk -y

# download zookeeper
cd /tmp
curl -O http://apache.org/dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz

mkdir -p /opt/zookeeper
mkdir -p /var/lib/zookeeper

# unpack the tarball
cd /opt/zookeeper
tar xzf /tmp/zookeeper-3.4.10.tar.gz
rm /tmp/zookeeper-3.4.10.tar.gz
cd zookeeper-3.4.10

# configure the server
cat conf/zoo_sample.cfg \
    | sed 's|dataDir=/tmp/zookeeper|dataDir=/var/lib/zookeeper|' > /tmp/zoo.cfg
mv /tmp/zoo.cfg conf/zoo.cfg

# configure the logging
cat conf/log4j.properties \
    | sed 's/zookeeper.root.logger=INFO, CONSOLE/zookeeper.root.logger=INFO/' \
    > /tmp/log4j.properties
mv /tmp/log4j.properties conf/log4j.properties