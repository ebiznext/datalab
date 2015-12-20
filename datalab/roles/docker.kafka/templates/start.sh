#!/bin/bash

if [[ -z "$KAFKA_ADVERTISED_HOST_NAME" ]]; then
    export KAFKA_ADVERTISED_HOST_NAME=$(route -n | awk '/UG[ \t]/{print $2}')
fi
if [[ -z "$KAFKA_ADVERTISED_PORT" ]]; then
    export KAFKA_ADVERTISED_PORT=$(docker port `hostname` {{kafka_config_port}} | sed -r "s/.*:(.*)/\1/g")
fi

if [[ -z "$KAFKA_BROKER_ID" ]]; then
    export KAFKA_BROKER_ID={{kafka_config_broker_id}}
fi

if [[ -z "$KAFKA_ZOOKEEPERS" ]]; then
    export KAFKA_ZOOKEEPERS={{kafka_config_zookeepers|join(',')}}
fi

export KAFKA_LOG_FILE={{kafka_log_dirs}}/kafka-$KAFKA_BROKER_ID.log

sed "s/advertised\.host\.name={{kafka_config_advertised_hostname}}/advertised\.host\.name=$KAFKA_ADVERTISED_HOST_NAME/g;s/advertised\.port={{kafka_config_advertised_port}}/advertised\.port=$KAFKA_ADVERTISED_PORT/g;s/broker\.id={{kafka_config_broker_id}}/broker\.id=$KAFKA_BROKER_ID/g;s/zookeeper\.connect={{kafka_config_zookeepers|join(',')}}/zookeeper\.connect=$KAFKA_ZOOKEEPERS/g" < config/server.properties > config/server-docker.properties

{{kafka_home_dir}}/bin/kafka-server-start.sh config/server-docker.properties >> $KAFKA_LOG_FILE 2>&1
