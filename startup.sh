#!/bin/bash

nohup /usr/sbin/rstudio-server start &
nohup mongod --bind_ip_all &
/usr/sbin/cron -f | service rsyslog restart 
cd /root

