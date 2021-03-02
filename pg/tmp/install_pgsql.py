#! /usr/bin/env python
# -*- coding: utf-8 -*-

'''
Description : Install PostgreSQL on new server

Input : None

Output :     0: Installation finished successful 
         Non 0: Installation failed with error

Created on 2017/08/16

@author: 17030399@cnsuning.com
'''

import os,sys,platform,fnmatch
sys.path.append("..")
import lib.pgsqlRdsCfg
import lib.common.util
import lib.common.logger

# global variables 
stdout_logger = None
stderr_logger = None
postgres_passwd = None
admin_passwd = None
monitor_passwd = None
repl_passwd = None
core_path = None
data_path = None
arclog_path = None
backup_path = None
pgsqlRds_dir = None
pg_version = None

os_version = None

# context of ~postgres/.pgsql_profile
pgsql_profile_text = None
# context of ~postgres/.bashrc
bashrc_text = None
# context of ~postgres/.pg_service.conf
pg_service_text = None
# context of /etc/logrotate.d/postgresql
logrotate_pg_text = None

# 返回 : 日志文件（全路径）
# 环境变量PGSQLRDS_LOGFILE存在，则该变量值为日志文件；否则，根据当前脚本名设置默认日志。
def get_log_file():
    dir = os.path.dirname(os.path.realpath(__file__))
    myname = os.path.basename(__file__)
    default_log_dir = os.path.dirname(dir)+"/log"
    log_file = None
    if not os.getenv("PGSQLRDS_LOGFILE") :
        log_file = default_log_dir+"/"+myname[0:-2]+"log"
    else:
        log_file = os.getenv("PGSQLRDS_LOGFILE")
    
    return log_file

# 初期化全局变量
def init_global_variables():
    # 声明全局变量
    global stdout_logger,stderr_logger
    global postgres_passwd,admin_passwd,monitor_passwd,repl_passwd
    global core_path,data_path,arclog_path,backup_path,pgsqlRds_dir,pg_version
    global pgsql_profile_text,bashrc_text,pg_service_text,logrotate_pg_text
    global os_version

    # Get logger
    log_file = get_log_file()
    stdout_logger = lib.common.logger.create_stdout_logger(log_file)
    stderr_logger = lib.common.logger.create_stderr_logger(log_file)
    
    # Get variables from configuration file
    cfg = lib.pgsqlRdsCfg.PgsqlRdsCfg()
    
    postgres_passwd = cfg.postgres_passwd
    admin_passwd = cfg.admin_passwd
    monitor_passwd = cfg.monitor_passwd
    repl_passwd = cfg.repl_passwd
    core_path = cfg.core_path
    data_path = cfg.data_path
    arclog_path = cfg.arclog_path
    backup_path = cfg.backup_path
    pgsqlRds_dir = cfg.pgsqlRds_dir
    pg_version = cfg.pg_version
    
    os_version = int(platform.dist()[1][0])
    
    pgsql_profile_text = '''\
ulimit -c unlimited
ulimit -s 10240

if [ -f /etc/bashrc ]; then
. /etc/bashrc
fi
export PATH=/usr/pgsql/bin:%s/bin:$PATH
export PGDATA=%s
'''%(pgsqlRds_dir,data_path)

    bashrc_text = '''\
[ -f /var/lib/pgsql/.bash_profile ] && source /var/lib/pgsql/.bash_profile
'''

    pg_service_text = '''\
[postgres]
dbname=postgres
port=5432
user=postgres
password=%s
keepalives_idle=60
keepalives_interval=5
keepalives_count=10

[admin]
dbname=postgres
port=5432
user=admin
password=%s
keepalives_idle=60
keepalives_interval=5
keepalives_count=10

[monitor]
dbname=postgres
port=5432
user=monitor
password=%s
keepalives_idle=60
keepalives_interval=5
keepalives_count=10

[repl]
dbname=postgres
port=5432
user=repl
password=%s
keepalives_idle=60
keepalives_interval=5
keepalives_count=10
''' % (postgres_passwd, admin_passwd, monitor_passwd, repl_passwd)

    pg_log_dir = data_path + "/log"

    logrotate_pg_text = '''\
%s/postgresql.log {
    weekly
    dateext
    missingok
    compress
    delaycompress
    rotate 5
    notifempty
    nocreate
    size 20M
}
'''%(pg_log_dir)


def check_dirs():
    l_dir_missing_cnt = 0
    dirs = [core_path, data_path, arclog_path, backup_path]

    for d in dirs:
        if not os.path.exists(d):
            stderr_logger.exception('%s does not exist.'%(d))
            l_dir_missing_cnt += 1

    if l_dir_missing_cnt>0:
        stderr_logger.exception("Please make sure all directories PostgreSQL needed exist.")
        exit(1)


# Setup kernal parameter
def setup_kernel():
    iptablesISstarted = 0
    
    # modify kernel parameters, /etc/sysctl.conf
    lib.common.util.exec_cmd("sed -i '/# begin: pg setup kernels/,/# end: pg setup kernels/d' /etc/sysctl.conf")
    lib.common.util.exec_cmd("cat %s/cfg/rhel%s/sysctl.conf >> /etc/sysctl.conf"%(pgsqlRds_dir, os_version))

    cmdList = []

    if os.system("service iptables status >/dev/null") != 0 :
        cmdList.append("service iptables start >/dev/null")
        iptablesISstarted = 1

    cmdList.append("modprobe bridge")
    cmdList.append("sysctl -p")
    lib.common.util.exec_cmdList(cmdList)

    #rows = lib.common.util.exec_cmd("find /etc/udev/rules.d/ -name '*sysctl.rules'")
    #listrows = rows.split("\n")
    #for line in listrows:
    #    os.system("\mv -f %s %s.bak"%(line,line))
    lib.common.util.exec_cmd("find /etc/udev/rules.d/ -name '*sysctl.rules' -exec rename sysctl.rules sysctl.rules.bak {} \;")
    os.system("echo 'ACTION==\"add\", SUBSYSTEM==\"module\", RUN+=\"/sbin/sysctl -p\"' >> /etc/udev/rules.d/199-sysctl.rules")

    if iptablesISstarted == 1 :
        lib.common.util.exec_cmd("service iptables stop >/dev/null")


def install_pg_rpm():
    rpms = ''

    rpm_dir = '%s/rpms/rhel%s'%(pgsqlRds_dir, os_version)
    list_of_files = os.listdir(rpm_dir)
    pattern = "*.rpm"

    for entry in list_of_files:
        if fnmatch.fnmatch(entry, pattern):
            if os.system("rpm -qa|grep %s >/dev/null" % (entry[0:-4])) == 0:
                stdout_logger.info("package '%s' has already been installed" % (entry))
            else:
                rpms = "%s %s"%(entry, rpms)

    if rpms == '':
        stdout_logger.info("All rpms are already installed, skip this step.")
    else:
        cmd = "cd %s && rpm -ihv %s" % (rpm_dir, rpms)
        lib.common.util.exec_cmd(cmd)

    install_sitepackages()

    if os.path.exists('/usr/pgsql'):
        lib.common.util.exec_cmd("unlink /usr/pgsql")
    lib.common.util.exec_cmd("ln -sf /usr/pgsql-10 /usr/pgsql")


# 安装python第三方模块
def install_sitepackages():
    dir = os.path.dirname(os.path.realpath(__file__))
    pkg_dir = os.path.join(os.path.dirname(dir),'pkgs')
    #yum_install("python-crypto")
    python_version = platform.python_version()
    if python_version == '2.7.5':
        lib.common.util.exec_cmd("cp -rf %s/python2.7.5/site-packages/lib/* /usr/lib/python2.7/site-packages/"%(pkg_dir))
        lib.common.util.exec_cmd("cp -rf %s/python2.7.5/site-packages/lib64/* /usr/lib64/python2.7/site-packages/"%(pkg_dir))
    else:
        #yum_install("python-paramiko")
        print "python-paramiko"
    
    lib.common.util.exec_cmd("python -c 'import paramiko'")
    stdout_logger.info("'paramiko' installed")

    
# 创建一个新文件
# fileName: 文件名（全路径）
# fileText: 文件内容    
def create_file(fileName, fileText):
    with open(fileName,'wb') as fw:
        fw.write(fileText)
        
    stdout_logger.info("file '%s' created"%fileName)

# 设置/etc/sysconfig/i18n
# 输入
#   lang_value : 参数LANG的设置值
def set_locale(lang_value):
    lib.common.util.exec_cmd("sed 's/LANG=.*/LANG=%s/g' /etc/sysconfig/i18n"%lang_value)
    stdout_logger.info("set locale to %s (need relogin)"%lang_value)

# 配置postgres系统用户的环境文件
def make_env_file():
    # 创建文件
    create_file("/var/lib/pgsql/.pgsql_profile", pgsql_profile_text)    
    create_file("/var/lib/pgsql/.bashrc", bashrc_text)
    create_file("/var/lib/pgsql/.pg_service.conf", pg_service_text)
    create_file("/etc/logrotate.d/postgresql" , logrotate_pg_text)
    
    # 设置权限
    cmdList = []
    cmdList.append("chown postgres:postgres /var/lib/pgsql/.pgsql_profile")
    cmdList.append("echo '/usr/local/lib/' > /etc/ld.so.conf.d/libevent.conf")
    cmdList.append("ldconfig")
    cmdList.append("chown postgres:postgres /var/lib/pgsql/.bashrc")
    cmdList.append("chown postgres:postgres /var/lib/pgsql/.pg_service.conf")
    cmdList.append("chmod 600 /var/lib/pgsql/.pg_service.conf")
    
    lib.common.util.exec_cmdList(cmdList)

# 给pg相关目录设置权限和owner(postgres)    
def set_dir_permission():
    cmdList = []
    cmdList.append("chown postgres:postgres %s"%(data_path) )
    cmdList.append("chown postgres:postgres %s"%(arclog_path) )
    cmdList.append("chown postgres:postgres %s"%(backup_path) )
    cmdList.append("chown postgres:postgres %s"%(core_path) )
    cmdList.append("chmod 700 %s"%(data_path) )
    lib.common.util.exec_cmdList(cmdList)  

# 给命令设置suid权限
# 输入
#   cmd_path : 命令路径(绝对路径)
def set_suid_to_command(cmd_path):
    lib.common.util.exec_cmd("chmod u+s "+cmd_path)
    stdout_logger.info("set suid to '%s'"%cmd_path)
    
def set_os_postgres_password():
    lib.common.util.exec_cmd("echo '%s' | passwd --stdin 'postgres' "%(postgres_passwd))
    stdout_logger.info("change password OK")

# 设置postgres用户的sudo权限
def set_postgres_sudo():
    # 设置postgres账号的sudo权限
    lib.common.util.exec_cmd("cat %s/cfg/sudo-postgres > /etc/sudoers.d/postgres && chmod 440 /etc/sudoers.d/postgres"%pgsqlRds_dir)
    stdout_logger.info("sudo configure setted to postgres")


def set_postgres_limits():
    lib.common.util.exec_cmd("cat %s/cfg/limit-postgres.conf > /etc/security/limits.d/postgres.conf"%pgsqlRds_dir)


# Main
def install_pgsql():
    init_global_variables()

    try:
        stdout_logger.info("============================install_pgsql start============================")
        stdout_logger.info("check if dirs exist")
        check_dirs()

        stdout_logger.info("[step1] install packages")
        install_pg_rpm()
        stdout_logger.info("[step2] set permission for directories('%s','%s','%s','%s')"%(data_path,arclog_path,backup_path,core_path) )
        set_dir_permission()
        stdout_logger.info("[step3] set locale")
        set_locale("en_US.UTF-8")
        stdout_logger.info("[step4] set kernel")
        setup_kernel()
        stdout_logger.info("[step5] make environment files for postgres")
        make_env_file()
        stdout_logger.info("[step6] set suid to commands")
        set_suid_to_command("/sbin/ip")
        set_suid_to_command("/sbin/arping")
        stdout_logger.info("[step7] change password for os user 'postgres'")
        set_os_postgres_password()
        stdout_logger.info("[step8] set sudo for os user 'postgres'")
        set_postgres_sudo()
        stdout_logger.info("[step9] set limits for os user 'postgres'")
        set_postgres_limits()
        stdout_logger.info("============================install_pgsql end==============================")
        
    except Exception, e:
        stderr_logger.exception("INSTALL PGSQL FAILED")
        print e
        sys.exit(1)


if __name__ == "__main__":
    install_pgsql()
