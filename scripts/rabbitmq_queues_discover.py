#!/usr/bin/python
#coding:utf-8

import ConfigParser
import requests
import json
import base64
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

    def queueDiscover(self):
        '''队列自动发现'''
        url = "%s://%s:%d/api/queues" % (self.protocol, self.hostname, self.port)
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
            return response


def main():
    rabbitmq = RabbitMQ(conf.get('config', 'username'), conf.get('config', 'password'),
                        conf.get('config', 'hostname'),conf.getint('config', 'port'), conf.get('config', 'protocol'))
    response = rabbitmq.queueDiscover()
    responseList = json.loads(response.text)

    queueList = []
    for item in responseList:
        queueList.append(item)

    queues = [ {'{#NODE_NAME}':queue['node'],'{#VHOST_NAME}':queue['vhost'],'{#QUEUE_NAME}':queue['name']} for queue in queueList ]
    print(json.dumps({'data':queues},indent=4,separators=(',',':')))


if __name__ == '__main__':
    main()
