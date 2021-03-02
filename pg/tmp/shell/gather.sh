#!/bin/sh
#set -x

CUR_DIR=$(cd "$(dirname $0)"; pwd)

nohup sh ${CUR_DIR}/stat/top.sh &
nohup sh ${CUR_DIR}/stat/net.sh &
