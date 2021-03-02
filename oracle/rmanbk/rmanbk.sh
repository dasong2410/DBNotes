#! /bin/sh
#set -x

#µ±Ç°Ä¿Â¼
CURR_DIR=$(cd "$(dirname $0)"; pwd)

for i in /etc/profile.d/*.sh ; do
  if [ -r "$i" ]; then
    . $i
  fi
done

bk_dir=/rmanbk
bk_date=$(date +%Y%m%d)

#begin time
cat <<EOF >> ${CURR_DIR}/log/backup_${bk_date}.log
---------------------------------------------------------------
begin backup at $(date)
---------------------------------------------------------------
EOF

#begin to run rman
rman target / <<EOF >> ${CURR_DIR}/log/backup_${bk_date}.log
  run{
    crosscheck archivelog all;
    crosscheck backup;
    delete noprompt obsolete;
    delete noprompt expired backup;
    delete noprompt expired archivelog all;
    
    recover copy of database with tag 'daily_backup' until time 'SYSDATE-1';
    backup incremental level 1 for recover of copy datafilecopy format '${bk_dir}/lev0_%U' with tag 'daily_backup' format '${bk_dir}/lev1_%U' database;
    
    sql 'alter system archive log current';
    backup archivelog all format '${bk_dir}/lev1_arch-D_%d-id-%I_S-%e_T-%h_A-%a_%u' delete input;
  }
EOF

#end time
cat <<EOF >> ${CURR_DIR}/log/backup_${bk_date}.log
---------------------------------------------------------------
end backup at $(date)
---------------------------------------------------------------
EOF
