#!/bin/bash 

python /usr/local/factory/py/test/pytests/edid-reader.py > read_edid.tbl
PID=`grep -ri "PID" read_edid.tbl | cut -d ":" -f 2`
echo "This PID is : ${PID}"
rm -rf *.txt
path=`ls -d /usr/local/factory/uniformity/*"${PID}"*`
echo ${path}
if [ ! -d "${path}" ]; then
  echo "***************you need not test ST5***********************"
  sleep 5
  exit 0
fi

if [ "${PID}" == "A5BC" ]; then 
  cd /usr/local/factory/uniformity/*"${PID}"*
  bash MT_Tool.sh
  if [ $? != 0 ]; then
    exit 1
  fi
fi

if [ "${PID}" == "E3BA" ]; then 
  cd /usr/local/factory/uniformity/*"${PID}"*
  bash MT_Tool.sh
  if [ $? != 0 ]; then
    exit 1
  fi
fi

if [ "${PID}" == "0DA5" ]; then 
  cd /usr/local/factory/uniformity/*"${PID}"*
  bash bti.sh
  if [ $? != 0 ]; then
    exit 1
  fi
fi

if [ "${PID}" == "0DB8" ]; then 
  cd /usr/local/factory/uniformity/*"${PID}"*
  bash bti.sh
  if [ $? != 0 ]; then
    exit 1
  fi
fi

if [ "${PID}" == "14A7" ]; then 
  cd /usr/local/factory/uniformity/*"${PID}"*
  bash MT_Tool.sh
  if [ $? != 0 ]; then
    exit 1
  fi
fi

if [ "${PID}" == "14A9" ]; then 
  cd /usr/local/factory/uniformity/*"${PID}"*
  bash MT_Tool.sh
  if [ $? != 0 ]; then
    exit 1
  fi
fi

if [ "${PID}" == "B429" ]; then 
  cd /usr/local/factory/uniformity/*"${PID}"*
  bash MT_Tool.sh
  if [ $? != 0 ]; then
    exit 1
  fi
fi

if [ "${PID}" == "14D2" ]; then 
  cd /usr/local/factory/uniformity/*"${PID}"*
  bash MT_Tool.sh
  if [ $? != 0 ]; then
    exit 1
  fi
fi

if [ "${PID}" == "14D0" ]; then 
  cd /usr/local/factory/uniformity/*"${PID}"*
  bash MT_Tool.sh
  if [ $? != 0 ]; then
    exit 1
  fi
fi

if [ "${PID}" == "0DC5" ] || [ "${PID}" == "CEB6" ] || [ "${PID}" == "149A" ]; then 
  cd /usr/local/factory/uniformity/APST5_DBTS_4619_461A_4618_0DC5_149A_CEB6
  bash MT_Tool.sh
  if [ $? != 0 ]; then
    exit 1
  fi
fi

