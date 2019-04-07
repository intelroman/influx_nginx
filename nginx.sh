#!/bin/bash

influx_ip="123.123.123.123"
influx_user="user"
influx_pass="pass"
influx_db="stats"


data=`curl http://127.0.0.1/nginx_status -s | tr '\n' ' ' | awk '{print $3" "$8" "$9" "$10" "$12" "$14" "$16}'`
host=`hostname`
t=($(date +%s%N))
IFS=' ' read -r -a data_array <<< "$data"
feed="nginx,host=$host active_conn=${data_array[0]},accepted=${data_array[1]},handled=${data_array[2]},no_handles_requests=${data_array[3]},reading=${data_array[4]},writing=${data_array[5]},waiting=${data_array[5]} $t"

eval curl -u $influx_user:$influx_pass -i -XPOST 'http://$influx_ip:8086/write?db=$influx_db' --data-binary \' $feed \'

