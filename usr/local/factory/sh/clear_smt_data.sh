#!/bin/sh


#This code for clear teemo device data

factory device-data -d factory
vpd -i RW_VPD -d factory.start_SMT
vpd -i RW_VPD -d factory.end_SMT
rm -rf /var/log
sleep 2
rm -rf /var/factory
sleep 2
shutdown -h now
