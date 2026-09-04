#!/bin/bash

# 檢查 CPU 溫度
check_cpu_temperature() {
  local log_path="$1"
  local sample_count="$2"
  local min_avg="$3"
  local max_avg="$4"

  bash check_csv_max_range.sh /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" "${min_avg}" "${max_avg}" > PTAT.log
  sleep 3
  grep -nri 'Not in range' PTAT.log
  if [ $? == 0 ]; then
    echo "************* Thermal have problems ***************"
    sleep 10
    return 1
  fi
  echo "************* Thermal test pass **************"
}

# 檢查 CPU 平均功耗
check_cpu_avg_power() {
  local log_path="$1"
  local sample_count="$2"
  local min_avg="$3"
  local max_avg="$4"

  bash check_csv_avg_range.sh /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" "${min_avg}" "${max_avg}" > PTAT.log
  sleep 3
  grep -nri 'Not in range' PTAT.log
  if [ $? == 0 ]; then
    echo "************* Power have problems ***************"
    sleep 10
    return 1
  fi
  echo "************* Power test pass **************"
}

# 根據 CPU 型號執行檢查
run_ptat_by_cpu_type() {
  local log_path="$1"
  local sample_count=600
  local cpu_model=$(cat /proc/cpuinfo | grep 'model name' | head -n1)
  local model_name=`cros_config / name`
  echo ${model_name}


  case "${cpu_model}" in
	  *"Intel(R) N150"*)
      echo "CPU is: N150 (6W)"
      echo ${model_name}
      if [ "${model_name}" == "kelsier" ]; then 
        check_cpu_temperature /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 46 80
        check_cpu_avg_power /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 3 7
      else
        check_cpu_temperature /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 46 73 
        check_cpu_avg_power /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 3 7
      fi
      ;;
    *"Intel(R) N250"*)
      echo "CPU is: N250 (6W)"
      echo ${model_name}
      if [ "${model_name}" == "kelsier" ]; then 
        check_cpu_temperature /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 46 80
        check_cpu_avg_power /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 3 7
      else
        check_cpu_temperature /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 46 73
        check_cpu_avg_power /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 3 7
      fi
      ;;
    *"Intel(R) Core(TM) 3 N355"*)
      echo "CPU is: N355 (15W)"
      echo ${model_name}
      if [ "${model_name}" == "kelsier" ]; then 
        check_cpu_temperature /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 46 78 
        check_cpu_avg_power /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 12 18
      else
        check_cpu_temperature /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 46 78 
        check_cpu_avg_power /home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv "${sample_count}" 12 18
      fi
      ;;
    *)
      echo "unknown cpu: ${cpu_model}"
      return 1
      ;;
  esac
}

# 主流程
log_path="/home/chronos/user/MyFiles/Downloads/Documents/iPTAT/log/log_cpu_*.csv"
if [ ! -f ${log_path} ]; then
  echo "********PTAT not executed yet********"
  exit 1
fi

cd /usr/local/factory/sh || exit 1
run_ptat_by_cpu_type "${log_path}"
