#!/bin/bash

# 使用方式檢查
FILE="$1"

if [[ -z "$FILE" || ! -f "$FILE" ]]; then
    echo "Usage: $0 <target.txt>"
    exit 1
fi

# 模糊比對的多行 pattern（忽略空白）
PATTERN=(
'Name[[:space:]]*\(WTAS,[[:space:]]*Package[[:space:]]*\(0x02\)'
'\{'
'0x00000000'
'Package[[:space:]]*\(0x13\)'
'\{'
'0x00000007'
'0x01'
'0x00'
)

idx=0
found=0

while IFS= read -r line; do
    if [[ "$line" =~ ${PATTERN[$idx]} ]]; then
        ((idx++))
        if [[ $idx -eq ${#PATTERN[@]} ]]; then
            found=1
            break
        fi
    fi
done < "$FILE"

if [[ $found -eq 1 ]]; then
    echo "TAS Enabled                            " >> /var/factory/testlog/attachments/*_sar_data.txt
    echo "    Name (WTAS, Package (0x02)         " >> /var/factory/testlog/attachments/*_sar_data.txt
    echo "    {                                  " >> /var/factory/testlog/attachments/*_sar_data.txt  
    echo "        0x00000000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt   
    echo "        Package (0x13)                 " >> /var/factory/testlog/attachments/*_sar_data.txt   
    echo "        {                              " >> /var/factory/testlog/attachments/*_sar_data.txt
    echo "            0x00000007,                " >> /var/factory/testlog/attachments/*_sar_data.txt
    echo "            0x01,                      " >> /var/factory/testlog/attachments/*_sar_data.txt 
    echo "            0x00,                      " >> /var/factory/testlog/attachments/*_sar_data.txt
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt       
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt  
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt   
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt    
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt     
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt  
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt     
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt     
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt  
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt      
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt 
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt          
    echo "            0x0000,                    " >> /var/factory/testlog/attachments/*_sar_data.txt     
    echo "            0x0000                     " >> /var/factory/testlog/attachments/*_sar_data.txt  
    echo "        }                              " >> /var/factory/testlog/attachments/*_sar_data.txt
    echo "    })                                 " >> /var/factory/testlog/attachments/*_sar_data.txt       
    echo "************* Intel WiFi Sar Check Passed *****************"
    exit 0
else
    echo "TAS not Enabled"
    exit 1
fi
