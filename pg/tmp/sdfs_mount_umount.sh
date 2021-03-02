#!/bin/bash

###########################################################
#sdfs 挂载卸载。
#author:17030399@cnsuning.com
#
#InPut: sdfs_server,sdfs_sdfs_volume
#OutPut:无
#
#return
#0  正常
#2  一般错误
#200  冗余调用
###########################################################

cd "$(dirname "$0")"
MYNAME="sdfs_mount_umount"

LOCKFILE="/tmp/${MYNAME}.lock"
SNDS_SDFS_BACKUP_SERVER="snds_sdfs_backup_server"

############################################# check redundant invoke start
# 通过flock fork子进程的方式防止重复调用，有重复调用时出错返回。
if [ "$1" != "--realrun" ]; then
  #检查锁是否被占用，占用的进程是否存活
  if [ -s $LOCKFILE ]; then
    pid=`head -1 $LOCKFILE`
    kill -0 $pid 2>/dev/null
    if [ $? -eq 0 ]; then
      echo "Another proccess of ${MYNAME} exists, can not redundant invoke!" >&2
      exit 200
    else
      rm -f $LOCKFILE
    fi
  fi
  # 抢锁
  echo "$$" >> $LOCKFILE
  pid=`head -1 $LOCKFILE`
  if [ "$pid" != "$$" ]; then
    echo "Another proccess of ${MYNAME} had got the lock, can not redundant invoke!" >&2
    exit 200
  fi
  # 作为子进程实际运行脚本
  sh $0 --realrun $@
  rc=$?
  rm -f $LOCKFILE
  exit $rc
else
  shift
fi
############################################# check redundant invoke end

my_usage()
{
cat >&2 <<EOF
Usage:${MYNAME}.sh -s <sdfs_server> -v <sdfs_volume> -m <sdfs_mount_point> -l <log_file>
Valid options are:
-h               help, Display this message
-s <sdfs_server>   sdfs server
-v <sdfs_volume>     sdfs volume
-m <sdfs_mount_point>  sdfs mount point
-l <log_file>   log file
EOF
}


## parse options

sdfs_server=
sdfs_volume=
sdfs_mount_point=
log_file=

while getopts "s:v:m:l:h" opt
do
  case $opt in
  s) sdfs_server=$OPTARG;;
  v) sdfs_volume=$OPTARG;;
  m) sdfs_mount_point=$OPTARG;;
  l) log_file=$OPTARG;;
  h) my_usage;exit 0;;
  *) my_usage;exit 2;;
  esac
done


if [[ -z "$sdfs_server" ]]; then
  echo "less required option: -s sdfs_server" >&2
  my_usage
  exit 2
fi

if [[ -z "$sdfs_volume" ]]; then
  echo "less required option: -v sdfs_volume" >&2
  my_usage
  exit 2
fi

if [[ -z "$sdfs_mount_point" ]]; then
  echo "less required option: -m sdfs_mount_point" >&2
  my_usage
  exit 2
fi

############################################# convenient functions

# 输出消息到日志文件$log_file,如果变量log_file为空，输出消息到控制台
log_info() {

  if [[ -n "$log_file" ]]; then
    echo "$(date '+%F %T,%N') - [info ] $@" >> "$log_file"
  else
    echo "$(date '+%F %T,%N') - [info ] $@"
  fi
}

# 输出消息到控制台，如果变量log_file不为空，同时输出消息到日志文件
log_err() {
  echo "$(date '+%F %T,%N') - [error] $@ (${BASH_SOURCE[1]}:${BASH_LINENO[0]})" >&2

  if [[ -n "$log_file" ]]; then
    echo "$(date '+%F %T,%N') - [error] $@ (${BASH_SOURCE[1]}:${BASH_LINENO[0]})" >> "$log_file"
  fi
}


############################################# convenient functions end


main(){
  mount_cmd="mount -t glusterfs ${sdfs_server}:/${sdfs_volume} ${sdfs_mount_point}"
  
  ## not mount
  if [ ! -d "${sdfs_mount_point}" ];then
    mkdir -p ${sdfs_mount_point}
    if [ ! -d "${sdfs_mount_point}" ];then
        log_err "mount dir '${sdfs_mount_point}' not exists"
        exit 2
    fi
  fi
  is_alive=0
  tmp_sdfs_sv_vol=(`cat /proc/mounts |grep glusterfs|awk '{print $1}'`)
  tmp_sdfs_mount_point=(`cat /proc/mounts |grep glusterfs|awk '{print $2}'`)
  for (( i=0;i<${#tmp_sdfs_mount_point[@]};i++ ))
  do
    if [[ "${sdfs_mount_point}" == "${tmp_sdfs_mount_point[i]}" ]];then
        if [[ "${sdfs_server}:/${sdfs_volume}" == "${tmp_sdfs_sv_vol[i]}" ]];then
            is_alive=1
        else
            umount -l ${sdfs_mount_point}
            sleep 2
        fi
    fi
  done
  
  if [ $is_alive -eq 0 ];then
    eval "${mount_cmd}"
    if [ $? -ne 0 ];then
        log_err "command '${mount_cmd}' failed"
        exit 2
    fi
  fi
  
  ## if lost transport endpoint
  df -h 2>&1 |grep "${sdfs_mount_point}" |grep -q "not connected"
  if [ $? -eq 0 ];then
    umount -l ${sdfs_mount_point}
    sleep 2
    eval "${mount_cmd}"
    if [ $? -ne 0 ];then
        log_err "command '${mount_cmd}' failed"
        exit 2
    fi
  fi
  
  ## check
  if [ ! -f "${sdfs_mount_point}/${SNDS_SDFS_BACKUP_SERVER}" ];then
    log_err "mount '${sdfs_mount_point}' failed"
    exit 2
  else
    log_info "mount '${sdfs_mount_point}' OK"
  fi
  
  exit 0
}

main
