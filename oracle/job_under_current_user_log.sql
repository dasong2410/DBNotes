select *
from user_scheduler_job_run_details
where job_name = upper('job_name')
order by log_id;
