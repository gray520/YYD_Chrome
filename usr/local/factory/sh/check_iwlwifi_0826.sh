#!/bin/bash

# Define the output file path
sn=`vpd -i RO_VPD -g serial_number`
output_file="iwlwifi_output.txt"

# Run dmesg and filter for iwlwifi, save the output to the file
dmesg | grep iwlwifi > "$output_file"

# Define the strings to check in the output
strings_to_check=(
    "Chain\[0\]:"
    "Band\[0\] = 136"
    "Band\[1\] = 120"
    "Band\[2\] = 120"
    "Band\[3\] = 120"
    "Band\[4\] = 120"
    "Band\[5\] = 108"
    "Band\[6\] = 108"
    "Band\[7\] = 108"
    "Band\[8\] = 108"
    "Band\[9\] = 108"
    "Band\[10\] = 108"
    "Chain\[1\]:"
    "SAR geographic profile\[0\] Band\[0\]: chain A = 0 chain B = 0 max_tx_power = 160"
    "SAR geographic profile\[0\] Band\[1\]: chain A = 0 chain B = 0 max_tx_power = 160"
    "SAR geographic profile\[0\] Band\[2\]: chain A = 0 chain B = 0 max_tx_power = 104"
    "SAR geographic profile\[1\] Band\[0\]: chain A = 0 chain B = 0 max_tx_power = 128"
    "SAR geographic profile\[1\] Band\[1\]: chain A = 12 chain B = 12 max_tx_power = 132"
    "SAR geographic profile\[1\] Band\[2\]: chain A = 0 chain B = 0 max_tx_power = 104"
    "SAR geographic profile\[2\] Band\[0\]: chain A = 0 chain B = 0 max_tx_power = 128"
    "SAR geographic profile\[2\] Band\[1\]: chain A = 12 chain B = 12 max_tx_power = 132"
    "SAR geographic profile\[2\] Band\[2\]: chain A = 0 chain B = 0 max_tx_power = 104"
    "SAR geographic profile\[3\] Band\[0\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[3\] Band\[1\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[3\] Band\[2\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[4\] Band\[0\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[4\] Band\[1\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[4\] Band\[2\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[5\] Band\[0\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[5\] Band\[1\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[5\] Band\[2\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[6\] Band\[0\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[6\] Band\[1\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[6\] Band\[2\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[7\] Band\[0\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[7\] Band\[1\]: chain A = 0 chain B = 0 max_tx_power = 0"
    "SAR geographic profile\[7\] Band\[2\]: chain A = 0 chain B = 0 max_tx_power = 0"
)

# Loop over the strings to check and verify if they exist in the output file
for string in "${strings_to_check[@]}"; do
    if ! grep -q "$string" "$output_file"; then
        echo "Missing string: $string"
        exit 1
    fi
done

echo "All required strings found in the dmesg output (saved to $output_file)."
cp ${output_file} /var/factory/testlog/attachments/${sn}_intel_sar_data.txt
cd /usr/local/factory/sh
cat /sys/firmware/acpi/tables/SSDT > ssdt.dat
iasl -d ssdt.dat
cat ssdt.dsl > ssdt.txt
bash /usr/local/factory/sh/check_wtas.sh ssdt.txt
exit 0
