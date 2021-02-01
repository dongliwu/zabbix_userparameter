#!/usr/bin/python
#encoding=utf-8

import commands
import json
import sys

url_health = "http://127.0.0.1:9200/_cluster/health"
curl_code, curl_output = commands.getstatusoutput("curl -s " + url_health)

if curl_code != 0:
    sys.exit()

status = json.loads(curl_output)
parm = sys.argv[1]

itemlist = ["cluster_name","status","timed_out","number_of_nodes","number_of_data_nodes","active_primary_shards","active_shards","relocating_shards","initializing_shards","unassigned_shards","delayed_unassigned_shards","number_of_pending_tasks","number_of_in_flight_fetch","task_max_waiting_in_queue_millis","active_shards_percent_as_number"]

if parm not in itemlist:
    print("parm failed")
    sys.exit(1)
else:
    print(status[parm])
