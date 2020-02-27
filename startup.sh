#!/bin/bash

/usr/sbin/cron -f | service rsyslog restart 
cd /root
nohup mongod --bind_ip_all &

