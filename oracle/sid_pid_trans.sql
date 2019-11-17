--根据spid定位sid、用户、sql等
--session信息
select s.sid, s.serial#, s.paddr, s.username, s.machine, s.program, s.event, s.p1text, s.p1, s.p2text, s.p2, s.p3text, s.p3
  from v$session s, v$process p
 where s.paddr=p.addr
   and p.spid=0000;

--sql
select sql_fulltext from v$sql
 where sql_id in (select s.sql_id from v$session s, v$process p
                   where s.paddr=p.addr
                     and p.spid=0000);

--session信息、sql
select s.sid, s.serial#, s.paddr, s.username, s.machine, s.program, s.event, s.p1text, s.p1, s.p2text, s.p2, s.p3text, s.p3, s.sql_id,
       sq.sql_fulltext
  from v$session s, v$process p, v$sql sq
 where s.paddr=p.addr
   and s.sql_id=sq.sql_id(+)
   and p.spid=0000;

--根据sid定位spid
select p.pid, p.spid, p.program, p.tracefile
  from v$session s, v$process p
 where s.paddr=p.addr
   and s.sid=0000;
