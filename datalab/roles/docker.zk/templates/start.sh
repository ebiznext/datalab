#!/usr/bin/env bash

{{zookeeper_home_dir}}/bin/zkServer.sh start-foreground >> $ZOO_LOG_DIR/zookeeper.log 2>&1
