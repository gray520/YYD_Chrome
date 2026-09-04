#!/bin/bash 

echo "*************Wait Device Ready****************"
sleep 10

cat /proc/cpuinfo | grep -i "model name" |grep -i N355
if [ $? == 0 ];then
  factory device-data component.has_mother_board_usb_c=2
  factory device-data component.sku=0x7fffffff
  factory device-data fw_config=0xe00000016
  factory device-data component.cpu_n355=true
  factory device-data factory.onboard_wifi=false
  ectool cbi set 2 0x7fffffff 4
  ectool cbi set 6 0xe0000016 4
  exit 0
fi


factory device-data component.has_mother_board_usb_c=1
factory device-data component.sku=0x7fffffff
factory device-data fw_config=0xe0000000 
factory device-data component.cpu_n355=false
factory device-data factory.onboard_wifi=false
ectool cbi set 2 0x7fffffff 4
ectool cbi set 6 0xe0000000 4
exit 0
