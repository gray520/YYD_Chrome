#!/bin/bash 

python /usr/local/factory/py/test/pytests/edid-reader.py > read_edid.tbl
TCON_FW_Ver=`grep -ri "TCON FW Ver" read_edid.tbl | cut -d ":" -f 2`
factory device-data factory.TCON_FW_Ver="${TCON_FW_Ver}"
TOP_FW_Ver=`grep -ri "TOP FW Ver" read_edid.tbl | cut -d ":" -f 2`
factory device-data factory.TOP_FW_Ver="${TOP_FW_Ver}"
Supplier=`grep -ri "Supplier" read_edid.tbl | cut -d ":" -f 2`
echo ${Supplier}
PID=`grep -ri "PID" read_edid.tbl | cut -d ":" -f 2`
echo ${PID}

echo "****************** Start to Check EDID ********************************"
grep -i "${TCON_FW_Ver}${TOP_FW_Ver}" /usr/local/factory/sh/edid_ver/${Supplier}_${PID}*.txt
if [ $? == 0 ]; then
  echo "*************************** EDID Check Pass ****************************"
  sleep 2
  exit 0
fi 
echo "*************************** EDID Check Fail ****************************"
sleep 10
exit 1
