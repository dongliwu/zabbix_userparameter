#!/bin/bash
REDISCLI="/usr/local/bin/redis-cli"
HOST="localhost"
PORT=7001
PASSWORD="deepcam520&"

function getStatus() {
	result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD -c cluster info 2> /dev/null | grep -w $1  | awk -F':' '{print $2}'`
	echo $result
}

if [[ $# == 1 ]];then
	case $1 in
		cluster_state)
			result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD -c cluster info 2> /dev/null | grep -w "cluster_state" | awk -F':' '{print $2}'| grep -c ok`
			echo $result
		;;
		cluster_slots_assigned)
			getStatus "cluster_slots_assigned"
		;;
		cluster_slots_ok)
			getStatus "cluster_slots_ok" 
		;;
		cluster_slots_pfail)
			getStatus "cluster_slots_pfail"
		;;
		cluster_slots_fail)
			getStatus "cluster_slots_fail"
		;;
		cluster_known_nodes)
			getStatus "cluster_known_nodes"
		;;
		cluster_size)
			getStatus "cluster_size"
		;;
		cluster_current_epoch)
			getStatus "cluster_current_epoch"
		;;
		cluster_my_epoch)
			getStatus "cluster_my_epoch"
		;;
		cluster_stats_messages_ping_sent)
			getStatus "cluster_stats_messages_ping_sent"
		;;
		cluster_stats_messages_pong_sent)
			getStatus "cluster_stats_messages_pong_sent"
		;;
		cluster_stats_messages_sent)
			getStatus "cluster_stats_messages_sent"
		;;
		cluster_stats_messages_ping_received)
			getStatus "cluster_stats_messages_ping_received"
		;;
		cluster_stats_messages_pong_received)
			getStatus "cluster_stats_messages_pong_received"
		;;
		cluster_stats_messages_received)
			getStatus "cluster_stats_messages_received"
		;;
		cluster_keys_number)
			result=`$REDISCLI --cluster info $HOST:$PORT -a $PASSWORD 2> /dev/null| grep OK| awk '{print $2}'`
			echo $result
			;;
		*)
			echo -e "\033[33mUsage: $0 {cluster_state|cluster_slots_assigned|cluster_slots_ok|cluster_slots_pfail|cluster_slots_fail|cluster_known_nodes|cluster_size|cluster_current_epoch|cluster_my_epoch|cluster_stats_messages_ping_sent|cluster_stats_messages_pong_sent|cluster_stats_messages_sent|cluster_stats_messages_ping_received|cluster_stats_messages_pong_received|cluster_stats_messages_received}\033[0m"
			;;
	esac
fi
