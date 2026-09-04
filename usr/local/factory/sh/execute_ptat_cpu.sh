#!/bin/bash
 
set -e

cd /usr/local/Intel/PTAT
 
echo "execute PTAT and stop after 30 minutes..."

./PTAT -m=log_cpu.csv -s=0702cpustress30min.json -t=1800
 
echo "Done." 
