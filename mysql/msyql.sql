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


# 创建用户
create user dasong@'%' identified by '2wsx@WSX';

# 赋权限
grant all privileges on *.* to 'dasong'@'%';

# 备份
mysqldump -uroot -p ODS > dump_$(date +"%Y%m%d").sql
