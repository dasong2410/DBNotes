<a name="Database-Pros&Cons"></a>
# Database Pros&Cons

- [Oracle](#Oracle)
- [MSSQL](#MSSQL)
- [PostgreSQL](#PostgreSQL)
- [MySQL](#MySQL)

---
<a name="Oracle"></a>
## [Oracle](#Database-Pros&Cons)

### Pros

- placeholder
- placeholder

### Cons

- placeholder
- placeholder


---
<a name="MSSQL"></a>
## [MSSQL](#Database-Pros&Cons)

### Pros

- stable
- simple to use
- simple to install

### Cons

- read, write mutex
- increase char len will modify all table
- can not increase column len if there is an index on it
- logshipping is just couple jobs to backup, copy and retore logs to secondary database, so crude
- job history has a up limit, default 1000 totally, 100 per job
- offering too much procedures, and make things too complex
- master.dbo.xp_delete_file can delete backup and maint plan files only
- too many unnecessary features like autoclose database
- \+ can only concat multiple string, varchar+int will raise error. no dedicate concat operation like oracle or pg ||

```sql
select 'xcvxdf' + 12121
Msg 245, Level 16, State 1, Line 14
Conversion failed when converting the varchar value 'xcvxdf' to data type int.

select 'xcvxdf' + '12121'
select CONCAT('xcvxdf',  12121)
```

- stupid nullif can return null, but sql server treat it as other type, like varchar, int, which makes isnull truncate varchar

```sql
select isnull(nullif('11111', '11111'), convert(varchar, dateadd(hour, -1, getdate()), 121)) -- 2021-
select isnull(nullif('11111111111111111111111111111', '11111111111111111111111111111'), convert(varchar, dateadd(hour, -1, getdate()), 121)) -- 2021-02-01 09:08:54.717
select isnull(null, convert(varchar, dateadd(hour, -1, getdate()), 121)) -- 2021-02-01 09:09:04.257
```

---
<a name="PostgreSQL"></a>
## [PostgreSQL](#Database-Pros&Cons)

### Pros

- placeholder
- placeholder

### Cons

- placeholder
- placeholder


---
<a name="MySQL"></a>
## [MySQL](#Database-Pros&Cons)

### Pros

- placeholder
- placeholder

### Cons


- 字符集导致数据插入失败，修改表字符集后成功

```sql
drop table if exists tmp_charset_test_for_drop;
create table tmp_charset_test_for_drop
(
    c1 varchar(255)
);

insert into tmp_charset_test_for_drop values('🙃');
[2019-08-09 09:23:44] [HY000][1366] Incorrect string value: '\xF0\x9F\x99\x83' for column 'c1' at row 1

ALTER TABLE tmp_charset_test_for_drop CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

insert into tmp_charset_test_for_drop values('🙃');
[2019-08-09 09:24:46] 1 row affected in 12 ms
```

- mysql 表可以设置区分大小写，linux默认区分，windows默认不区分，操蛋的功能
- mysql 中没有区间值生成函数，如生成 1-10000 的连续数字，需要自己写函数
- no sequence generating function out of box, unless user creates themself
- community edition doesn't include physical backup feature
- no physical duplication feature
- mysql 表可以单独设置字符集，不知道实际有没有用
- cann't rename database, unless create a new one
