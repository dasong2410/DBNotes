#! /bin/bash
#set -x

CURR_DIR=$(cd "$(dirname $0)"; pwd)

sql_dir=${1:-1}
sql_cnt=${2:-1}

rm -rf ${CURR_DIR}/${sql_dir}/*.txt

for (( i=1; i<=${sql_cnt}; i++ )); do
  pgbench "service=admin dbname=app_db host=10.242.9.237 password=pgsql@SuningRds" -n -c 16 -j 1 -r -P 1 -T 30 -f ${CURR_DIR}/${sql_dir}/${sql_dir}${i}.sql > ${CURR_DIR}/${sql_dir}/${sql_dir}${i}.txt &
done
