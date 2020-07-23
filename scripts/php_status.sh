#!/bin/bash
# 

PORT=40000
CACHE="/tmp/php-status.log"

function ping() {
	result=`curl --insecure --location --silent http://127.0.0.1:$PORT/ping`
    if [[ "$result"X == "pongX" ]];then
            echo 1
    else
            echo 0
    fi
}

function updateStatus(){
    URL="http://127.0.0.1:$PORT/php_status"
    curl --insecure --location --silent $URL > $CACHE
    if [ $? -eq 0 ];then
        exit 0
    else
        echo "Unable to update status"
        exit 1
    fi
}

function getStatus() {
	result=`cat $CACHE | grep -w "$1"  | awk -F':' 'NR==1 {print $2}'`
	echo $result
}

case $1 in
	ping)
		ping
		;;
	update)
		updateStatus
		;;
	pool)
		getStatus pool
		;;
	process_manager)
		getStatus "process manager"
		;;
	start_time)
		getStatus "start time"
		;;
	start_since)
		getStatus "start since"
		;;
	accepted_conn)
		getStatus "accepted conn"
		;;
	listen_queue)
		getStatus "listen queue"
		;;
	max_listen_queue)	
		getStatus "max listen queue"
		;;
	listen_queue_len)
		getStatus "listen queue len"
		;;
	idle_processes)
		getStatus "idle processes"
		;;
	active_processes)
		getStatus "active processes"
		;;
	total_processes)
		getStatus "total processes"
		;;
	max_active_processes)
		getStatus "max active processes"
		;;
	max_children_reached)
		getStatus "max children reached"
		;;
	slow_requests)
		getStatus "slow requests"
		;;
	*)
		echo "Usage: $0 ping|update|pool|process_manager|start_time|start_since|accepted_conn|listen_queue|max_listen_queue|listen_queue_len|idle_processes|active_processes|total_processes|max_active_processes|max_children_reached|slow_requests"
		exit 1
esac
