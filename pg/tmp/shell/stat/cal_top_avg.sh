#!/bin/sh
set -x
CUR_DIR=$(cd "$(dirname $0)"; pwd)

pid_cnt=$(awk -F',' '{print NF}' ${CUR_DIR}/log/pids.txt)
gp=$(sed 's/,/ -e /g' ${CUR_DIR}/log/pids.txt)

grep -e ${gp} ${CUR_DIR}/log/top.log | awk -v cnt=${pid_cnt} -F' ' 'BEGIN{sum_cpu=0; sum_mem=0; idx=0}{sum_cpu=sum_cpu+$9; sum_mem=sum_mem+$10; idx=idx+1}END{print sum_cpu, sum_mem, idx, sum_cpu/idx*cnt, sum_mem/idx*cnt}'
