#!/bin/sh
CUR_DIR=$(cd "$(dirname $0)"; pwd)

pids=$(ps -ef | grep -e "[p]g_basebackup" -e "[D]bBackup.jar" -e "[z]std" -e "[t]ar" | awk -F' ' 'BEGIN{pids=""; sep=""}{pids=pids sep $2; sep=","}END{print pids}')

if [ X"${pids}" != X"" ]; then 
  rm -rf ${CUR_DIR}/log/net.log && sar -n DEV 1 > ${CUR_DIR}/log/net.log
fi
