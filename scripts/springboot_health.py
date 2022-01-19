#!/usr/bin/python
# -*- coding: UTF-8 -*-
# __Author__ = "catinsky"
# Date: 2021/1/26 0026

import os
import commands
import time
import sys, getopt
import json

""" zabbix监控springBoot的health状态，正常返回1，非正常返回0"""
# 创建列表，存放需要监控的项目名称，可有可无。
app_name = ["future-abroad",]
# 主机IP
host = "127.0.0.1"

# springBoot的health端口,可以添加多个
port_list = [":10010",]

# springBoot的健康检查链接
url_springBoot = "/actuator/health"

# 空列表，存放所有springBoot的非健康检查状态
status_flag = []

# 循环获取多个springBoot的健康状态
for port in port_list:
    curl_shell = "curl -s {host}{port}{url_springBoot}".format(host=host, port=port, url_springBoot=url_springBoot)
    curl_code, curl_output = commands.getstatusoutput(curl_shell)
    if curl_code != 0:
        print(0)
        sys.exit()
    spring_status = json.loads(curl_output)
    # print(spring_status)
    # print(type(spring_status))
    # print(spring_status["status"])

    # 如果命令执行失败或者状态不为UP, 添加flag标记
    if curl_code != 0 or spring_status["status"] != "UP":
        status_flag.append(0)

        # 如果springBoot有异常，取消下面注释，可以快速定位哪个异常。
        # print("springBoot异常，端口为{port}".format(port=port))

# 如果status_flag列表不为空，说明添加了flag标记
status_zabbix = len(status_flag)

# 如果有任意一个springBoot非UP监控状态，返回0，正常情况返回1。用于zabbix最终监控的参数。
if status_zabbix >= 1:
    print(0)
else:
    print(1)

