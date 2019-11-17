begin
    dbms_scheduler.create_job (
    job_name        => 'JOB_MERGE_APPALARM',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'begin proc_merge_appalarm; end;',
    repeat_interval => 'FREQ=DAILY; BYHOUR=4; BYMINUTE=10',
    enabled         => true
  );
end;
/
