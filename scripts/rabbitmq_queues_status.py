#!/usr/bin/python
#coding:utf-8

import ConfigParser
import requests
import json
import base64
import sys
import os

conf = ConfigParser.ConfigParser()
dir=os.path.split(os.path.realpath(__file__))[0]
conf.read(dir + "/rabbitmq.conf")

class RabbitMQ(object):

    def __init__(self, username='guest', password='guest',
                      hostname='localhost', port=15672, protocol='http'):
        self.username = username
        self.password = password
        self.hostname = hostname
        self.port = port
        self.protocol = protocol

    def getQueueStatus(self, vhost, queue):
        '''获取队列状态信息'''
        url = "%s://%s:%d/api/queues/%s/%s" % (self.protocol, self.hostname, self.port, vhost, queue)
        auth = base64.b64encode("%s:%s" % (self.username, self.password))

        headers = {"Content-type" : "application/json",
                   "Authorization" : "Basic " + auth}

        try:
            response = requests.get(url, headers=headers)
        except requests.exceptions.ConnectionError as e:
            return e
        except:
            return "An Unknow Error Happend"
        else:
           statusJson = json.loads(response.text)
           return statusJson

def main():
    vhost = sys.argv[1]
    metric = sys.argv[2]
    queue = sys.argv[3]

    # 转换为ascii码
    if vhost == '/':
        vhost = '%2F'

    rabbitmq = RabbitMQ(conf.get('config', 'username'), conf.get('config', 'password'), conf.get('config', 'hostname'),conf.getint('config', 'port'), conf.get('config', 'protocol'))
    statusJson = rabbitmq.getQueueStatus(vhost, queue)


    if 'error' not in statusJson:
        items = ['consumers', 'memory', 'messages', 'messages_ready', 'messages_unacknowledged']
        if metric in items:
            if metric == 'consumers':
                print(statusJson['consumers'])
            elif metric == 'memory':
                print(statusJson['memory'])
            elif metric == 'messages':
                print(statusJson['messages'])
            elif metric == 'messages_ready':
                print(statusJson['messages_ready'])
            elif metric == 'messages_unacknowledged':
                print(statusJson['messages_unacknowledged'])
        else:
            print('Incorrect parameters')
    else:
        print('No such queue')


if __name__ == '__main__':
    main()

