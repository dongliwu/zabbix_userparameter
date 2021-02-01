# zabbix_userparameter
### 磁盘监控

所需依赖:

```bash
# CentOS
sudo yum install -y sysstat

# Ubuntu
sudo apt-get install -y sysstat
```

配置:

```bash
UserParameter=disk.discovery,/usr/local/zabbix_userparameter/scripts/disk_discover.py
UserParameter=disk.update,/usr/local/zabbix_userparameter/scripts/disk_status_update.sh
UserParameter=disk.status[*],/usr/local/zabbix_userparameter/scripts/disk_status.sh $1 $2
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
```

执行权限:

```bash
# 要zabbix_agent能够运行上面的脚本，需要zabbix用户有sudo的NOPASSWD权限
echo "zabbix    ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers
```

模板:

[zbx_disk_io_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_disk_io_template.xml)

###  SMART磁盘检测

所需依赖:

```bash
# CentOS
sudo yum install -y smartmontools

# Ubuntu
sudo apt-get install -y smartmontools
```

配置:

```bash
UserParameter=disk.smart.discovery,/usr/local/zabbix_userparameter/scripts/disk_discover.py
UserParameter=disk.smart[*],/usr/local/zabbix_userparameter/scripts/disk_smart.sh $1
```

键值:

```bash
# 磁盘自动发现
disk.smart.discovery

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

[zbx_disk_smart_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_disk_smart_template.xml)



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
UserParameter=rabbitmq.queue.status[*],/usr/local/zabbix_userparameter/scripts/rabbitmq_queues_status.py $1 $2 $3
UserParameter=rabbitmq.server.status[*],/usr/local/zabbix_userparameter/scripts/rabbitmq_server_status.py $1
```

键值:

```bash
# 自动发现
rabbitmq.queue.discovery

# 队列状态
rabbitmq.queue.status[{#VHOST_NAME},<METRIC>,{#QUEUE_NAME}]
# {#VHOST_NAME} 为自动发现的vhost名，无需更改
# {#QUEUE_NAME} 为自动发现的队列名，无需更改
# METRIC 可选值: 'consumers', 'memory', 'messages', 'messages_ready', 'messages_unacknowledged'

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
# 修改/etc/sudoer，增加sudo权限以及notty权限
Defaults:zabbix !requiretty
zabbix    ALL=(ALL)    NOPASSWD:ALL
```



### Apache httpd监控

httpd配置:

```bash
# 监听端口40000
Listen 127.0.0.1:40000
# 导入模块
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



### Redis

约束：

* zabbix部署目录为/usr/local/zabbix/ 

配置:

```bash
# 新增/usr/local/zabbix/.redis.cnf文件，录入redis登录信息
REDISCLI="/usr/local/ProgramData/redis-5.0.5/bin/redis-cli"
HOST="localhost"
PORT=6379
PASSWORD=""
```

```bash
# Redis
UserParameter=redis.status[*],/usr/local/zabbix_userparameter/scripts/redis_status.sh $1 $2
#UserParameter=redis.cluster.status[*],/usr/local/zabbix_userparameter/scripts/redis_cluster_status.sh $1
```

键值:

```bash
略
```

模板:

[zbx_redis_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_redis_template.xml)

[zbx_redis_cluster_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_redis_cluster_template.xml)



### Nginx

开启nginx_status:

```bash
    location /nginx_status {
       stub_status on;
       access_log off;
       allow 127.0.0.1;
       deny all;
    }
```

配置:

```bash
UserParameter=nginx.status[*],/usr/local/zabbix_userparameter/scripts/nginx_status.sh $1
```

键值:

```bash
nginx.status[<ITEM>]
# ITEM 可选值: 'ping', 'active', 'reading', 'writing', 'waiting', 'accepts', 'handled', 'requests'
```

模板:

[zbx_nginx_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_nginx_template.xml)



### TCP 

配置:

```bash
# TCP
UserParameter=tcp.status[*], /usr/local/zabbix_userparameter/scripts/tcp_status.sh $1
```

键值:

```bash
tcp.status[<ITEM>]
# ITEM 可选值: "CLOSE-WAIT", "CLOSED", "CLOSING", "ESTAB", "FIN-WAIT-1", "FIN-WAIT-2", "LAST-ACK", "LISTEN", "SYN-RECV", "SYN-SENT", "TIME-WAIT"
```

模板:

[zbx_tcp_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_tcp_template.xml)



### PHP-FPM

php-fpm配置:

```bash
# 在配置文件中添加获取状态的路径
pm.status_path = /php_status
ping.path = /ping
```

httpd配置:

```bash
# 在httpd中新增获取状态的虚拟主机
<VirtualHost 127.0.0.1:40000>
   <LocationMatch "/(php_status|ping)">
      SetHandler "proxy:fcgi://127.0.0.1:9000"
   </LocationMatch>
</VirtualHost>
```

配置:

```bash
# PHP-FPM
UserParameter=php.status[*],/usr/local/zabbix_userparameter/scripts/php_status.sh $1
```

键值:

```bash
php.status[<ITEM>]
# ITEM 可选值:ping, update，pool，process_manager，start_time，start_since，accepted_conn，listen_queue，max_listen_queue，listen_queue_len，idle_processes，active_processes，total_processes，max_active_processes，max_children_reached，slow_requests
```

模板: 

[zbx_php-fpm_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_php-fpm_template.xml)



###  JAVA

约束：

* jstat路径为/usr/local/java/bin/jstat

权限：

```bash
# 修改/etc/sudoer，增加sudo权限以及notty权限
Defaults:zabbix !requiretty
zabbix    ALL=(ALL)    NOPASSWD:ALL
```

配置：

```bash
# JAVA
UserParameter=java.discovery, /usr/local/zabbix_userparameter/scripts/java_discovery.py
UserParameter=java.status[*], /usr/local/zabbix_userparameter/scripts/java_status.sh $1 $2
```

键值：

```bash
java.discovery
# 自动发现
java.status[{#JAR_NAME},<ITEM>]
# {#JAR_NAME}为自动发现出的jar程序
# ITEM 可选值:S0C|S0U|S1C|S1U|EC|EU|OC|OU|MC|MU|CCSC|CCSU|YGC|YGCT|FGC|FGCT|GCT
```

模板：

[zbx_java_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_java_template.xml)



###  MySQL

约束：

* zabbix部署目录为/usr/local/zabbix/

授权：

```bash
# 在mysql中添加zabbix访问授权
grant all privileges on *.* to 'zabbix'@'localhost' identified by 'ZabbixPasswd5!';
flush privileges;
```
```bash
# 新增/usr/local/zabbix/.my.cnf文件，录入mysql登录信息
[mysql]
host=localhost
user=zabbix
password='ZabbixPasswd5!'

[mysqladmin]
host=localhost
user=zabbix
password='ZabbixPasswd5!'
```

配置：

```bash
# MySQL
UserParameter=mysql.status[*], /usr/local/zabbix_userparameter/scripts/mysql_status.sh $1
UserParameter=mysql.ping, /usr/local/zabbix_userparameter/scripts/mysql_status.sh ping
UserParameter=mysql.version, /usr/local/zabbix_userparameter/scripts/mysql_status.sh version

# MySQL Cluster
UserParameter=mysql.cluster[*],echo "show global status where Variable_name='$1';" | HOME=/usr/local/zabbix /bin/mysql -N | awk '{print $$2}'
UserParameter=mysql.cluster.ping,echo "show global status where Variable_name='wsrep_connected';" | HOME=/usr/local/zabbix /bin/mysql -N | grep -c on
```

模板：

[zbx_mysql_extension_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_mysql_extension_template.xml)

[zbx_mysql_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_mysql_cluster_template.xml)



### Elasticsearch

配置:

```bash
# Elasticsearch
UserParameter=elasticsearch.status[*], /usr/local/zabbix_userparameter/scripts/elasticsearch_status.py $1
```

模板:

[zbx_elasticsearch_template.xml](https://github.com/dongliwu/zabbix_userparameter/blob/master/templates/zbx_elasticsearch_template.xml)