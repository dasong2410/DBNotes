--查询TM、TX锁相关的信息：用户名、表名、机器名、连接工具、sql等
select s.sid, s.serial#, l.type, l.id1, l.id2, l.lmode, l.request, l.block,
       o.owner, o.object_name, o.object_id, s.username, s.machine, s.program, s.sql_id
  from v$lock l,
       v$session s,
       dba_objects o
 where l.type in('TM', 'TX')
   and l.sid=s.sid
   and l.id1=o.object_id(+)
 order by s.sid, s.serial#, l.type;

--查询阻塞、被阻塞对象
select a.sid blocker_sid, a.type blocker_type, a.id1 blocker_id1, a.id2 blocker_id2, a.lmode blocker_lmode, a.request blocker_request,
       ' ---- ' "      ",
       b.sid blocked_sid, b.type blocked_type, b.id1 blocked_id1, b.id2 blocked_id2, b.lmode blocked_lmode, b.request blocked_request
  from v$lock a, v$lock b
 where a.block=1
   and a.id1=b.id1
   and a.id2=b.id2
   and a.sid!=b.sid;

select * from v$locked_object;
