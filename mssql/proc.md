## Procs

### xx

```sql

```sql
select *
from sys.procedures
where is_auto_executed = 1;


USE MASTER
GO
SELECT VALUE, VALUE_IN_USE, DESCRIPTION
FROM SYS.CONFIGURATIONS
WHERE NAME = 'scan for startup procs'



sp_procoption


select *
from sys.procedures
where is_auto_executed = 1;


SELECT *
FROM MASTER.INFORMATION_SCHEMA.ROUTINES
WHERE OBJECTPROPERTY(OBJECT_ID(ROUTINE_NAME),'ExecIsStartup') = 1
```