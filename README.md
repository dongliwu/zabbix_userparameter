# zabbix_userparameter
### 磁盘监控

所需依赖:

```bash
# CentOS
sudo yum install -y sysstat
sudo yum install -y smartmontools

# Ubuntu
sudo apt-get install -y sysstat
sudo apt-get install -y smartmontools
```

配置:

```bash
UserParameter=disk.discovery,/usr/local/zabbix_userparameter/scripts/disk_discover.py
UserParameter=disk.update,/usr/local/zabbix_userparameter/scripts/disk_status_update.sh
UserParameter=disk.status[*],/usr/local/zabbix_userparameter/scripts/disk_status.sh $1 $2
UserParameter=disk.smart[*],/usr/local/zabbix_userparameter/scripts/disk_smart.sh $1
```

键值:

```bash
# 磁盘自动发现
disk.discovery

# 磁盘状态更新
disk.update

# 磁盘状态获取
disk.status[{#DISK_NAME}, <ITEM>]
# {#DISK_NAME} 为自动发现的磁盘名, 无需更改
# ITEM 可选值: "readps", "writeps", "readBSec", "writeBSec", "writeBSec", "queue", "readAwait", "writeAwait", "svctm", "util"

# 硬盘smart状态
disk.smart[#DISK_NAME}]
# {#DISK_NAME} 为自动发现的磁盘名, 无需更改
```

执行权限:

```bash
# 要zabbix_agent能够运行上面的脚本，需要zabbix用户有sudo的NOPASSWD权限
echo "zabbix    ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers
```

模板:

[zbx_disk_io_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_disk_io_template.xml)



### RAID磁盘监控

所需依赖

```bash
# CentOS
wget https://raw.githubusercontent.com/crazy-zhangcong/tools/master/MegaCli8.07.10.tar.gz
tar zxvf MegaCli8.07.10.tar.gz
cd MegaCli8.07.10/Linux/
rpm -ivh Lib_Utils-1.00-09.noarch.rpm
rpm -ivh MegaCli-8.02.21-1.noarch.rpm
ln -s /opt/MegaRAID/MegaCli/MegaCli64 /usr/local/bin/MegaCli
```
```bash
# Ubuntu
apt-get -y install  rpm2cpio libsysfs2 libsysfs-dev unzip
cd /lib/x86_64-linux-gnu/
ln -s libsysfs.so.2.0.1 libsysfs.so.2.0.2
wget https://raw.githubusercontent.com/crazy-zhangcong/tools/master/MegaCli8.07.10.tar.gz
tar zxvf MegaCli8.07.10.tar.gz
cd MegaCli8.07.10/Linux/
rpm2cpio Lib_Utils-1.00-09.noarch.rpm | cpio -idmv
rpm2cpio MegaCli-8.02.21-1.noarch.rpm | cpio -idmv
mv opt/* /opt
ln -s /opt/MegaRAID/MegaCli/MegaCli64 /usr/local/bin/MegaCli
```

配置:

```bash
UserParameter=raid.vol.discovery,/usr/local/zabbix_userparameter/scripts/raid_vol_discovery.py
UserParameter=raid.vol[*],/usr/local/zabbix_userparameter/scripts/raid_vol.sh $1 $2
UserParameter=raid.disk.discovery,/usr/local/zabbix_userparameter/scripts/raid_disk_discovery.py
UserParameter=raid.disk[*],/usr/local/zabbix_userparameter/scripts/raid_disk.sh $1 $2
```

键值:

```bash
# 逻辑卷自动发现
raid.vol.discovery

# 逻辑卷状态
raid.vol[{#RAID_VOLUM}, <ITEM>]
# {#RAID_VOLUM} 为自动发现的raid逻辑卷, 无需更改
# ITEM 可选值: "state"

# 物理磁盘自动发现
raid.disk.discovery

# 物理磁盘状态
raid.disk[#RAID_DISK}, <ITEM>]
# {#RAID_DISK} 为自动发现的物理磁盘, 无需更改
# ITEM 可选值: "errors-media","errors-other","predictive-failures","predictive-failures","drive-temp","smart-error-flag"
```

执行权限:

```bash
# 要zabbix_agent能够运行上面的脚本，需要zabbix用户有sudo的NOPASSWD权限
echo "zabbix    ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers
```

模板:

[zbx_raid_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_raid_template.xml)



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

RabbitMQ监控脚本的逻辑与思想来自以下两位的代码:

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
# ITEM 可选值: "rabbitmq_version", "erlang_version", "message_stats_deliver_get", "message_stats_publish", "message_stats_ack"
```

模板:

[zbx_rabbitmq_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_rabbitmq_template.xml)

连接账户配置:

```bash
# 在scripts目录中的rabbitmq.cong文件中修改rabbitmq的连接信息
[config]
hostname = localhost
username = guest
password = guest
port = 15672
protocol = http
```

执行权限:

```bash
# 要zabbix_agent能够运行上面的脚本，需要zabbix用户有sudo的NOPASSWD权限
echo "zabbix    ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers
```



### Apache httpd监控

加载mod_status模块:

```bash
# 在httpd配置文件中导入模块
LoadModule status_module modules/mod_status.so
```

开启server-status:

```bash
# 在httpd中的默认虚拟主机中添加如下内容
<IfModule mod_status.c>
	<Location /server-status>
		SetHandler server-status
		# 允许指定主机访问
		Require local
	</Location>
    # 扩展显示，可显示更详尽内容，开启会降低性能
	ExtendedStatus On

    # 开启代理的状态
	<IfModule mod_proxy.c>
		ProxyStatus On
	</IfModule>
</IfModule>
```

重启服务:

```bash
sudo apachectl -t
sudo systemctl restart httpd 
```

配置:

```bash
# Apache httpd
UserParameter=httpd.status[*],/usr/local/zabbix_userparameter/scripts/httpd_status.sh $1 $2
```

键值:

```bash
# 更新status文件
httpd.status[update,]

# 获取status值
httpd.status[get,<ITEM>]
# ITEM 可选值: "TotalAccesses", "TotalKBytes", "CPULoad", "Uptime", "ReqPerSec", "BytesPerSec", "BytesPerReq", "BusyWorkers", "IdleWorkers", "WaitingForConnection", "StartingUp", "ReadingRequest", "SendingReply", "KeepAlive", "DNSLookup", "ClosingConnection", "Logging", "GracefullyFinishing", "IdleCleanupOfWorker", "OpenSlotWithNoCurrentProcess"
```

模板:

[zbx_httpd_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_httpd_template.xml)

