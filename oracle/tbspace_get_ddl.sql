--print every tablespace's ddl sentance
set serveroutput on;

begin
  for l_tbs in (select name from v$tablespace) loop
    dbms_output.put_line(dbms_metadata.get_ddl(object_type => 'TABLESPACE', name => l_tbs.name) || ';');
  end loop;
end;
/
