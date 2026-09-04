#!/bin/bash env

battery=`ectool --ascii i2cxfer 2 0x0b 15 0x70`
echo ${#battery}
battery_ct=${battery:4:18}
echo ${#battery_ct}
if [ "${#battery_ct}" != "14" ]; then
  echo "******************battery_ct is incorrect**********************"
  sleep 10
  exit 1
fi
factory device-data factory.battery_ct="${battery_ct}"
