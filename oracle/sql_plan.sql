--1.还未执行的sql
explain plan for
select * from t_test;

select * from table(dbms_xplan.display);

--2.已经执行过或是正在执行的sql
--从v$session、v$sql或其它视图中获取sql_id, child_number
select * from table(dbms_xplan.display_cursor('9428vhrspy3u1', 0));

--3.从awr中获取
--select * from dba_hist_sql_plan;
select * from table(dbms_xplan.display_awr('79uvsz1g1c168'));


--获取当前已连接session正在执行或是刚执行过的sql的执行计划
set serveroutput on;

begin
  for l_sql in (select b.sql_id, b.child_number
                  from (select sql_id from v$session
                         union
                        select prev_sql_id sql_id from v$session) a, v$sql b
                  where a.sql_id=b.sql_id) loop
    for l_line in(select plan_table_output from table(dbms_xplan.display_cursor(l_sql.sql_id, l_sql.child_number))) loop
      dbms_output.put_line(l_line.plan_table_output);
    end loop;

    dbms_output.put_line('====================================================================================================================');
    dbms_output.put_line('********************************************************************************************************************');
    dbms_output.put_line('====================================================================================================================' || chr(10));
  end loop;
end;
/
