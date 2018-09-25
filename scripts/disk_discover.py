#!/usr/bin/python
#coding:utf-8
# 获取磁盘脚本
import commands
import json

cmd="egrep '[shv]d[a-z]+$' /proc/partitions | awk '{print $4}'"
result = commands.getoutput(cmd).split()

disks = [ {'{#DISK_NAME}':disk} for disk in result ]
print(json.dumps({'data':disks},indent=4,separators=(',',':')))
