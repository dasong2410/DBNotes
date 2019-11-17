#! /bin/bash
#set -x
db_conn=${1}
pct=${2:-20}

#当前目录
CURR_DIR=$(cd "$(dirname $0)"; pwd)

if [ $# -lt 1 ]; then
  echo "Usage: sh maxiosql.sh system/system_pwd"
  exit
fi

#result file
sqlplan_file=${CURR_DIR}/tmp/sqlplan_io.tmp.$(date "+%Y%m%d%H%M%S")

#获取pid列表
pids=$(iotop -b -n 5 | awk -v pct=${pct} -F' ' '{if(match($1, /[0-9]+/) && $10>pct){print $1}}' | sort | uniq | sed '/^$/d' | tr \\n ,)
pids=${pids%,}

if [ -z "${pids}" ]; then
  echo "no pid"
  exit
fi

echo "Pids: ${pids}"

sqlplus -S ${db_conn} <<EOF | tee ${sqlplan_file}
set lines 900
set feedback off
set serveroutput on;

begin
  for l_sql in(with p as(select addr, spid from v\$process where spid in(${pids}))
             select ses.sql_id, sql.child_number, sql.sql_fulltext
               from p, v\$session ses, v\$sql sql
              where p.addr=ses.paddr
                and ses.sql_id is not null
                and ses.sql_id=sql.sql_id) loop

    for l_plan in(select plan_table_output from table(dbms_xplan.display_cursor(l_sql.sql_id, l_sql.child_number))) loop
      dbms_output.put_line(l_plan.plan_table_output);
    end loop;


    dbms_output.put_line(chr(10) || chr(10) || '=============================================================================================================');
    dbms_output.put_line('*************************************************************************************************************');
    dbms_output.put_line('=============================================================================================================' || chr(10));


  end loop;
end;
/
EOF
