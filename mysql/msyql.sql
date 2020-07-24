select * from performance_schema.data_locks;
select * from performance_schema.data_lock_waits;
SELECT * FROM information_schema.tables where TABLE_SCHEMA='ODS' and lower(TABLE_NAME) like '%old';
SELECT * FROM information_schema.tables where TABLE_SCHEMA='ODS' and lower(TABLE_NAME) like '%for_drop';

ALTER TABLE ODS_TicketBase CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
ALTER TABLE ODS_TicketBaseOld CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
ALTER TABLE ODS_TicketBase_ALL CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
select DATE_ADD(now(),INTERVAL 1 DAY), date_sub(now(),INTERVAL 15 DAY) from dual;


SHOW VARIABLES LIKE '%version%';
SHOW VARIABLES LIKE 'datadir';
show variables like 'innodb_file_per_table';
show variables like 'innodb_%';

show create table test.test1;

select * from information_schema.TABLESPACES;

show engines ;

show engine innodb status;
Show processlist;
SELECT CONNECTION_ID();
explain for connection 341;

kill 1135;

-- query character set
SELECT @@character_set_database, @@collation_database;

SELECT SCHEMA_NAME, DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM INFORMATION_SCHEMA.SCHEMATA;

-- modify character set
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

-- procedure example
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


-- create user
create user dasong@'%' identified by '2wsx@WSX';

-- grant permission
grant all privileges on *.* to 'dasong'@'%';

-- backup
mysqldump -uroot -p ODS > dump_$(date +"%Y%m%d").sql

-- setup firewall
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload

--
mysqld --verbose --help


select * from sys.sys_config;


SHOW ENGINE INNODB STATUS;
SELECT @@default_storage_engine;
select @@innodb_default_row_format;
SHOW TABLE STATUS FROM test LIKE 't%';

SELECT @@datadir,@@innodb_data_home_dir,@@innodb_directories;