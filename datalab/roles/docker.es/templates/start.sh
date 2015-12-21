#!/usr/bin/env bash

su - {{elasticsearch_user}} -c "{{elasticsearch_home_directory}}/bin/elasticsearch -Des.default.path.conf={{elasticsearch_config_directory}}"
