#!/usr/bin/env bash

su - {{kibana_user}} -c "{{kibana_home_directory}}/bin/kibana >> {{ kibana_log_file }} 2>&1"
