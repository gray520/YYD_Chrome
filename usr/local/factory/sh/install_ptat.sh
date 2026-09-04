#!/bin/bash
 
set -e  
 
echo "[1/7] Remounting /home as read-write..."

sudo mount -o remount, rw /home
 
echo "[2/7] Remounting /home with exec permission..."

sudo mount -o remount, exec /home
 
echo "[3/7] Copying installer to /home..."

cp /usr/local/factory/IntelPTATChromeInstaller.tar.gz /home
 
echo "[4/7] Extracting installer..."

tar -xvzf /home/IntelPTATChromeInstaller.tar.gz -C /home
 
echo "[5/7] Running PTAT installation script..."
cd /home/PTAT_ChromeSetup_Release
yes |sudo  ./InstallPTAT.sh -i
 
echo "[6/7] Installation complete."
 
echo "Done."

 
