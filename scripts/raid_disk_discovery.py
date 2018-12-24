#!/bin/env python
#coding:utf-8
# 获取raid卡底层磁盘
import commands
import json

cmd="sudo /usr/local/bin/MegaCli -PDList -aALL | awk '/^Enclosure Device ID: /{e=$4} /^Slot Number: /{s=$3} /^PD Type: /{print e\":\"s}'"
result = commands.getoutput(cmd).split()

disks = [ {'{#RAID_DISK':disk} for disk in result ]
print(json.dumps({'data':disks},indent=4,separators=(',',':')))

