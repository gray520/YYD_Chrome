#!/bin/bash

cd /usr/local/factory/uniformity/LGD_PID_0802
sudo ./LXS_PanelTest_Tool_x64_20261029 --all > lgd_test.log
grep -i "TEST RESULT : PASS" lgd_test.log
if [ $? == 0 ]; then
  cat lgd_test.log
  echo "******************* LGD Test Passed *************"
  sleep 5
  exit 0
fi
cat lgd_test.log
echo "******************* LGD Test Failed *************"
sleep 5
exit 1

