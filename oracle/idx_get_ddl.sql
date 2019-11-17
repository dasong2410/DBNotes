-- specific index
set serveroutput on;
begin
  dbms_output.put_line(dbms_metadata.get_ddl ('INDEX', upper('index_name'), user) || ';');
end;
/

-- indexes belongs to specific table
set serveroutput on;
declare
  l_idx_sql varchar2(4000);
begin
  for l_idx in (select index_name
                  from user_indexes
                 where table_name=upper('table_name')) loop
    l_idx_sql := dbms_metadata.get_ddl ('INDEX', l_idx.index_name, user);

    dbms_output.put_line(l_idx_sql || ';');
  end loop;
end;
/
