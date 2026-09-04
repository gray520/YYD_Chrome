#!/bin/bash

# 使用方式說明：
# $1：CSV 檔案名稱，例如 target.csv
# $2：要讀取的最後幾筆資料數量，例如 600
# $3：要檢查的欄位編號，例如 35（AI欄）
# $4：下限值，例如 10
# $5：上限值，例如 100

# 參數指定
csv_file="$1"
last_n="$2"
column_index="$3"
lower_limit="$4"
upper_limit="$5"

# 檢查參數是否足夠
if [ $# -ne 5 ]; then
    echo "Usage: $0 <csv_file> <last_n_rows> <column_index> <lower_limit> <upper_limit>"
    exit 1
fi

# 執行檢查
tail -n "$last_n" "$csv_file" | awk -F',' -v col="$column_index" -v low="$lower_limit" -v high="$upper_limit" '
{
    value = $col;
    # 判斷是否在範圍內
    if (value >= low && value <= high) {
        print "Pass";
    } else {
        print "Not in range: value = " value;
    }
}
END {
    print "Check completed.";
}'
