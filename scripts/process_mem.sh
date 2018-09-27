#!bin/bash

PROCESS=$1

result=`ps aux | grep "$PROCESS" | grep -v "grep" | awk '{sum+=$6}; END{print sum}'`

echo $result
