#!/bin/bash
# 获取jstat文件路径
#test -f /home/deepcam/applications/java/bin/jstat && jstat='/home/deepcam/applications/java/bin/jstat'
#jstat=${jstat:-/usr/local/java/bin/jstat}
jstat="/usr/local/java/bin/jstat"

function getStat() {
        option="$""$2"
        pid=`ps -ef | grep $1 | grep -v grep |grep -v $0| awk '{print $2}'`
        result=`sudo $jstat -gc $pid | awk "NR==2 {print $option}"`
        echo $result
}

case $2 in
        S0C)
                getStat $1 1
                ;;
        S0U)
                getStat $1 3
                ;;
        S1C)
                getStat $1 2
                ;;
        S1U)
                getStat $1 4
                ;;
        EC)
                getStat $1 5
                ;;
        EU)
                getStat $1 6
                ;;
        OC)
                getStat $1 7
                ;;
        OU)
                getStat $1 8
                ;;
        MC)
                getStat $1 9
                ;;
        MU)
                getStat $1 10
                ;;
        CCSC)
                getStat $1 11
                ;;
        CCSU)
                getStat $1 12
                ;;
        YGC)
                getStat $1 13
                ;;
        YGCT)
                getStat $1 14
                ;;
        FGC)
                getStat $1 15
                ;;
        FGCT)
                getStat $1 16
                ;;
        GCT)
                getStat $1 17
                ;;
        *)
                echo "Usage: $0 S0C|S0U|S1C|S1U|EC|EU|OC|OU|MC|MU|CCSC|CCSU|YGC|YGCT|FGC|FGCT|GCT"
                ;;

esac