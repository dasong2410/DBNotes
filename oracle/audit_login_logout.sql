--drop table t_logon_off;
create table t_logon_off
(
  session_user varchar2(1024),
  host         varchar2(1024),
  ip_address   varchar2(1024),
  os_user      varchar2(1024),
  module       varchar2(1024),
  server_host  varchar2(1024),
  service_name varchar2(1024),
  sid          number,
  logon_time   date,
  logoff_time  date
);

create or replace trigger trg_logon
after logon on database
declare
begin
  insert into t_logon_off(session_user, host, ip_address, os_user, module, server_host, service_name, sid, logon_time)
  values (sys_context('USERENV', 'SESSION_USER'), sys_context('USERENV', 'HOST'), sys_context('USERENV', 'IP_ADDRESS'), sys_context('USERENV', 'OS_USER'), sys_context('USERENV', 'MODULE'), sys_context('USERENV', 'SERVER_HOST'), sys_context('USERENV', 'SERVICE_NAME'), sys_context('USERENV', 'SID'), sysdate);

  commit;
end trg_logon;
/

create or replace trigger trg_logoff
before logoff on database
declare
begin
  update t_logon_off
     set logoff_time=sysdate
   where host=sys_context('USERENV', 'HOST')
     and sid=sys_context('USERENV', 'SID');

  commit;
end trg_logoff;
/
