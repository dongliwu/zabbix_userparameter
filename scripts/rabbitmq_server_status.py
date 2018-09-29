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

    def getServerStatus(self):
        '''获取服务状态信息'''
        url = "%s://%s:%d/api/overview" % (self.protocol, self.hostname, self.port)
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
    rabbitmq = RabbitMQ(conf.get('config', 'username'), conf.get('config', 'password'),
                        conf.get('config', 'hostname'),conf.getint('config', 'port'), conf.get('config', 'protocol'))
    statusJson = rabbitmq.getServerStatus()

    item = sys.argv[1]
    items = ['rabbitmq_version','erlang_version','message_stats_deliver_get','message_stats_publish','message_stats_ack','message_count_total','message_count_ready','message_count_unacknowledged']
    if item in items:
        if item == 'rabbitmq_version':
            print(rabbitmq.getServerStatus()['rabbitmq_version'])
        elif item == 'erlang_version':
            print(rabbitmq.getServerStatus()['erlang_version'])
        elif item == 'message_stats_deliver_get':
            print(rabbitmq.getServerStatus()['message_stats']['deliver_get_details']['rate'])
        elif item == 'message_stats_publish':
            print(rabbitmq.getServerStatus()['message_stats']['publish_details']['rate'])
        elif item == 'message_stats_ack':
            print(rabbitmq.getServerStatus()['message_stats']['ack_details']['rate'])
    else:
        print('Incorrect parameters')

    #print(json.dumps(statusJson,indent=4,separators=(',',':')))
    #print(json.dumps({'data':queues},indent=4,separators=(',',':')))


if __name__ == '__main__':
    main()

