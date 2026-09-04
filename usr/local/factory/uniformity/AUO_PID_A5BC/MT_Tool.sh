#!/bin/bash
# variable declaration here 
/usr/local/factory/uniformity/AUO_PID_A5BC
chmod 777 MT_Test_v271209_intel
chmod 777 MT_Tool.sh
chmod 777 Export_MT_Log_V1.sh

mt_result=0

echo "--------------------------------------"
# [MT_Test]
# -f <Config File> ex: Default.dat
# -m <MT_Number> ex: 5, or 6
# -i <Interface> ex: 1: HID, 2: HID_LINUX, 3: I2C, 4: I2C-HID Chrome, 5:I2C Chrome, 6: Elan I2C-HID, 9: SPI
# -d <Driver Interface> ex: 0: IOCTL, 1: sysfs
# -b <I2C bus ID>
# -a <Attribute Mode> ex: 0: (Reset Read, IRQ Read), 1: (Reset Read, IRQ Write),2: (Reset Write, IRQ Read), 3: (Reset Write, IRQ Write)
# -l <Log Direcotry Path> ex: /data/local/tmp
# -r <Result Mode> ex: 0: ASCII(Default), 1: Simple String, 2: ASCII & Simple String
# -P <PID Info> ex:1FFF

echo "Running MT_Test..."
./MT_Test_v271209_intel -f Default.dat -m 6 -i 4 -r 2

./Export_MT_Log_V1.sh

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
