#!/bin/bash

echo "******************************************************"
echo "************* Detect Phiyo Device*********************"
echo "******************************************************"
cd /usr/local/factory/sh/phiyo2
while true
do
  echo "************* No Phiyo Device, Please Insert *********************"
  #ectool usbpdmuxinfo | grep -i "Port 0: USB=1"
  sleep 2
  ls /dev/ttyACM1
  if [ $? == 0 ]; then
    break
  fi
done

python3.8 main.pyc -s tbt01Settings -r
grep -i "pass" ./testparser/result/TBT01Result.txt
if [ $? == 0 ]; then
  echo "************* Phiyo Test Passed *********************"
  exit 0
fi
echo "************* Phiyo Test Failed *********************"
cat ./testparser/log/*/Debug*.log | grep -i "ERROR Port" > ./testparser/phiyo_fail.log
exit 1
