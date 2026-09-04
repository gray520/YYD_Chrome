#!/bin/bash

# Copyright notes and description
# ======================================================
# Copyright (C) 2025 Inventec Corp.
# BU2 - Innovalues Department - chromebook software team.
#
# This DUT's script is created for filter-keywords log
# after using the debug_suspend.sh & debug_reboot.sh
# of a Chromebook device. It includes functions to read
# our's debug tag, re-filter some keywords in
# "/var/log/messages" & "/var/log/power_manager.LATEST"
#
# (*) usage:
# ./this-script-name.sh <action> <station>
#
# <action> can be either 'query' or 'display', default is 'display' mode
#          - query mode   : only filter-keywords to main.log
#          - display mode : filter-keywords and show main.log on display
# <station> - a string name for this test-station
# ======================================================

# ------ Global Parameter, Command, Nodes --- (Begin) ----------------
NAME_STAGE_PRE=Pre_Oper
NAME_STAGE_POST=Post_Oper

TAG='(IEC_DEBUG_TAG)'
PATH_LOG_FOLDER=/var/log/iec_debug

TEST_STATION_WARMREBOOT=warmreboot
TEST_STATION_COLDREBOOT=coldreboot
TEST_STATION_SUSPEND=suspend

ACTION_NAME_QUERY=query
ACTION_NAME_DISPLAY=display
# ------ Global Parameter, Command, Nodes --- (End) ------------------

function common_end_process(){
	local num_exit_code="$1"
	local msg_content="$2"

	echo -e "${msg_content}"
	exit "${num_exit_code}"
}

function common_record_dut_info(){
	local actions=$1
	local logs_path=$2

	echo -e "======================================================= " >> ${logs_path}
	echo "Board Revision: $(ectool cbi get 0 | grep binary | awk -F ': ' '{printf $2}')" >> ${logs_path}
	echo "MB SN: $(vpd -l | grep mlb_serial_number | awk -F '=' '{printf $2}')" >> ${logs_path}
	echo "Model: $(cat /run/chromeos-config/v1/name)" >> ${logs_path}
	echo "SKU ID: $(printf '0x%x' $(cat /run/chromeos-config/v1/identity/sku-id))" >> ${logs_path}
	echo "FW Config: $(ectool cbi get 6 | sed -n 1p | awk -F\( '{print $2}' | sed 's/)//g')" >> ${logs_path}
	echo "GBB Flags: $(cbmem -1 | grep 'GBB flags are' | awk '{print $NF}')" >> ${logs_path}
	echo "======================================================= " >> ${logs_path}
	echo "GSC RO: $(gsctool -a -f | grep -A 3 -i 'Current versions' | grep RO | awk '{print $2}')" >> ${logs_path}
	echo "GSC RW: $(gsctool -a -f | grep -A 3 -i 'Current versions' | grep RW | awk '{print $2}')" >> ${logs_path}
	echo "EC RO: $(ectool version | grep 'RO version:' | sed 's/RO version://g' | sed 's/ //g')" >> ${logs_path}
	echo "EC RW: $(ectool version | grep 'RW version:' | sed 's/RW version://g' | sed 's/ //g')" >> ${logs_path}
	echo "FW RO: $(crossystem | grep fwid | sed -n 2p | cut -d= -f2 | sed 's/ //g' | awk -F# '{print $1}')" >> ${logs_path}
	echo "FW RW: $(crossystem | grep fwid | sed -n 1p | cut -d= -f2 | sed 's/ //g' | awk -F# '{print $1}')" >> ${logs_path}
	echo "OS: $(grep RELEASE_DESCRIPTION /etc/lsb-release | awk -F= '{print $NF}')" >> ${logs_path}
	echo -e "======================================================= \n" >> ${logs_path}
}

function func_append_part_to_targetlogs(){
	local actions=$1
	local logs_path=$2
	local target_logs=$3
	local filter_keywords=$4

	local line_nums_begin=$(grep -n "${TAG}" "${target_logs}" | grep "${NAME_STAGE_PRE}" | awk -F: 'END{print $1}')
	local line_nums_end=$(grep -n "${TAG}" "${target_logs}" | grep "${NAME_STAGE_POST}" | awk -F: 'END{print $1}')

	echo -e "(*) filter keywords in ${target_logs}" >> ${logs_path}

	if [[ -z "${line_nums_begin}" || -z "${line_nums_end}" ]]; then
		# fallback: no TAG range found, grep whole file
		grep -iE "${filter_keywords}" "${target_logs}" >> ${logs_path}
	else
		sed -n "${line_nums_begin},${line_nums_end}p" "${target_logs}" | grep -iE "${filter_keywords}" >> ${logs_path}
	fi

	echo -e "======================================================= \n" >> ${logs_path}
}

function func_filter_logs(){
	local actions=$1
	local logs_path=$2
	local station_name=$3
	# ----- messages log -----
	local syslog_path=/var/log/messages
	local syslog_keywords="${TAG}|ERR kernel:|CRIT kernel:|ALERT kernel:|EMERG kernel:"

	# ----- power_manager log -----
	local powerdlog_path=/var/log/power_manager/powerd.LATEST
	local powerdlog_keywords="${TAG}"

	case ${station_name} in
		${TEST_STATION_SUSPEND})
			syslog_keywords="${syslog_keywords}|last active wakeup source|wake source: |Resume caused by IRQ"
			syslog_keywords="${syslog_keywords}|cut here|sleep for|Timekeeping suspended for"
			syslog_keywords="${syslog_keywords}|premature wake detected"
			syslog_keywords="${syslog_keywords}|Failed to start RT ucode|trm_hw_status"
			syslog_keywords="${syslog_keywords}|SLP_S[0-9]{0,2}|CPU did not enter PC[0-9]{0,2}"
			syslog_keywords="${syslog_keywords}|CPU did not enter S0i*"
			syslog_keywords="${syslog_keywords}|Aborted suspend|Suspend failure|Failed to suspend"
			syslog_keywords="${syslog_keywords}|Error writing to /sys/power/state|Device or resource busy"
			syslog_keywords="${syslog_keywords}|attempt power cycle|unable to enumerate USB device"
			syslog_keywords="${syslog_keywords}|ACPI Error|ACPI: EC: input buffer is not empty|ACPI: Unable to evaluate"
			syslog_keywords="${syslog_keywords}|failed to suspend device"
			syslog_keywords="${syslog_keywords}|firmware did not acknowledge|timeout waiting for"
			syslog_keywords="${syslog_keywords}|power domain suspend failed|clk_disable"
			syslog_keywords="${syslog_keywords}|Resume caused by non-IRQ wakeup|wakeup from suspend by"
			syslog_keywords="${syslog_keywords}|Failed suspend count|last_failed_dev"

			# ----- power_manager log -----
			powerdlog_keywords="${powerdlog_keywords}|had event_count|Suspend attempt|powerd_suspend returned [1-9]{1,3}"
			powerdlog_keywords="${powerdlog_keywords}|Finalizing suspend|Going to suspend-to-RAM state"
			powerdlog_keywords="${powerdlog_keywords}|Error writing to /sys/power/state|Suspend result: failure"
			powerdlog_keywords="${powerdlog_keywords}|Wakeup reason:"
			powerdlog_keywords="${powerdlog_keywords}|powerd_suspend: entering suspend|powerd_suspend: failed to suspend"

			func_append_part_to_targetlogs "${actions}" "${logs_path}" "${powerdlog_path}" "${powerdlog_keywords}"
		;;
		${TEST_STATION_WARMREBOOT} | ${TEST_STATION_COLDREBOOT})
			syslog_keywords="${syslog_keywords}|failed with error|not-via-powerd"
			syslog_keywords="${syslog_keywords}|reboot: Restarting system|shutdown -r"
			syslog_keywords="${syslog_keywords}|unexpected reboot|unexpected reset|EC reset"
			syslog_keywords="${syslog_keywords}|watchdog timeout|watchdog: CPU stuck|watchdog: BUG"
			syslog_keywords="${syslog_keywords}|Kernel panic|Oops|BUG:|general protection fault"
			syslog_keywords="${syslog_keywords}|firmware crash|crash_reporter|powerd: reboot"
			syslog_keywords="${syslog_keywords}|thermal shutdown|power fault|PMIC reset"
			syslog_keywords="${syslog_keywords}|not-via-powerd|failed with error"
		;;
		*)
			echo "No Such of Test Tag. Since there is no correct Test-Station NAME, maybe too many"
		;;
	esac

	func_append_part_to_targetlogs "${actions}" "${logs_path}" "${syslog_path}" "${syslog_keywords}"
}

function func_is_target_folder_exist(){
	local actions=$1
	local station_name=$2
	local str_search_keyword=iec_debug_${station_name}
	local exist_test_station_num=$(ls /var/log/ | grep ${str_search_keyword} | wc -l)
	local msg_ret=""

	if [ "${exist_test_station_num}" = "1" ]; then
		msg_ret=`echo $(ls /var/log/ | grep ${str_search_keyword}) | awk -F'iec_debug_' '{print $2}'`
	fi

	echo "$msg_ret"
}

function func_main_flow(){
	local actions=$1
	local station_name=$2
	local logs_path=""
	# ---------------------------------------------------------------------------
	# default is --> /var/log/status_for_iec_main_debug.log
	#
	# Once there is only one 'iec_debug_*' folder, it should run by IEC-RRT-Tool
	# Create a main_$station-name.log in /var/log/iec_debug* folder
	#
	# You also can select a $station-name name for record this log
	#
	# 1. no args: (station_name), only-one 'iec_debug_*' exist --> main_${station_name}.log
	# 2. args: (station_name), 'iec_debug_*' exist --> main_${station_name}.log
	# 3. no args: (station_name), multi 'iec_debug_*' exist --> status_for_iec_main_debug.log
	# 4. args: (station_name), 'iec_debug_*' NOT exist --> status_for_iec_main_debug.log
	# ---------------------------------------------------------------------------
	station_name=$(func_is_target_folder_exist "${actions}" "${station_name}")
	if [ "${station_name}" != "" ]; then
		logs_path=${PATH_LOG_FOLDER}_${station_name}/main_${station_name}.log
	else
		logs_path=/var/log/status_for_iec_main_debug.log
	fi

	# ----- 1. append first information to log ------
	echo "station_name: ${station_name}" > ${logs_path}

	# ----- 2. append dut-info & filter logs -----
	common_record_dut_info "${actions}" "${logs_path}" "${station_name}"
	func_filter_logs "${actions}" "${logs_path}" "${station_name}"

	# ----- 3. (default case) runtime debug, need to quickly discover issue on DUT -----
	if [ "${actions}" = "${ACTION_NAME_DISPLAY}" ]; then
		cat ${logs_path}
	fi
}

# ----- main -----------------------------------

# set arguments
if [ "$1" = "" ]; then
	# default action setting to display case
	param_1_action=${ACTION_NAME_DISPLAY}
else
	param_1_action="$1"
fi
param_2_station="$2"

func_main_flow "$param_1_action" "$param_2_station"
