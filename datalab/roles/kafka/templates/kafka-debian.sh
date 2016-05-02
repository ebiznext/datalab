#!/bin/bash
#
# kafka - Startup script for the Apache Kafka broker
#
# chkconfig: 35 85 15
# description: Apache Kafka broker.

### BEGIN INIT INFO
# Provides: kafka
# Required-Start: $local_fs $network $remote_fs
# Required-Stop: $local_fs $network $remote_fs
# Should-Start: $named $time
# Should-Stop: $named $time
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Startup script for the Apache Kafka broker
# Description: Apache Kafka broker.
### END INIT INFO

PATH=/bin:/usr/bin:/sbin:/usr/sbin
NAME=kafka
DESC="Kafka broker"
DEFAULT=/etc/default/$NAME
USER={{ kafka.user }}
GROUP={{ kafka.user }}

if [ `id -u` -ne 0 ]; then
	echo "You need root privileges to run this script"
	exit 1
fi

. /lib/lsb/init-functions

if [ -r /etc/default/rcS ]; then
	. /etc/default/rcS
fi

# The following variables can be overwritten in $DEFAULT

# Directory where the Kafka binary distribution resides
KAFKA_HOME={{kafka.home_dir}}

# Kafka configuration directory
CONF_DIR=$KAFKA_HOME/config

# Kafka configuration file (server.properties)
CONF_FILE=$CONF_DIR/server.properties

# Kafka log directory
LOG_DIR={{kafka.log_dir}}

# Path to the GC log file
#KAFKA_GC_LOG_FILE=$LOG_DIR/gc.log

# Kafka log4j configuration file (log4j.properties)
KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:$CONF_DIR/log4j.properties"

# Kafka Heap opts
KAFKA_HEAP_OPTS="-Xmx2G -Xms2G"

# Kafka JMX opts
KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false "

# Kafka jvm performance opts
KAFKA_JVM_PERFORMANCE_OPTS="-server -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+DisableExplicitGC -Djava.awt.headless=true "

# End of variables that can be overwritten in $DEFAULT

# overwrite settings from default file
if [ -f "$DEFAULT" ]; then
	. "$DEFAULT"
fi

export KAFKA_HOME
export CONF_DIR
export CONF_FILE
export LOG_DIR
export KAFKA_LOG4J_OPTS
export KAFKA_HEAP_OPTS
export KAFKA_JMX_OPTS
export KAFKA_JVM_PERFORMANCE_OPTS

# Define other required variables
# Kafka PID file directory
PID_DIR="/var/run/kafka"
PID_FILE="$PID_DIR/$NAME.pid"
DAEMON=$KAFKA_HOME/bin/kafka-run-class.sh
DAEMON_MODE=true
DAEMON_OPTS="-name kafkaServer -loggc kafka.Kafka {{kafka.home_dir}}/config/server.properties"

# Check DAEMON exists
test -x $DAEMON || exit 0

checkJava() {
	if [ -x "$JAVA_HOME/bin/java" ]; then
		JAVA="$JAVA_HOME/bin/java"
	else
		JAVA=`which java`
	fi

	if [ ! -x "$JAVA" ]; then
		echo "Could not find any executable java binary. Please install java in your PATH or set JAVA_HOME"
		exit 1
	fi
}

case "$1" in
    start)
        checkJava

        log_daemon_msg $"Starting $DESC"

        pid=`pidofproc -p $PID_FILE kafka`
        if [ -n "$pid" ] ; then
            log_begin_msg "Already running."
            log_end_msg 0
            exit 0
        fi

        # Prepare environment
        mkdir -p "$LOG_DIR" && chown "$USER":"$GROUP" "$LOG_DIR"

        # Ensure that the PID_DIR exists (it is cleaned at OS startup time)
        if [ -n "$PID_DIR" ] && [ ! -e "$PID_DIR" ]; then
            mkdir -p "$PID_DIR" && chown "$USER":"$GROUP" "$PID_DIR"
        fi
        if [ -n "$PID_FILE" ] && [ ! -e "$PID_FILE" ]; then
            touch "$PID_FILE" && chown "$USER":"$GROUP" "$PID_FILE"
        fi

        # Start Daemon
        start-stop-daemon --background --name $NAME --start --quiet --user "$USER" -c "$USER" --make-pidfile --pidfile "$PID_FILE" -d "$KAFKA_HOME" --exec $DAEMON -- $DAEMON_OPTS
        return=$?
        if [ $return -eq 0 ]
        then
            i=0
            timeout=10
            # Wait for the process to be properly started before exiting
            until { cat "$PID_FILE" | xargs kill -0; } >/dev/null 2>&1
            do
                sleep 1
                i=$(($i + 1))
                if [ $i -gt $timeout ]; then
                    log_end_msg 1
                    exit 1
                fi
            done
        else
            log_end_msg $return
        fi
        ;;
    stop)
        log_daemon_msg $"Stopping $DESC"

        if [ -f "$PID_FILE" ]; then
            start-stop-daemon --stop --pidfile "$PID_FILE" \
                --user "$USER" \
                --retry=TERM/20/KILL/5 >/dev/null
            if [ $? -eq 1 ]; then
                log_progress_msg "$DESC is not running but pid file exists, cleaning up"
            elif [ $? -eq 3 ]; then
                PID="`cat $PID_FILE`"
                log_failure_msg "Failed to stop $DESC (pid $PID)"
                exit 1
            fi
            rm -f "$PID_FILE"
        else
            log_progress_msg "(not running)"
        fi

        log_end_msg 0
        ;;
    status)
        status_of_proc -p $PID_FILE "$NAME" "$NAME" && exit 0 || exit $?
        ;;
    restart|reload|force-reload)
        if [ -f "$PID_FILE" ]; then
            $0 stop
            sleep 1
        fi
        $0 start
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|reload|force-reload|status}"
        exit 2
esac

exit 0
