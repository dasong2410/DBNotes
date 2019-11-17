--删除用户下的对象
set serveroutput on;
begin
  if(user!='SYS' and user!='SYSTEM') then
    --删除表
    dbms_output.put_line('Drop table:');

    for l_tab in (select table_name from user_tables) loop
      begin
        execute immediate 'drop table ' || l_tab.table_name || ' purge';

        dbms_output.put_line('  Succ: ' || l_tab.table_name);
      exception
        when others then
          dbms_output.put_line('  Fail: ' || l_tab.table_name);
      end;
    end loop;

    --删除视图
    dbms_output.put_line(chr(10) || 'Drop view:');

    for l_view in (select view_name from user_views) loop
      begin
        execute immediate 'drop view ' || l_view.view_name;

        dbms_output.put_line('  Succ: ' || l_view.view_name);
      exception
        when others then
          dbms_output.put_line('  Fail: ' || l_view.view_name);
      end;
    end loop;

    --删除序列
    dbms_output.put_line(chr(10) || 'Drop sequence:');

    for l_seq in (select sequence_name from user_sequences) loop
      begin
        execute immediate 'drop sequence ' || l_seq.sequence_name;

        dbms_output.put_line('  Succ: ' || l_seq.sequence_name);
      exception
        when others then
          dbms_output.put_line('  Fail: ' || l_seq.sequence_name);
      end;
    end loop;

    --删除作业
    dbms_output.put_line(chr(10) || 'Drop job:');

    for l_job in (select job_name from user_scheduler_jobs) loop
      begin
        dbms_scheduler.drop_job(job_name=>l_job.job_name, force=>true);

        dbms_output.put_line('  Succ: ' || l_job.job_name);
      exception
        when others then
          dbms_output.put_line('  Fail: ' || l_job.job_name);
      end;
    end loop;
  else
    dbms_output.put_line('Caution: You can''t drop any object of a system user.');
  end if;
end;
/
