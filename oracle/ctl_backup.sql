--备份控制文件到trc中，trc通过v$diag_info查询
alter database backup controlfile to trace;
select value from v$diag_info where name='Default Trace File';

--备份控制文件到/tmp/my.ctl
alter database backup controlfile to trace as '/tmp/my.ctl';
