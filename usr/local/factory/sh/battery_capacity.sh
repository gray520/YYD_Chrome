#!/bin/bash 

battery_current=`ectool chargestate show| grep -i batt_state_of_charge |cut -d "=" -f2|cut -d "%" -f1`
echo "*********Current battery capacity is ${battery_current}*****************"

while true
do
  battery_current=`ectool chargestate show| grep -i batt_state_of_charge |cut -d "=" -f2|cut -d "%" -f1`
  if [ ${battery_current} -gt 89 ];then 
    echo "************Battery Capacity is ${battery_current} now, need to discharge************"
    echo "************Target Capacity is 88 ****************************************"
    sleep 5
  fi
  if [ ${battery_current} -lt 89 ];then 
    echo "***********battery capacity is lower than 90% ***********"
    sleep 3
    exit 0
  fi
done
