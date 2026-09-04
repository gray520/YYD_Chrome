#!/bin/bash

# ------------ parameter zone --------------
TIMES_CYCLE_Suspend=15
TIMES_IDLE_FOR_PREPARE_ENTER_Suspend=15

# ----- others record -----
path_log=/var/log/IEC_S3_QuicklySuspend.log

# default path: /usr/local/factory/extra_from_iec/install_in_tool_sh
path_extra_sh="$(dirname "$0")"  # relative path
# ------------------------------------------

echo " -------------------------------------- "
echo " DUT will run suspend stress after count-down: ${TIMES_IDLE_FOR_PREPARE_ENTER_Suspend} secs. "
echo " ... Don't touch after count-down ...   "
echo " -------------------------------------- "

# check the debug_suspend.sh is exist
if [[ ! -f "${path_extra_sh}/debug_suspend.sh" ]]; then
    echo "Error: ${path_extra_sh}/debug_suspend.sh not found!"
    exit 1
fi

count=${TIMES_IDLE_FOR_PREPARE_ENTER_Suspend}
for i in $(seq $count -1 1); do
    echo -en "\rTimeout in $i sec." >&2
    sleep 1
done
clear

# ----- run suspend_stress_test -----
suspend_stress_test --suspend_min=25 --suspend_max=30 --wake_min=25 --wake_max=30 \
--count=$TIMES_CYCLE_Suspend \
--pre_suspend_command "bash ${path_extra_sh}/debug_suspend.sh Pre_Oper suspend" \
--post_resume_command "bash ${path_extra_sh}/debug_suspend.sh Post_Oper suspend" \
 | tee ${path_log}
