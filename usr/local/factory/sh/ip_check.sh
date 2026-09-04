#!/bin/bash

#factory device-data -d factory.need_reset
dutip=$(ip -brief --json address show eth0 | jq -r ".[0].addr_info[0].local")
echo "DUT ip is ${dutip}"

if [[ ${dutip} == "null" ]];then
  #factory device-data factory.need_reset=true
  ectool gpioset en_usb_a0_vbus 0 | true 
  ectool gpioset sb-2 0 | true 
  sleep 3 
  ectool gpioset en_usb_a0_vbus 1 | true
  ectool gpioset sb-2 1 | true 
elif [ -z ${dutip} ];then
  #factory device-data factory.need_reset=true
  ectool gpioset en_usb_a0_vbus 0 | true 
  ectool gpioset sb-2 0 | true 
  sleep 3 
  ectool gpioset en_usb_a0_vbus 1 | true
  ectool gpioset sb-2 1 | true 
else
  #factory device-data factory.need_reset=false
  echo ok
fi
