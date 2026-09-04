#!/bin/bash

mlb_sn=`vpd -i RO_VPD -g mlb_serial_number`
sleep 1
factory device-data serials.mlb_serial_number=${mlb_sn}
