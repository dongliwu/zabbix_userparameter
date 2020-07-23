#!/bin/bash
#

function getStatus() {
	result=`/usr/bin/env ss -ant|grep -c $1`
	echo $result
}

case $1 in 
	CLOSE-WAIT)
		getStatus CLOSE-WAIT
		;;
	CLOSED)
		getStatus CLOSED
		;;
	CLOSING)
		getStatus CLOSING
		;;
	ESTAB)
		getStatus ESTAB
		;;
	FIN-WAIT-1)
		getStatus FIN-WAIT-1
		;;
	FIN-WAIT-2)
		getStatus FIN-WAIT-2
		;;
	LAST-ACK)
		getStatus LAST-ACK
		;;
	LISTEN)
		getStatus LISTEN
		;;
	SYN-RECV)
		getStatus SYN-RECV
		;;
	SYN-SENT)
		getStatus SYN-SENT
		;;
	TIME-WAIT)
		getStatus TIME-WAIT
		;;
	*)
		echo "Usage: $0 CLOSE-WAIT|CLOSED|CLOSING|ESTAB|FIN-WAIT-1|FIN-WAIT-2|LAST-ACK|LISTEN|SYN-RECV|SYN-SENT|TIME-WAIT" && exit 1
esac
