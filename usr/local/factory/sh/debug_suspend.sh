#!/bin/bash

# Copyright notes and description
# ======================================================
# Copyright (C) 2025 Inventec Corp.
# BU2 - Innovalues Department - chromebook software team.
#
# This DUT's script is created for managing and recording
# debug logs during the suspend and resume operations
# of a Chromebook device. It includes functions to tag
# logs with timestamps, record various system statuses,
# and manage redundant log files.
#
# (*) usage:
# ./this-script-name.sh <action> <station>
#
# <action> can be either "Pre_Oper" or "Post_Oper"
# <station> - a string name for this test-station
# ======================================================

# ------ Global Parameter, Command, Nodes --- (Begin) ----------------
NAME_STAGE_PRE=Pre_Oper
NAME_STAGE_POST=Post_Oper
MAX_NUM_OF_REDUNDANT_LOG=5

DEFAULT_TEST_STATION=suspend

TAG='(IEC_DEBUG_TAG)'
PATH_LOG_FOLDER=/var/log/iec_debug

PATH_LOG_LAST_EC_GPIOGET=/var/log/status_of_ectool_gpioget.log
PATH_LOG_LAST_EC_PANICINFO=/var/log/status_of_ectool_panicinfo.log
PATH_LOG_LAST_LSUSB=/var/log/status_of_lsusb.log
PATH_LOG_LAST_WAKEUP_SOURCE=/var/log/status_of_wakeup_sources.log
# ------ Global Parameter, Command, Nodes --- (End) ------------------

function common_end_process(){
	local num_exit_code="$1"
	local msg_content="$2"

	echo -e "${msg_content}"
	exit "${num_exit_code}"
}

function common_remove_redundant_logs(){
	local actions=$1
	local target_folder_path=$2
	local files_amount=$(ls ${target_folder_path}/${actions}* | wc -l)

	if [ "${files_amount}" -gt "${MAX_NUM_OF_REDUNDANT_LOG}" ]; then
		find ${target_folder_path}/${actions}* -type f -printf '%T+ %p\n' | sort | head -n $((${files_amount} - ${MAX_NUM_OF_REDUNDANT_LOG})) | awk '{print $2}' | xargs rm -f
	fi
}

function common_time_tag(){
	local actions=$1
	local timestamp=$(date +'%Y%m%d_%H%M%S.%3N')
	local msg_ret=""
	local tmp_node=/tmp/tmp_node

	if [ "${actions}" = "${NAME_STAGE_PRE}" ]; then
		echo "${timestamp}" > ${tmp_node}
		msg_ret=${timestamp}
	else
		msg_ret="$(cat ${tmp_node})_to_${timestamp}"
	fi

	echo "${msg_ret}"
}

function common_record_dut_status_flow(){
	local actions=$1
	local logs_path=$2
	local timestamp=$3
	local station_name=$4

	# --------------------------------------------------------------------
	# 1st information apppend to ${logs_path}
	# --------------------------------------------------------------------
	echo -e "(*) Timestamp (during from ... to ...): ${timestamp}" > ${logs_path}
	echo -e "(*) station_name: ${station_name}" >> ${logs_path}

	# --------------------------------------------------------------------
	# 2. record ec-part (ectool temps all & ectool battery | grep -iE 'Remaining|Flags')
	# --------------------------------------------------------------------
	echo -e "\n\n(*) ectool temps all:\n$(ectool temps all)" >> ${logs_path}
	echo -e "\n\n(*) ectool battery | grep -iE 'Remaining|Flags':\n$(ectool battery | grep -iE 'Remaining|Flags')" >> ${logs_path}

	# --------------------------------------------------------------------
	# 3. record memory-status ($free), partition free-size(%), power_supply_info & eventlog-status (cat /var/log/eventlog.txt)
	# --------------------------------------------------------------------
	echo -e "\n\n(*) free:\n$(free)" >> ${logs_path}
	echo -e "\n\n(*) df -h | grep -E 'Filesystem|stateful_partition':\n$(df -h | grep -E 'Filesystem|stateful_partition')" >> ${logs_path}
	echo -e "\n\n(*) power_supply_info:\n$(power_supply_info | grep -iE 'state|display percentage')" >> ${logs_path}
	echo -e "\n\n(*) Query-eventlog-with-tail-n3:\n$(cat /var/log/eventlog.txt | tail -n 3)\n" >> ${logs_path}

	# --------------------------------------------------------------------
	# It will easy to debug via the same timestamp in differents /var/log/*.logs
	# Using for-loop to insert "TAG & timestamp" to /var/log/***.log
	# --------------------------------------------------------------------
	logger "${TAG}, ${actions}, ${timestamp}"

	local varlog_path=/var/log
	local varlog_files=("power_manager/powerd.LATEST" "cros_ec.log" "net.log" "bluetooth.log" "chrome/chrome" "factory.log")

	for varlog_files in "${varlog_files[@]}"; do
		echo "${TAG}, ${actions}, ${timestamp}" >> "${varlog_path}/${varlog_files}"
	done
}

function common_record_console_ramoops(){
	local actions=$1
	local logs_path=$2
	local timestamp=$3
	local count_ramoops_numbers=$(find /sys/fs/pstore -name console-ramoops-* | wc -l)

	echo -e "\n\n(*) console-ramoops: (after running cmd: 'reboot', it will cause console-ramoops)" >> ${logs_path}
	if [ ${count_ramoops_numbers} = "0" ]; then
		echo "<console-ramoops-content-is-empty>" >> ${logs_path}
	else
		echo -e "How many console-ramoops-* files: ${count_ramoops_numbers}, we will remove it after query this content...\n(cat /sys/fs/pstore/console-ramoops-0):" >> ${logs_path}
		cat /sys/fs/pstore/console-ramoops-0 >> ${logs_path}
		rm -f /sys/fs/pstore/console-ramoops-0
	fi
}

function common_diff_of_send_commands(){
	local actions=$1
	local logs_path=$2
	local station_command_name="$3"
	local command="$4"
	local logs_last_append="$5"
	local tmp_msg="$6"
	local tmp_node_name=/tmp/tmp_node_${station_command_name}

	# append $command to ${logs_last_append}
	${command} > ${logs_last_append}

	echo -e "\n\n(*) Diffs-between-${tmp_msg}, \nlast-output-file is in ${logs_last_append}" >> ${logs_path}
	if [ "$actions" = "${NAME_STAGE_PRE}" ]; then
		cp ${logs_last_append} ${tmp_node_name}
	else
		echo "$(diff ${logs_last_append} ${tmp_node_name})" >> ${logs_path}
	fi
}

function func_platform_special_debug_actions(){
	local actions=$1
	local logs_path=$2
	local timestamp=$3

	if [ "$(uname -m)" == "x86_64" ]; then
		# -----------------------------------------------------------------------------
		# this log is for x86 intel platform
		# when debug intel x86 suspend case, we need the pmc-core-value of package C0~C10
		# dump PMC-core for quickly compare before entry suspend & after suspend status
		# -----------------------------------------------------------------------------
		echo -e "\n\n(*) x86_64-debug/pmc_core:" >> ${logs_path}
		if [ -d /sys/kernel/debug/pmc_core ]; then
			NODE_QUERY=$(ls /sys/kernel/debug/pmc_core)
			for i in $NODE_QUERY; do
			   echo -e "\n(+) ${i}: $(cat /sys/kernel/debug/pmc_core/${i})" >> ${logs_path}
			done
		fi
	else
		# -----------------------------------------------------------------------------
		# reserved for ARM platform
		# -----------------------------------------------------------------------------
		echo "reserved, nothing to do so far."
	fi
}

function func_main_flow(){
	local actions=$1
	local station_name=$2
	local main_log_folder=${PATH_LOG_FOLDER}_${station_name}
	local timestamp=$(common_time_tag ${actions})
	local logs_path=${main_log_folder}/${actions}_${timestamp}.log

	# ---------------------------------------------------------------------------
	# Refs the if/else of the "function common_time_tag"
	# the func common_time_tag $NAME_STAGE_PRE, which will ret --> "timestamp1"
	# the func common_time_tag $NAME_STAGE_POST, which will ret --> "timestamp1_to_timestamp2"
	# as log-name we don't need to much information
	# so re-filter to make log-name be easier.
	# ---------------------------------------------------------------------------
	# local log_name_after_filter=`echo ${timestamp} | awk -F "_to_" '{printf $1}'`

	if [ ! -d "${main_log_folder}" ]; then
		mkdir ${main_log_folder}
	fi

	common_record_dut_status_flow "${actions}" "${logs_path}" "${timestamp}" "${station_name}"
	common_record_console_ramoops "${actions}" "${logs_path}" "${timestamp}"

	# ---------------------------------------------------------------------------
	# common_diff_of_send_commands "${actions}" "${logs_path}" "${name}" "${cmd}" "${logs_append_path}" "{print_msg}"
	# ---------------------------------------------------------------------------
	common_diff_of_send_commands "${actions}" "${logs_path}" "ec_gpioget" "ectool gpioget" "${PATH_LOG_LAST_EC_GPIOGET}" "ectool_gpioget: (default is empty)"
	common_diff_of_send_commands "${actions}" "${logs_path}" "ec_panicinfo" "ectool panicinfo" "${PATH_LOG_LAST_EC_PANICINFO}" "ectool_panicinfo: (default is empty)"
	common_diff_of_send_commands "${actions}" "${logs_path}" "lsusb_verbose" "lsusb --verbose" "${PATH_LOG_LAST_LSUSB}" "lsusb: (default is empty)"
	common_diff_of_send_commands "${actions}" "${logs_path}" "wakeup_sources" "cat /sys/kernel/debug/wakeup_sources" "${PATH_LOG_LAST_WAKEUP_SOURCE}" "debug/wakeup_sources: (default is sw-rtc-00:03)"

	# ---------------------------------------------------------------------------
	# platform special actions
	# ---------------------------------------------------------------------------
	func_platform_special_debug_actions "${actions}" "${logs_path}" "${timestamp}"

	# ---------------------------------------------------------------------------
	# Last-Step. Since the log has been generated, let's remove the older log
	# ---------------------------------------------------------------------------
	common_remove_redundant_logs "${actions}" "${main_log_folder}"
}

# ----- main -----------------------------------
# set arguments
param_1_action="$1"
param_2_station=$(echo "$2" | tr '[:upper:]' '[:lower:]')

if [ "$param_2_station" = "" ]; then
	param_2_station=${DEFAULT_TEST_STATION}
fi

case "${param_1_action}" in
"${NAME_STAGE_PRE}" | "${NAME_STAGE_POST}")
	func_main_flow "$param_1_action" "$param_2_station"
	;;
*)
	common_end_process "1" \
	"main. param is wrong. param_1_action: $param_1_action; param_2_station: $param_2_station;\n\n./this-script-name.sh <action>\n<action> either 'Pre_Oper' or 'Post_Oper';\n<station> - a name for this test-station"
	;;
esac
