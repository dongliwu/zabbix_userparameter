#!/bin/bash
. /usr/local/zabbix/.redis.cnf

function getStatus() {
	result=`$REDISCLI -h $HOST -p $PORT -a $PASSWORD -c info 2> /dev/null | grep -w $1  | awk -F':' '{print $2}'`
	echo $result
}

function discovery() {
        array=(`$REDISCLI -h $HOST -p $PORT -a $PASSWORD -c info 2> /dev/null | grep ":keys=" | awk -F: '{print $1}'`)
        length=${#array[@]}
        printf "{\n"
        printf  '\t'"\"data\":["
        for ((i=0;i<$length;i++))
        do
                printf '\n\t\t{'
                printf "\"{#DB}\":\"${array[$i]}\"}"
                if [ $i -lt $[$length-1] ];then
                        printf ','
                fi
        done
        printf  "\n\t]\n"
        printf "}\n"
}

if [[ $# == 1 ]];then
	case $1 in
		ping)
			$REDISCLI -h $HOST -p $PORT -a $PASSWORD -c ping 2> /dev/null | grep -c PONG 
		;;
		discovery)
			discovery
		;;
		redis_version)
			getStatus "redis_version"
		;;
		redis_mode)
			getStatus "redis_mode"
		;;
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
			echo -e "\033[33mUsage: $0 {discovery|connected_clients|used_memory|used_memory_rss|used_memory_peak|total_connections_received|instantaneous_ops_per_sec|instantaneous_input_kbps|instantaneous_output_kbps|rejected_connections|expired_keys|evicted_keys|keyspace_hits|keyspace_misses}\033[0m"
		;;
	esac
elif [[ $# == 2 ]];then
	case $2 in 
		keys)
			$REDISCLI -h $HOST -p $PORT -a $PASSWORD -c info 2> /dev/null | grep -w $1  | awk -F'=|,' '{print $2}'
		;;
		expires)
			$REDISCLI -h $HOST -p $PORT -a $PASSWORD -c info 2> /dev/null | grep -w $1  | awk -F'=|,' '{print $4}'
		;;
		avg_ttl)
			$REDISCLI -h $HOST -p $PORT -a $PASSWORD -c info 2> /dev/null | grep -w $1  | awk -F'=|,' '{print $6}'
		;;
		*)
			echo -e "\033[33mUsage: $0 {db0 keys|db0 expires|db0 avg_ttl}\033[0m" 
		;;
	esac
fi