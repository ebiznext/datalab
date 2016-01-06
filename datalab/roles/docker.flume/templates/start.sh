#!/bin/bash

if [[ -z "$FLUME_AGENT_NAME" ]]; then
    export FLUME_AGENT_NAME=agent
fi

if [[ -z "$FLUME_CONFIG_FILE" ]]; then
    export FLUME_CONFIG_FILE={{flume_config_dir}}/flume-conf.properties
fi

if [[ -z "$FLUME_LOG_DIR" ]]; then
    export FLUME_LOG_DIR={{flume_log_dir}}
fi

{{flume_home_dir}}/bin/flume-ng agent -n $FLUME_AGENT_NAME -c {{flume_config_dir}} -f $FLUME_CONFIG_FILE -Dflume.monitoring.type=http -Dflume.monitoring.port=41414 >>${FLUME_LOG_DIR}/flume.${FLUME_AGENT_NAME}.init.log 2>&1
