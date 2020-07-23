#!/bin/bash
REDISCLI="/usr/local/bin/redis-cli"
HOST="localhost"
PORT=7001
PASSWORD="deepcam520&"

function getStatus() {
	result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD -c info 2> /dev/null | grep -w $1  | awk -F':' '{print $2}'`
	echo $result
}

if [[ $# == 1 ]];then
	case $1 in
		connected_clients)
			getStatus "connected_clients"
		;;
        used_memory)
          getStatus "used_memory"
        ;;
		used_memory_rss)
			getStatus "used_memory_rss"
		;;
		used_memory_peak)
			getStatus "used_memory_peak"
		;;
		total_connections_received)
			getStatus "total_connections_received"
		;;
		instantaneous_ops_per_sec)
			getStatus "instantaneous_ops_per_sec"
		;;
		instantaneous_input_kbps)
			getStatus "instantaneous_input_kbps"
		;;
		instantaneous_output_kbps)
			getStatus "instantaneous_output_kbps"
		;;
		rejected_connections)
			getStatus "rejected_connections"
		;;
		expired_keys)
			getStatus "expired_keys"
		;;
		evicted_keys)
			getStatus "evicted_keys"
		;;
		keyspace_hits)
			getStatus "keyspace_hits"
		;;
		keyspace_misses)
			getStatus "keyspace_misses"
		;;
		*)
			echo -e "\033[33mUsage: $0 {connected_clients|used_memory|used_memory_rss|used_memory_peak|total_connections_received|instantaneous_ops_per_sec|instantaneous_input_kbps|instantaneous_output_kbps|rejected_connections|expired_keys|evicted_keys|keyspace_hits|keyspace_misses}\033[0m"
		;;
	esac
fi
