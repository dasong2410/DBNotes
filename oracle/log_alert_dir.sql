--alert日志获取
select value || '/alert_' || sys_context('USERENV', 'INSTANCE_NAME') || '.log'
  from v$diag_info
 where name='Diag Trace';
