#!/bin/bash 

cd /usr/local/factory/sh/dbts_fw
python /usr/local/factory/py/test/pytests/edid-reader.py > read_edid.tbl
PID=`grep -ri "PID" read_edid.tbl | cut -d ":" -f 2`
echo "This PID is : ${PID}"
if [ "${PID}" == "0DC5" ]; then
  bash /usr/local/factory/sh/dbts_fw/i2chid_multi_sensor_iap.sh  > result.txt 
elif [ "${PID}" == "CEB6" ]; then
  bash /usr/local/factory/sh/dbts_fw/i2chid_multi_sensor_iap.sh  > result.txt 
elif [ "${PID}" == "149A" ]; then
  bash /usr/local/factory/sh/dbts_fw/i2chid_multi_sensor_iap.sh  > result.txt
else
  echo "******************************************************************"
  echo " Need Not Upgrade DBTS FW"
  echo "******************************************************************"
  sleep 2
  exit 0
fi

grep -nri "Re-Calibration success" result.txt
if [ $? != 0 ]; then
  echo "******************************************************************"
  echo " DBTS FW Update Fail"
  echo "******************************************************************"
  sleep 10
  exit 1
fi
echo "******************************************************************"
echo " DBTS FW Update Pass"
echo "******************************************************************"
sleep 2
exit 0
