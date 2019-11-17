create or replace procedure proc_oneoff
as
begin
    null;
            exception
            when others then
    null;
end proc_oneoff;
/

begin
    dbms_scheduler.create_job (
    job_name        => 'JOB_ONEOFF',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'begin proc_oneoff; end;',
    enabled         => true
  );
end;
/
