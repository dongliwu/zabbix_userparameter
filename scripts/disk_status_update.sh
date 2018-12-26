#!/bin/bash

DISK=$1
CACHE="/tmp/disk_status.log"
EXEC=`which iostat`

if [ -z "${EXEC}" ]; then
   echo "ERROR: Couldn't find iostat";
   exit 1;
fi

function updateStatus(){
    ${EXEC} -x -d 1 2 > $CACHE
    if [ $? -eq 0 ];then
        # 状态更新成功
        echo 1
    else
        # 状态更新失败
        echo 0
    fi
}

updateStatus
