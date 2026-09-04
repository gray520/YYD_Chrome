#!/bin/bash

# Choose Multi-Sensor IAP Tool for Your Platform (intel/arm)
MULTI_SENSOR_IAP_CMD="./i2chid_multi_sensor_iap_v1_4_intel"


# Multi-Sensor IAP
# [Usage]
# i2chid_multi_sensor_iap -P ${HID_PID} -m ${mapping_file} -D ${firmware_directory} -d (debug)
# [Note]
# MUST have a default firmware named "elants_i2chid_default.bin" !!!
${MULTI_SENSOR_IAP_CMD} -m multi_sensor_fwid_mapping_table.txt -D firmware
#${MULTI_SENSOR_IAP_CMD} -m multi_sensor_fwid_mapping_table.txt -D firmware -d
#${MULTI_SENSOR_IAP_CMD} -P 2b4b -m multi_sensor_fwid_mapping_table.txt -D firmware
#${MULTI_SENSOR_IAP_CMD} -P 2b4b -m multi_sensor_fwid_mapping_table.txt -D firmware -d
