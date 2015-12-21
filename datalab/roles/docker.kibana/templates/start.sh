#!/usr/bin/env bash

if [[ -z "$KIBANA_ES_HOST_NAME" ]]; then
    export KIBANA_ES_HOST_NAME={{elasticsearch_config_http_server_host|replace('.', '\\\\.')}}
fi

if [[ -z "$KIBANA_ES_PORT" ]]; then
    export KIBANA_ES_PORT={{elasticsearch_config_http_server_port}}
fi

sed "s/{{elasticsearch_config_http_server_host|replace('.', '\\\\.')}}/$KIBANA_ES_HOST_NAME/g;s/{{elasticsearch_config_http_server_port}}/$KIBANA_ES_PORT/g" < {{kibana_home_directory}}/config/kibana.yml > {{kibana_home_directory}}/config/kibana-docker.yml
chown {{kibana_user}} {{kibana_home_directory}}/config/kibana-docker.yml
sed "s/kibana\\.yml/kibana-docker\\.yml/g" < {{kibana_home_directory}}/bin/kibana > {{kibana_home_directory}}/bin/kibana-docker
chmod u+x {{kibana_home_directory}}/bin/kibana-docker
chown {{kibana_user}} {{kibana_home_directory}}/bin/kibana-docker

su - {{kibana_user}} -c "{{kibana_home_directory}}/bin/kibana-docker >> {{ kibana_log_file }} 2>&1"
