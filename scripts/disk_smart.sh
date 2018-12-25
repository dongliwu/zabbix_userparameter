#!/bin/bash
# set -vx

DISK=$1

EXEC=`which smartctl`

if [ -z "${EXEC}" ]; then
   echo "ERROR: Couldn't find smartctl";
   exit 1;
fi


if [[ $DISK == v* ]]; then
	echo "ERROR: Unsupported disk type"
	exit 1
fi

RESULT=$(sudo ${EXEC} -H /dev/$DISK)
STATUS=$(echo ${RESULT} |  grep -E 'OK|PASSED' | wc -l)

if [[ ${STATUS} -eq 1 ]];then
	echo "1" # smart检测硬盘为健康状态
else
	echo "0" # smart检测硬盘为非健康状态，需紧急更换硬盘
fi
