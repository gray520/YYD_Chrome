#!/bin/bash 

cd /sys/kernel/debug/pmc_core/
cnv_num=`cat /sys/kernel/debug/pmc_core/ltr_show | grep -i 'PMC0:CNV' | cut -d "P" -f 1`

echo ${cnv_num}
echo ${cnv_num} > /sys/kernel/debug/pmc_core/ltr_ignore
