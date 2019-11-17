begin
    dbms_scheduler.run_job(job_name => 'JOB_MERGE_ORDER');
end;
/
