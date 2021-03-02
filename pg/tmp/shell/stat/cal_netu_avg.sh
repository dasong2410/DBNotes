#!/bin/sh
CUR_DIR=$(cd "$(dirname $0)"; pwd)

grep "eth0" ${CUR_DIR}/log/net.log | awk -F' ' 'BEGIN{sum=0; idx=0}{sum=sum+$7; idx=idx+1;}END{print sum, idx, sum/idx}'
