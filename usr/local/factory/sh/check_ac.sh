#!/bin/bash 

while true
do 
sleep 3
ectool chargestate show | grep -i "ac = 1"
if [ $? == 0 ]; then
  exit 0
fi
echo ""
echo "     AAAAA           CCCCCCCCC   "
echo "   AAA   AAA         CCCCCCCCC   "
echo "   AAA   AAA         CCC         "
echo "   AAA   AAA         CCC         "
echo "   AAAAAAAAA         CCC         "
echo "   AAAAAAAAA         CCC         "
echo "   AAA   AAA         CCC         "
echo "   AAA   AAA         CCCCCCCCC   "
echo "   AAA   AAA         CCCCCCCCC   "
echo ""
done

