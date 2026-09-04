#!/bin/bash

hp_num=`vpd -i RO_VPD -g "mlb_serial_number" | cut -c 1-3`

if [ "${hp_num}" == "LMK" ]; then
  factory device-data vpd.ro.dlm_sku_id=19124
fi

if [ "${hp_num}" == "LML" ]; then
  factory device-data vpd.ro.dlm_sku_id=19125
fi

if [ "${hp_num}" == "LMM" ]; then
  factory device-data vpd.ro.dlm_sku_id=19126
fi

if [ "${hp_num}" == "LMN" ]; then
  factory device-data vpd.ro.dlm_sku_id=19127
fi

if [ "${hp_num}" == "LMO" ]; then
  factory device-data vpd.ro.dlm_sku_id=19128
fi

if [ "${hp_num}" == "LFH" ]; then
  factory device-data vpd.ro.dlm_sku_id=19009
fi

if [ "${hp_num}" == "LMF" ]; then
  factory device-data vpd.ro.dlm_sku_id=19010
fi

if [ "${hp_num}" == "LII" ]; then
  factory device-data vpd.ro.dlm_sku_id=19011
fi

if [ "${hp_num}" == "LMG" ]; then
  factory device-data vpd.ro.dlm_sku_id=19012
fi

if [ "${hp_num}" == "LMH" ]; then
  factory device-data vpd.ro.dlm_sku_id=19013
fi

if [ "${hp_num}" == "LMI" ]; then
  factory device-data vpd.ro.dlm_sku_id=19122
fi

if [ "${hp_num}" == "LMJ" ]; then
  factory device-data vpd.ro.dlm_sku_id=19123
fi
