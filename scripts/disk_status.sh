#!/bin/bash

DISK=$1
ITEM=$2

cache="/tmp/disk_status.log"

function getItem(){
    cat $cache | grep "^$1 " | awk "END {print $2}"
}

case $ITEM in
    readps)
        getItem $DISK '$4'
        ;;
    writeps)
        getItem $DISK '$5'
        ;;
    readBSec)
        getItem $DISK '$6'
        ;;
    writeBSec)
        getItem $DISK '$7'
        ;;
    queue)
        getItem $DISK '$9'
        ;;
    readAwait)
        getItem $DISK '$11'
        ;;
    writeAwait)
        getItem $DISK '$12'
        ;;
    svctm)
        getItem $DISK '$13'
        ;;
    util)
        getItem $DISK '$14'
        ;;
esac
