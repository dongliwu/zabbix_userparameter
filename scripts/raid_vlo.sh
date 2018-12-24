#!/bin/bash
# set -vx

VOL=$1
ITEM=$2

if [ "${ITEM}" == "state" ]; then
	RESULT=`sudo /usr/local/bin/MegaCli -LDInfo -L${VOL} -aALL | grep "^State" | awk -F : '{print $2}'|awk '{print $1}'`
	if [ "$RESULT"x == "Optimal"x ]; then
		# raid处于正常状态
		echo "1"
	else
		# raid出现故障
		echo "0"
	fi
else
	echo "ERROR: bad item"
	exit 1
fi
