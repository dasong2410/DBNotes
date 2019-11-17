accept usr_name varchar2(512) prompt '请输入要删除的用户名：'

set verify off
set feedback off
set serveroutput on

begin
  for l_sess in (select sid, serial# from v$session where username=upper('&&usr_name')) loop
    execute immediate 'alter system kill session ''' || l_sess.sid || ', ' || l_sess.serial# || '''';
  end loop;

  execute immediate 'drop user &&usr_name cascade';
exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

set verify on
set feedback on
set serveroutput off
