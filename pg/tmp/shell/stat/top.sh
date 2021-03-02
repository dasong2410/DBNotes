#!/bin/sh
#set -x

CUR_DIR=$(cd "$(dirname $0)"; pwd)

pids=$(ps -ef | grep -e "[p]g_basebackup" -e "[D]bBackup.jar" -e "[z]std" -e "[t]ar" | awk -F' ' 'BEGIN{pids=""; sep=""}{pids=pids sep $2; sep=","}END{print pids}')

if [ X"${pids}" != X"" ]; then 
  echo ${pids} > ${CUR_DIR}/log/pids.txt
  rm -rf ${CUR_DIR}/log/top.log && top -c -b -d 1 -p ${pids} > ${CUR_DIR}/log/top.log
fi
