#!/bin/bash

# 使用方式說明：
# $1：CSV 檔案名稱，例如 target.csv
# $2：要讀取的最後幾筆資料數量，例如 600
# $3：下限值，例如 10
# $4：上限值，例如 100

csv_file="$1"
last_n="$2"
lower_limit="$3"
upper_limit="$4"

if [ $# -ne 4 ]; then
    echo "Usage: $0 <csv_file> <last_n_rows> <lower_limit> <upper_limit>"
    exit 1
fi

# 取得欄位名稱列，並找出目標欄位的 index（從 1 開始）
target_column="Miscellaneous-MSR Package Temperature(Degree C)"
header=$(head -n 1 "$csv_file")
IFS=',' read -ra columns <<< "$header"

column_index=-1
for i in "${!columns[@]}"; do
    if [[ "${columns[$i]}" == "$target_column" ]]; then
        column_index=$((i + 1))
        break
    fi
done

if [ "$column_index" -eq -1 ]; then
    echo "cannot find:$target_column"
    exit 1
fi

# 執行檢查
tail -n "$last_n" "$csv_file" | head -n -5 | awk -F',' -v col="$column_index" -v low="$lower_limit" -v high="$upper_limit" '
{
    value = $col;
    if (value >= low && value <= high) {
        print "Pass";
    } else {
        print "Not in range: value = " value;
    }
}
END {
    print "Check completed.";
}'
