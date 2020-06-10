

```sql
-- memory
SELECT * from sys.configurations
 where name like '% server memory%';

sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'min server memory', 0;
GO
sp_configure 'max server memory', 2048;
GO
RECONFIGURE;
GO
```
