#!/bin/bash

#MYSQL="/usr/local/mysql/bin/mysql"
MYSQL="/bin/mysql"
MYSQL_CONF="/usr/local/zabbix/.my.cnf"
FILE="/tmp/mysql_status.txt"

case $1 in
	update)
		echo "show global status;"|${MYSQL} --defaults-extra-file=${MYSQL_CONF} -N > ${FILE}
		;;
	version)
		${MYSQL} -V
		;;
	ping)
		${MYSQL}admin --defaults-extra-file=${MYSQL_CONF} ping | grep -c alive
		;;
	*)
		egrep "$1\>" ${FILE} | awk '{print $2}'
		;;
esac
