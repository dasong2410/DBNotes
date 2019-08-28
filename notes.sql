-- innodb_version,8.0.16
-- 常用sql
select * from performance_schema.data_locks;
select * from performance_schema.data_lock_waits;
SELECT * FROM information_schema.tables where TABLE_SCHEMA='ODS' and lower(TABLE_NAME) like '%old';
SELECT * FROM information_schema.tables where TABLE_SCHEMA='ODS' and lower(TABLE_NAME) like '%for_drop';

ALTER TABLE ODS_TicketBase CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
ALTER TABLE ODS_TicketBaseOld CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
ALTER TABLE ODS_TicketBase_ALL CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
select DATE_ADD(now(),INTERVAL 1 DAY), date_sub(now(),INTERVAL 15 DAY) from dual;

SHOW VARIABLES LIKE "%version%";

show engine innodb status;
Show processlist;
SELECT CONNECTION_ID();
explain for connection 341;

kill 1135;

-- 查看字符集
SELECT @@character_set_database, @@collation_database;

SELECT DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'ODS';

-- 修改字符集（待确认）
ALTER DATABASE database_name CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS table_name (
...
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

ALTER TABLE table_name CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE table_name modify name text charset utf8mb4;




select * from ODS.dws_business_acceptance limit 100;

SHOW INDEX FROM ODS.dws_business_acceptance;

select TicketType, TradeStatus, a.* from ODS.dwd_trade a limit 100;

select TicketType, TradeStatus, a.* from dwd_trade a limit 100;


SHOW INDEX FROM ODS.dwd_trade;

select count(TicketId) from dwd_trade;

select count(1) from ODS.dwd_trade;

show databases ;

-- 存储过程 语法样例
CREATE DEFINER=`root`@`%` PROCEDURE `calculate_register_user`()
BEGIN
declare i date;
declare j date;
set i="20161001";
set j="20190701";
while(i<=j) do
   insert tmp_calculate_register_user (months,count)
   select DATE_FORMAT(i,'%Y%m') as months, count(distinct UserID) from ODS_ClientUser
   where UserState=2
   and RegisterTime < i;
   set i=adddate(i, interval+1 month);
end while;

END;


select date_sub(date(now()), interval 1 month) from dual;


SELECT DATE_ADD('2016-08-02', INTERVAL help_topic_id DAY) as mydate
FROM mysql.help_topic order by help_topic_id asc limit 14;


-- issues
-- 1. 字符集导致数据插入失败，修改表字符集后成功
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


-- 2. mysql 表可以设置区分大小写，linux默认区分，windows默认不区分，操蛋的功能
-- 3. mysql 中没有区间值生成函数，如生成 1-10000 的连续数字，需要自己写函数
-- 4. mysql 社区版没有备份功能
-- 5. mysql 表可以单独设置字符集，不知道实际有没有用
