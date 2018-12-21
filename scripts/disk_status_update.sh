#!/bin/bash

cache="/tmp/disk_status.log"

function updateStatus(){
    iostat -x -d 1 2 > $cache
    if [ $? -eq 0 ];then
        exit 0
    else
        echo "Unable to update status"
        exit 1
    fi
}

updateStatus
