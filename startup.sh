#!/bin/bash

/usr/sbin/cron -f | service rsyslog restart 
mongod --bind_ip_all
