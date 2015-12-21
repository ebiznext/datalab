#!/bin/bash

if [[ -z "$FLUME_AGENT_NAME" ]]; then
    export FLUME_AGENT_NAME=agent
fi

if [[ -z "$FLUME_CONFIG_FILE" ]]; then
    export FLUME_CONFIG_FILE={{flume_config_dir}}/flume-conf.properties
fi

{{flume_home_dir}}/bin/flume-ng agent -n $FLUME_AGENT_NAME -c {{flume_config_dir}} -f $FLUME_CONFIG_FILE
