--事物相关sid、username、sql
select b.sid, b.serial#, b.username, a.sql_fulltext, d.xidusn, d.xidslot, d.xidsqn
  from v$sql a,
       v$session b,
       (select sid, trunc(id1/65536) xidusn, bitand(id1, 65535) xidslot, id2 xidsqn
          from v$lock where type='TX') c,
       v$transaction d
 where a.sql_id=b.sql_id
   and b.sid=c.sid
   and c.xidusn=d.xidusn
   and c.xidslot=d.xidslot
   and c.xidsqn=d.xidsqn;

select * from v$rollstat;
select * from v$undostat;
select * from v$rollname;

select * from dba_segments where tablespace_name='UNDOTBS31';
select * from dba_segments where segment_type='TYPE2 UNDO';
