#!/bin/bash

scan_sn=`factory device-data -g component.serial_number`
echo ${scan_sn}

dut_sn=`factory device-data -g serials.serial_number`
echo ${dut_sn}

#scan_mlb_sn=`factory device-data -g  component.mlb_serial_number`
#echo ${scan_mlb_sn}
#
#dut_mlb_sn=`factory device-data -g serials.mlb_serial_number`
#echo ${dut_mlb_sn}

scan_prodid=`factory device-data -g component.fa_prodid`
echo ${scan_prodid}

dut_prodid=`factory device-data -g component.ProID`
echo ${dut_prodid}

#scan_model=`factory device-data -g component.fa_model`
#echo ${scan_model}
#
#dut_model=`factory device-data -g component.Model`
#echo ${dut_model}

if [ "${scan_sn}" != "${dut_sn}" ]; then
  echo " ****************** Scan SN is diffirent from DUT SN *********"
  sleep 10
  exit 1
fi 

#if [ "${scan_mlb_sn}" != "${dut_mlb_sn}" ]; then
#  echo " ****************** Scan MLB SN is diffirent from DUT MLB SN *********"
#  sleep 10
#  exit 1
#fi 

if [ "${scan_prodid}" != "${dut_prodid}" ]; then
  echo " ****************** Scan ProdID is diffirent from DUT ProdID *********"
  sleep 10
  exit 1
fi 

#if [ "${scan_model}" != "${dut_model}" ]; then
#  echo " ****************** Scan model is diffirent from DUT Model *********"
#  sleep 10
#  exit 1
#fi 

exit 0
