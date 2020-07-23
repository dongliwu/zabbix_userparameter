#!/bin/bash
HOST='127.0.0.1'
PORT=80
NGINX_COMMAND=$1

function ping() {
	/sbin/pidof nginx | wc -l 
}

function active() {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status/" |awk '/Active/ {print $NF}'
}
function reading() {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status/" |awk '/Reading/ {print $2}'
}
function writing() {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status/" |awk '/Writing/ {print $4}'
}
function waiting() {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status/" |awk '/Waiting/ {print $6}'
}
function accepts() {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status/" |awk 'NR==3 {print $1}'
}
function handled() {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status/" |awk 'NR==3 {print $2}'
}
function requests() {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status/" |awk 'NR==3 {print $3}'
}

case $NGINX_COMMAND in
	ping)
		ping;
	;;
	active)
		active;
	;;
	reading)
		reading;
	;;
	writing)
		writing;
	;;
	waiting)
		waiting;
	;;
	accepts)
		accepts;
	;;
	handled)
		handled;
	;;
	requests)
		requests;
	;;
    *)
		echo $"USAGE:$0 {ping|active|reading|writing|waiting|accepts|handled|requests}"
esac
