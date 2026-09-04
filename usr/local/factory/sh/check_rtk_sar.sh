#!/bin/bash 

sn=`vpd -i RO_VPD -g serial_number`
lshw |grep -i wireless|grep -i intel
if [ $? == 0 ]; then 
  echo "**** this is intel wireless, need not to check rtk sar ****"
  sleep 2
  exit 0
fi

lspci |grep -i "Network Controller"|grep -i intel
if [ $? == 0 ]; then 
  echo "**** this is intel wireless, need not to check rtk sar ****"
  sleep 2
  exit 0
fi

echo "*****For Test non-tablet-mode-power-table-rtw******"
  cd /run/chromeos-config/v1/wifi/non-tablet-mode-power-table-rtw
  cat limit-2g |grep 78
  if [ $? != 0 ]; then
    echo "******************non-tablet-mode-power-table-rtw limit-2g sar test failed **********"
    sleep 3
    exit 1
  fi
  
  cat limit-5g-1 |grep 76
  if [ $? != 0 ]; then
    echo "******************non-tablet-mode-power-table-rtw limit-5g-1 sar test failed **********"
    sleep 3
    exit 1
  fi
  
  cat limit-5g-3 |grep 76
  if [ $? != 0 ]; then
    echo "******************non-tablet-mode-power-table-rtw limit-5g-3 sar test failed **********"
    sleep 3
    exit 1
  fi

  cat limit-5g-4 |grep 76
  if [ $? != 0 ]; then
    echo "******************non-tablet-mode-power-table-rtw limit-5g-4 sar test failed **********"
    sleep 3
    exit 1
  fi

echo "*****For Test tablet-mode-power-table-rtw******"
  cd /run/chromeos-config/v1/wifi/tablet-mode-power-table-rtw
  cat limit-2g |grep 64
  if [ $? != 0 ]; then
    echo "******************non-tablet-mode-power-table-rtw limit-2g sar test failed **********"
    sleep 3
    exit 1
  fi
  
  cat limit-5g-1 |grep 54
  if [ $? != 0 ]; then
    echo "******************non-tablet-mode-power-table-rtw limit-5g-1 sar test failed **********"
    sleep 3
    exit 1
  fi
  
  cat limit-5g-3 |grep 54
  if [ $? != 0 ]; then
    echo "******************non-tablet-mode-power-table-rtw limit-5g-3 sar test failed **********"
    sleep 3
    exit 1
  fi

  cat limit-5g-4 |grep 54
  if [ $? != 0 ]; then
    echo "******************non-tablet-mode-power-table-rtw limit-5g-4 sar test failed **********"
    sleep 3
    exit 1
  fi

echo "*****For Test geo-offsets-fcc******"
cd /run/chromeos-config/v1/wifi/geo-offsets-fcc
cat offset-2g |grep 0
if [ $? != 0 ]; then
  echo "******************geo-offsets-fcc offset-2g sar test failed **********"
  sleep 3
  exit 1
fi

cat offset-5g |grep 0
if [ $? != 0 ]; then
  echo "******************geo-offsets-fcc offset-5g sar test failed **********"
  sleep 3
  exit 1
fi

echo "*****For Test geo-offsets-eu******"
cd /run/chromeos-config/v1/wifi/geo-offsets-eu
cat offset-2g |grep 0
if [ $? != 0 ]; then
  echo "******************geo-offsets-eu offset-2g sar test failed **********"
  sleep 3
  exit 1
fi

cat offset-5g |grep 18
if [ $? != 0 ]; then
  echo "******************geo-offsets-eu offset-5g sar test failed **********"
  sleep 3
  exit 1
fi

echo "*****For Test geo-offsets-world******"
cd /run/chromeos-config/v1/wifi/geo-offsets-rest-of-world
cat offset-2g |grep 0
if [ $? != 0 ]; then
  echo "******************geo-offsets-world offset-2g sar test failed **********"
  sleep 3
  exit 1
fi

cat offset-5g |grep 18
if [ $? != 0 ]; then
  echo "******************geo-offsets-world offset-5g sar test failed **********"
  sleep 3
  exit 1
fi

echo "***************************ALL Test Passed***********************************"
cp /usr/local/factory/sh/rtk_sar_data.txt /var/factory/testlog/attachments/${sn}_rtk_sar_data.txt -rf
sync
sleep 1
exit 0
