#!/bin/bash

cd /usr/local/factory/uniformity/BOE_PID_0DB8/

TITLE="BTI Chrome Script" 
SCRIPT_VER="Ver. 1.1"
OPTIONS="$@"

EXE_ARM="./bti_arm"
EXE_X86="./bti"
X86_ARCH="x86_64"
ARM_ARCH="aarch64"

ERR_NOT_SUPPORT=101
ERR_WORK_DIR=102


SUCCESS=0
ERR_GENERAL=100
ERR_NO_G2TOUCH_DEVICE=101
ERR_G2TOUCH_DEVICE_2_MORE=102
ERR_NOT_SUPPORT_ARCHITECT=103
ERR_NO_EXEC_FILE=104

MSG_CANNOT_FIND_DEVICE="Fail. No G2touch device found."
MSG_FIND_DEVICE_2_MORE="Fail. more than 1 g2touch devices found."
MSG_NOT_SUPPORT_ARCHITECT="Fail. System Architecture was not supported."
MSG_NO_EXEC_FILE_FOUND="Fail. No Execution file found."
MSG_CANNOT_USE_INPUT_DEVICE="Fail. Cannot use input device."
#########################################

show_script_version() {
  echo "${TITLE} ${SCRIPT_VER}" >&2
}

get_architect() {
  architect=$(arch)
  echo ${architect}
}

get_exec_and_check() {
  local exec=""
  local ret_code=${SUCCESS}

  if [[ "${architect,,}" =~ "${ARM_ARCH}" ]]; then
    exec="${EXE_ARM}"
  elif [[ "${architect,,}" =~ "${X86_ARCH}" ]]; then
    exec="${EXE_X86}"
  fi

  if [[ -z ${exec} ]]; then
    echo "${MSG_NOT_SUPPORT_ARCHITECT}" >&2
    ret_code=${ERR_NOT_SUPPORT_ARCHITECT}
  elif [[ ! -f ${exec} ]]; then
    echo "${MSG_NO_EXEC_FILE_FOUND}" >&2
    ret_code=${ERR_NO_EXEC_FILE}
  fi

  echo ${exec}
  return ${ret_code}
}

main() {
  echo "===================================" >&2
  show_script_version

  local exec=""
  local architect=$(get_architect)

  echo "System Architecture: $architect" >&2

  exec=$(get_exec_and_check)
  ret_val=($?)

  if [[ ${ret_val} -eq ${SUCCESS} ]]; then
    local command="${exec} ${OPTIONS}"

    echo "> ${command}" >&2
    ${command}
    ret_val=($?)
  fi

#  Change ret_val to 1 if only a customer want to get 1 for any error.
#  if [[ $ret_val -ne 0 ]]; then
#    echo "ERR occurred($ret_val)"
#    ret_val=1
#  fi  

  return ${ret_val}
}

main
exit $?
