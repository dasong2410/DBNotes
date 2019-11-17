select a.statistic#, b.name, a.value
  from v$mystat a, v$statname b
 where a.statistic#=b.statistic#
 order by a.statistic#;

select a.sid, a.statistic#, b.name, a.value
  from v$sesstat a, v$statname b
 where a.statistic#=b.statistic#
 order by a.sid, a.statistic#;
