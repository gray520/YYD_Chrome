#!/bin/bash
# variable declaration here 
cd /usr/local/factory/uniformity/APST5_DBTS_4619_461A_4618_0DC5_149A_CEB6
# Add permission to executable binary
chmod 777 MT_Tool_i2chid_v007_intel
chmod 777 MT_Test_v5875_intel

# [MT_Tool]
# -e <Executable_Binary> ex: MT_Test_v5222_intel
# -f <FWID_Mapping_File> ex: fwid_mapping.txt
# -a <hw_version attribute path> ex: /sys/bus/i2c/devices/1-0010/hw_version
# -p <Parameter Setting> ex: -i 5 -r 0 -l /tmp 
# -d (Enable Debug)
# -P <PID Info> ex:1FFF

echo "Running MT_Tool..."
./MT_Tool_i2chid_v007_intel -f fwid_mapping.txt -p "-i 4 -r 2"
if [ ! -f ProductionTestData.csv ] ; then
  echo "****************did not have log****************"
  exit 1
fi
grep -i "Result = PASS" ProductionTestData.csv
if [ $? == 0 ]; then
  exit 0
fi
exit 1
