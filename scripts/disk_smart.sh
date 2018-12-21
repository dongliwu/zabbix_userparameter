#!/bin/bash
# set -vx

DISK=$1

result=$(smartctl -H /dev/$DISK)

if [[ `echo $result|grep -v grep|grep 'PASSED'` ]];then
	echo "1"
else
	echo "0"
fi
