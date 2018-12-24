#!/bin/env python
#coding:utf-8
# 获取raid卡生成的卷
import commands
import json

cmd="sudo /usr/local/bin/MegaCli -LDInfo -Lall -aALL | grep '^Virtual Drive' | awk -F ':' '{print $2}' | awk '{print $1}'"
result = commands.getoutput(cmd).split()

disks = [ {'{#RAID_VOLUM}':disk} for disk in result ]
print(json.dumps({'data':disks},indent=4,separators=(',',':')))
