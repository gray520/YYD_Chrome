BTI Tool for Chromebook ======================
Copyright by G2Touch, 2019 ~

Usage :
    1. Copy the package into target system
    2. Extract archived package
        "tar -zxvf <package name>"
    3. Change directory & Execute program
       Execute shell script execution file (*.sh)
       If the reference file is located on another folde, just use '-file' option.
         ex) ./inspect/boe/g2touch/bti -file=./inspect/boe/g2touch/bti/BTI-BOE-Reference.bref
       In general, No need to specify reference file name when the folder has only 1 reference file.

Target :
    Test target device is touch screen panel with G2Touch IC
    If the system does not have target device, use proper package for.

How to make factory log file (/var/log/factory.log)
   1. copy bti execution files, script files and reference file in same folder
   2. excute bti_XXX.sh file
      For log level 1 & 2, just move the script file into same folder with execution file
      - bti.sh => Basic log (No log)
      - bti_append_system_log.sh => log level 0
      - bti_log_level1.sh => log level 1
      - bti_log_level2.sh => log level 2

Return values :
    0 : SUCCESS
    1 : FAIL
    others : system defined error codes
	(For 0 return code when NO G2touch device, use '-no_g2device_return0' option)

Comment :
    Result files and log file(*.csv) will be created in log folder.
    This document can be updated without notification.
