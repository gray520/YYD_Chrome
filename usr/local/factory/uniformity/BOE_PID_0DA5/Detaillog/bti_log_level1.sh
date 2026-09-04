#!/bin/bash

BASIC_SCRIPT="bti.sh"
OPTIONS="-warning -factory $@"
ret=1
#######################

if [[ -f ${BASIC_SCRIPT} ]]; then
  source ${BASIC_SCRIPT} ${OPTIONS}
  ret=$?
else
  echo "Sorry. Can't execute. (${BASIC_SCRIPT})"
fi

exit $ret
