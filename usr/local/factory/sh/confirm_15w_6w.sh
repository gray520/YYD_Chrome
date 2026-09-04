#!/bin/bash

run_ptat_by_cpu_type() {
  local cpu_model=$(cat /proc/cpuinfo | grep 'model name' | head -n1)
  case "${cpu_model}" in
    *"Intel(R) N150"*)
      echo "CPU is: N150 (6W)"
      cp /usr/local/factory/sh/0728FDTWL6Wturbooff.json  /usr/local/factory/sh/0702cpustress30min.json
      echo "****************** copy power 6W json ***************************"
      ;;
    *"Intel(R) N250"*)
      echo "CPU is: N250 (6W)"
      cp /usr/local/factory/sh/0728FDTWL6Wturbooff.json  /usr/local/factory/sh/0702cpustress30min.json
      echo "****************** copy power 6W json ***************************"
      ;;
    *"Intel(R) Core(TM) 3 N355"*)
      echo "CPU is: N355 (15W)"
      cp /usr/local/factory/sh/0730FDTWL15Wturbooff.json  /usr/local/factory/sh/0702cpustress30min.json
      echo "****************** copy power 15W json ***************************"
      ;;
    *)
      echo "unknown cpu: ${cpu_model}"
      return 1
      ;;
  esac
}

run_ptat_by_cpu_type

