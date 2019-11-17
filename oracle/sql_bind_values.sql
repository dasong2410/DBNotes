--根据sql中的关键字查询绑定变量的值
select a.name, a.value_string, b.sql_text
  from v$sql_bind_capture a,
       v$sql b
 where a.sql_id = b.sql_id
   and lower(b.sql_text) like lower('%&sql_keyword%');

--根据sql_id查询绑定变量的值
select a.name, a.value_string, b.sql_text
  from v$sql_bind_capture a,
       v$sql b
 where a.sql_id = b.sql_id
   and a.sql_id='&sql_id';
