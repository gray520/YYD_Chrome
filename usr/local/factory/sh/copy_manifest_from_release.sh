
#! /bin/bash 

# If the storage is emmc format, mount mmc
ls /dev/mmcb*
if [ $? ==  0 ]; then
    toybox mount -o ro,loop /dev/mmcblk0*5 /mnt
fi

# If the storage is NVME format, mount nvme
ls /dev/nvme*
if [ $? ==  0 ]; then
    toybox mount -o ro,loop /dev/nvme0*5 /mnt
fi

ls /dev/sda
if [ $? ==  0 ]; then
    toybox mount -o ro,loop /dev/sda5 /mnt
fi
sleep 2

cp /mnt/usr/share/cme/kaladin/component_manifest.json /usr/local/factory/sh/ -rf

sync

sleep 2

umount /mnt
