--归档日志是否连续，如果有值输出，则不连续
select *
  from (select recid, sequence#, first_change#, next_change#,
               next_change#-lead(first_change#, 1, next_change#) over(order by sequence#) diff
          from v$archived_log
         where dest_id=1)
 where diff>0;
