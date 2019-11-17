--1.第二种方法可能比较复杂，暂时不确定两种取出的结果有什么区别
--当前session对应的跟踪日志文件
select p.pid, p.spid, p.program, p.tracefile
  from v$session s, v$process p
 where s.paddr=p.addr
   and s.sid=(select sid from v$mystat where rownum=1);

--指定session对应的跟踪日志文件
accept sid varchar2(512) prompt '请输入Session ID：'
select p.pid, p.spid, p.program, p.tracefile
  from v$session s, v$process p
 where s.paddr=p.addr
   and s.sid=&sid;

--2.抄自网络
--当前session对应的跟踪日志文件
select d.value || '/' || i.instance_name || '_ora_' || p.spid || '.trc' trace_file_name
  from (select p.spid
        from v$mystat m,
             v$session s,
             v$process p
       where m.statistic#=1
         and s.sid=m.sid
         and p.addr=s.paddr) p,
       (select instance_name from v$instance) i,
       (select value from v$parameter where name = 'user_dump_dest') d;

--指定session对应的跟踪日志文件
accept sid varchar2(512) prompt '请输入Session ID：'
select d.value || '/' || i.instance_name || '_ora_' || p.spid || '.trc' trace_file_name
  from (select p.spid
        from v$session s,
             v$process p
       where p.addr=s.paddr
         and s.sid=&sid) p,
       (select instance_name from v$instance) i,
       (select value from v$parameter where name = 'user_dump_dest') d;
