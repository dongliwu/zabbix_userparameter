#!/bin/bash

CACHE="/tmp/httpd-status.log"

function updateStatus(){
	PORT=$1
    URL="http://127.0.0.1:$PORT/server-status?auto"
    curl --insecure --location --silent $URL > $CACHE
    if [ $? -eq 0 ];then
        exit 0
    else
        echo "Unable to update status"
        exit 1
    fi
}

function getItem(){
	case $1 in
	'TotalAccesses')
		value="`awk '/^Total Accesses:/ {print $3}' < \"$CACHE\"`"
		;;
	'TotalKBytes')
		value="`awk '/^Total kBytes:/ {print $3}' < \"$CACHE\"`"
		;;
	'CPULoad')
		value="`awk '/^CPULoad:/ {print $2}' < \"$CACHE\"`"
		;;
	'Uptime')
		value="`awk '/^Uptime:/ {print $2}' < \"$CACHE\"`"
		;;
	'ReqPerSec')
		value="`awk '/^ReqPerSec:/ {print $2}' < \"$CACHE\"`"
		;;
	'BytesPerSec')
		value="`awk '/^BytesPerSec:/ {print $2}' < \"$CACHE\"`"
		;;
	'BytesPerReq')
		value="`awk '/^BytesPerReq:/ {print $2}' < \"$CACHE\"`"
		;;
	'BusyWorkers')
		value="`awk '/^BusyWorkers:/ {print $2}' < \"$CACHE\"`"
		;;
	'IdleWorkers')
		value="`awk '/^IdleWorkers:/ {print $2}' < \"$CACHE\"`"
		;;
	'WaitingForConnection')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "_" }; { print NF-1 }'`"
		;;
	'StartingUp')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "S" }; { print NF-1 }'`"
		;;
	'ReadingRequest')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "R" }; { print NF-1 }'`"
		;;
	'SendingReply')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "W" }; { print NF-1 }'`"
		;;
	'KeepAlive')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "K" }; { print NF-1 }'`"
		;;
	'DNSLookup')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "D" }; { print NF-1 }'`"
		;;
	'ClosingConnection')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "C" }; { print NF-1 }'`"
		;;
	'Logging')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "L" }; { print NF-1 }'`"
		;;
	'GracefullyFinishing')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "G" }; { print NF-1 }'`"
		;;
	'IdleCleanupOfWorker')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "I" }; { print NF-1 }'`"
		;;
	'OpenSlotWithNoCurrentProcess')
		value="`awk '/^Scoreboard:/ {print $2}' < \"$CACHE\" | awk 'BEGIN { FS = "." }; { print NF-1 }'`"
		;;
	*)
		echo "Unsupported parameters"
		exit 1
		;;
	esac
    echo $value
}

if [ "$1"x == "update"x ] && [ $# -eq 2 ];then
    updateStatus $2
elif [ "$1"x == "get"x ] && [ $# -eq 2 ];then
    getItem $2
else
    echo "Incorrect parameters"
    exit 1
fi
