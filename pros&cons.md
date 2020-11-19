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

- placeholder

- placeholder

### Cons

- placeholder

- placeholder


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
#

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


- mysql 表可以设置区分大小写，linux默认区分，windows默认不区分，操蛋的功能

- mysql 中没有区间值生成函数，如生成 1-10000 的连续数字，需要自己写函数

- mysql 社区版没有物理备份功能

- mysql 表可以单独设置字符集，不知道实际有没有用

- 数据库名不能直接改，要新建数据库
