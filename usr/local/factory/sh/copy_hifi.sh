#!/bin/bash

hifi=`cat /proc/cmdline | grep "rw" | wc -l`
if [ "${hifi}" == "1" ];then
  echo "**************didn't need to copy hifi conf ************************"
fi
cp /usr/local/factory/sh/hifi_conf/* /usr/share/alsa/ucm/ -rf
sync
sleep 10
restart cras

