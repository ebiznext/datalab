#!/usr/bin/env bash
### BEGIN INIT INFO
# Provides:          flume
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Apache Flume Service
# Description:       Apache Flume Service
### END INIT INFO

dir="{{flume.home_dir}}"
user="{{flume.user}}"
cmd="{{flume.home_dir}}/bin/flume-ng agent --name agent --conf {{flume.config.dir}} -f {{flume.config.dir}}/flume-conf.properties -Dflume.monitoring.type=http -Dflume.monitoring.port=41414"

name=`basename $0`
pid_file="/var/run/$name.pid"
stdout_log="{{flume.log.dir}}/$name.init.log"

get_pid() {
    cat "$pid_file"
}

is_running() {
    [ -f "$pid_file" ] && ps `get_pid` > /dev/null 2>&1
}

case "$1" in
    start)
    if is_running; then
        echo " * $name is already started"
    else
        echo "Starting $name"
        cd "$dir"
        sudo -u "$user" $cmd >> "$stdout_log" 2>&1 &
        echo $! > "$pid_file"
        if ! is_running; then
            echo "Unable to start $name, see $stdout_log and $stderr_log"
            exit 1
        fi
    fi
    ;;
    stop)
    if is_running; then
        echo -n "Stopping $name.."
        kill `get_pid`
        for i in {1..10}
        do
            if ! is_running; then
                break
            fi

            echo -n "."
            sleep 1
        done
        echo

        if is_running; then
            echo " * $name is not stopped; may still be shutting down or shutdown may have failed"
            exit 1
        else
            echo " * $name is stopped"
            if [ -f "$pid_file" ]; then
                rm "$pid_file"
            fi
        fi
    else
        echo "Not running"
    fi
    ;;
    restart)
    $0 stop
    if is_running; then
        echo "Unable to stop $name, will not attempt to start"
        exit 1
    fi
    $0 start
    ;;
    status)
    if is_running; then
        echo " * $name is running"
    else
        echo " * $name is stopped"
        exit 1
    fi
    ;;
    *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
