set serveroutput on;
declare
  l_sql varchar2(4000);
begin
  dbms_output.put_line('set serveroutput on;' || chr(10));

  for l_job in(select job_name,
                      job_type,
                      job_action,
                      to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') start_date,
                      repeat_interval,
                      enabled
                 from user_scheduler_jobs) loop
  l_sql := 'begin'                                                                                                                || chr(10)
        || '  dbms_scheduler.create_job'                                                                                          || chr(10)
        || '  ('                                                                                                                  || chr(10)
        || '    job_name        => '''          || l_job.job_name                           || ''','                              || chr(10)
        || '    job_type        => '''          || l_job.job_type                           || ''','                              || chr(10)
        || '    job_action      => '''          || replace(l_job.job_action, '''', '''''')  || ''','                              || chr(10)
        || '    start_date      => to_date('''  || l_job.start_date                         || ''', ''YYYY-MM-DD HH24:MI:SS''),'  || chr(10)
        || '    repeat_interval => '''          || l_job.repeat_interval                    || ''','                              || chr(10)
        || '    enabled         => '            || lower(l_job.enabled)                                                           || chr(10)
        || '  );'                                                                                                                 || chr(10)
        || 'exception'                                                                                                            || chr(10)
        || '  when others then'                                                                                                   || chr(10)
        || '    dbms_output.put_line(substr(sqlerrm, 1, 2000));'                                                                  || chr(10)
        || 'end;'                                                                                                                 || chr(10)
        || '/';

    dbms_output.put_line('--exec dbms_scheduler.drop_job(''' || l_job.job_name || ''')' || chr(10));
    dbms_output.put_line(l_sql || chr(10));
  end loop;
end;
/
