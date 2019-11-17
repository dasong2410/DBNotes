--drop table t_db_log;
create table t_db_log
(
  sid           number,
  serial#       number,
  proc_name     varchar2(30),
  log_date      date,
  log_msg       varchar2(1024),
  err_line_info varchar2(1024)
);

--用户需要有v$session的查询权限
--grant select on v_$session to username;
create or replace procedure p_db_logger
/* Author:    Marcus Mao
 * Date:      2012-06-25
 * Desc:      用于存储过程等记录执行日志
 * Modified:
 *            2015-03-25 t_db_log增加sid、serial#字段
 */
(
  p_proc_name     varchar2,             --过程名称
  p_log_msg       varchar2,             --日志内容
  p_err_line_info varchar2  default ''  --报错行号信息
)
as
  pragma  autonomous_transaction;
  l_sid     number;
  l_serial# number;
begin
  select sid, serial# into l_sid, l_serial#
    from v$session
   where sid=sys_context('USERENV', 'SID');

  insert into t_db_log (sid, serial#, proc_name, log_date, log_msg, err_line_info)
  values (l_sid, l_serial#, p_proc_name, sysdate, p_log_msg, p_err_line_info);

  commit;
exception
  when others then
    rollback;
    dbms_output.put_line(substr(sqlerrm, 1, 200));
end p_db_logger;
/

--使用样例
create or replace procedure p_test
as
  l_myname    varchar2(30)  := dbn_utl.whoami;
begin
  --记录开始
  proc_noah_logger(l_myname, '开始');

  null;

  --记录结束
  proc_noah_logger(l_myname, '结束');
exception
  when others then
    --记录异常
    proc_noah_logger(l_myname, substr(sqlerrm, 1, 1024), dbms_utility.format_error_backtrace());
end p_test;
/
