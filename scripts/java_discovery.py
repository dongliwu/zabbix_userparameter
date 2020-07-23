#!/usr/bin/python
#coding:utf-8
# 获取磁盘脚本
import commands
import json

cmd="ps aux | grep '\-jar'| grep -v grep | awk '{print $NF}' | awk -F'/' '{print $NF}'"
result = commands.getoutput(cmd).split()

jars = [ {'{#JAVA_NAME}':jar} for jar in result ]
print(json.dumps({'data':jars},indent=4,separators=(',',':')))