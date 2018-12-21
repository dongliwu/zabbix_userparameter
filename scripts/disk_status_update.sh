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
        exit 0
    else
        echo "Unable to update status"
        exit 1
    fi
}

updateStatus
