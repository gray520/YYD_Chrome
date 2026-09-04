#!/bin/bash
# variable declaration here 

# Add permission to executable binary

cd /usr/local/factory/uniformity/IVO_PID_B429/
chmod 777 MT_Tool_i2chid_intel_v001
chmod 777 MT_Test_v5222_intel

# [MT_Tool]
# -e <Executable_Binary> ex: MT_Test_v5222_intel
# -f <FWID_Mapping_File> ex: fwid_mapping.txt
# -a <hw_version attribute path> ex: /sys/bus/i2c/devices/1-0010/hw_version
# -p <Parameter Setting> ex: -i 5 -r 0 -l /tmp 
# -d (Enable Debug)
echo "Running MT_Tool..."
./MT_Tool_i2chid_intel_v001 -e MT_Test_v5222_intel -f fwid_mapping.txt -p "-i 4"
#./MT_Tool_i2chid_intel_v001 -e MT_Test_v5222_intel -f fwid_mapping.txt -p "-i 4 -r 0"

if [ ! -f ProductionTestData.csv ] ; then
  echo "****************did not have log****************"
  exit 1
fi
grep -i "Result = PASS" ProductionTestData.csv
if [ $? == 0 ]; then
  exit 0
fi
echo "***********ST5 Test Fail****************"
sleep 3
exit 1
