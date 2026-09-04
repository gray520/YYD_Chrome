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

BIOS=`crossystem fwid` # Get BIOS FW RW Version
EC_VER=`ectool version |grep -i 'RO version'| awk '{print $NF}'` # Get EC Version 
Google_Name=`cros_config / name` # Get Google Name
Test_image_Version=`cat /etc/lsb-release |grep -i CHROMEOS_RELEASE_VERSION|cut -d '=' -f 2` # Get Test Image Version 
Release_image_Version=`cat /mnt/etc/lsb-release |grep -i CHROMEOS_RELEASE_VERSION|cut -d '=' -f 2` # Get Release Image Version 


# Print all collection info 
factory device-data factory.EC_VER=${EC_VER}
factory device-data factory.Google_Name=${Google_Name}
factory device-data factory.Test_Image_Version=${Test_image_Version}
factory device-data factory.Release_Image_Version=${Release_image_Version}
umount /mnt
exit 0
