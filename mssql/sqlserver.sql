-- 外部表视图
SELECT * FROM sys.external_data_sources;
SELECT * FROM sys.external_file_formats;
SELECT * FROM sys.external_tables;

-- 查看表是否是外部表
SELECT name, type, is_external FROM sys.tables WHERE name='myTableName';

-- 字段截取
select cast(substring('AB1232', PATINDEX('%[0123456789]%', 'AB1232'), len('AB1232')) as int);

-- 数据库字符集
select * from fn_helpcollations();

SELECT Name, Description FROM fn_helpcollations()  
WHERE Name like 'L%' AND Description LIKE '% binary sort';  

-- all supported collations for (var)char columns in memory-optimized tables  
select * from sys.fn_helpcollations()  
where collationproperty(name, 'codepage') = 1252; 

-- all supported collations for indexes on memory-optimized tables and   
-- comparison/sorting in natively compiled stored procedures  
select * from sys.fn_helpcollations() where name like '%BIN2';


SELECT SERVERPROPERTY('Collation')