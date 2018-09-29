# zabbix_userparameter
### 磁盘监控

所需依赖:

```bash
# CentOS
sudo yum install -y sysstat

# Ubuntu
sudo yum install -y sysstat
```

配置:

```bash
UserParameter=disk.discovery,/usr/local/zabbix_userparameter/scripts/disk_discover.py
UserParameter=disk.status[*],/usr/local/zabbix_userparameter/scripts/disk_status.sh $1 $2
```

键值:

```bash
# 磁盘自动发现
disk.discovery

# 磁盘状态
disk.status[{#DISK_NAME}, <ITEM>
# {#DISK_NAME} 为自动发现的磁盘名, 无需更改
# ITEM 可选值: "readps", "writeps", "readBSec", "writeBSec", "writeBSec", "queue", "readAwait", "writeAwait", "svctm", "util"
```

模板:

[zbx_disk_io_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_disk_io_template.xml)



### 进程内存监控

配置:

```bash
UserParameter=process.mem[*],/usr/local/zabbix_userparameter/scripts/process_mem.sh $1
```

键值:

```bash
process.mem[<FILTER>]
# FILTER 为进程名
```



### RabbitMQ监控

RabbitMQ监控脚本的逻辑与思想来自以下两位的代码，感谢:

https://github.com/jasonmcintosh/rabbitmq-zabbix

https://github.com/alfssobsd/zabbix-rabbitmq

所需依赖:

```bash
# 开启管理
sudo rabbitmq-plugins enable rabbitmq_management

# 安装requests库
sudo pip install requests
```

配置: 

```bash
# RabbitMQ
UserParameter=rabbitmq.queue.discovery,/usr/local/zabbix_userparameter/scripts/rabbitmq_queues_discover.py
UserParameter=rabbitmq.queue.status[*],/usr/local/zabbix_userparameter/scripts/rabbitmq_queues_status.sh $1 $2 $3 $4
UserParameter=rabbitmq.server.status[*],/usr/local/zabbix_userparameter/scripts/rabbitmq_server_status.py $1
```

键值:

```bash
# 自动发现
rabbitmq.queue.discovery

# 队列状态
rabbitmq.queue.status[{#NODE_NAME},{#VHOST_NAME},<METRIC>,{#QUEUE_NAME}]
# {#NODE_NAME} 为自动发现的node名，无需更改
# {#VHOST_NAME} 为自动发现的vhost名，无需更改
# {#QUEUE_NAME} 为自动发现的队列名，无需更改
# METRIC 可选值: "list_queues", "list_exchanges", "queue_durable", "queue_msg_ready", "queue_msg_unackd", "queue_msgs", "queue_consumers", "queue_memory", "exchange_durable", "exchange_type"

# 服务状态
rabbitmq.server.status[<ITEM>]
# ITEM 可选值: "rabbitmq_version", "erlang_version", "message_stats_deliver_get", "message_stats_publish", "message_stats_ack", "message_count_total", "message_count_ready", "message_count_unacknowledged"
```

模板:



注意:

```bash
# 在scripts目录中的rabbitmq.cong文件中修改rabbitmq的连接信息
[config]
hostname = localhost
username = guest
password = guest
port = 15672
protocol = http
```

