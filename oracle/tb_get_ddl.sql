--获取表的ddl
set serveroutput on;

--当前用户下所有表
begin
  for l_tb in (select table_name from user_tables) loop
    dbms_output.put_line(dbms_metadata.get_ddl(object_type => 'TABLE', name => l_tb.table_name) || ';');
  end loop;
end;
/

--当前用户下指定表
begin
  dbms_output.put_line(dbms_metadata.get_ddl(object_type => 'TABLE', name => upper('&table_name')) || ';');
end;
/
