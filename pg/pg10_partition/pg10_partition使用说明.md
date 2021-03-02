# PostgreSQL 10 原生分区功能强化 使用说明

## 1. 功能

- 创建分区表
- 批量增加分区
- 批量删除分区
- 批量truncate分区
- 分区表添加索引
- 分区表删除索引
- ddl下推到分区

## 2. 使用方法

### 2.1. 创建分区表

	create table tb1(c1 int, c2 date, c3 int) partition by range (c2);

### 2.2. 批量增加分区

分区字段可以是date、varchar、int，但是必须是具有时间意义，即：YYYYMMDD

按**天**分区

	-- 表名，起始日期，分区间隔，分区个数
	select rds.add_range_partitions('public.tb1', '2019-03-01'::date, '1 day', 3);

按**月**分区

	-- 表名，起始日期，分区间隔，分区个数
	select rds.add_range_partitions('public.tb1', '2019-03-01'::date, '1 month', 3);

### 2.3. 批量删除分区

删除指定范围的分区，如：删除20190101~20190331 之间所有的分区；如果要删除表上所有的分区，则可以通过调整 开始 及 结束 值来实现

	-- 表名，起始日期，结束日期
	select rds.drop_range_partitions('public.tb1', '20190101', '20190331');

### 2.4. 批量truncate分区

删除指定范围的分区里的数据，如：删除 20190101~20190331 之间所有的分区里的数据；如果要删除表上所有的分区里的数据，则可以通过调整 开始 及 结束 值来实现

	-- 表名，起始日期，结束日期
	select rds.tuncate_range_partitions('public.tb1', '10100101', '30301231');

### 2.5. 分区表添加索引

	-- 表名，索引名，索引sql（%i 索引名占位符，%t 表名占位符，占位符必须出现）
	select rds.create_idx_on_parted_table('public.tb1', 'idx_tb1', 'create index %i on %t(c1)');

### 2.6. 分区表删除索引

	-- 表名，索引名
	select rds.drop_idx_on_parted_table('public.tb1', 'idx_tb1');

### 2.7. ddl下推到分区

	-- 表名，dll sql（%t 表名占位符，占位符必须出现）
	select rds.run_command_on_parted_table('public.tb1', 'alter table %t set(fillfactor = 90)');

## 3. other

### 3.1 相关表

查询 分区 上的索引
	
	select * from rds.user_tab_part_indexes;

### 3.2 启动/关闭 trigger

有些操作可能需要临时 disable trigger，参照一下sql

	alter event trigger etg_ddl_command_start disable;
	alter event trigger etg_ddl_command_start enable;
	
	alter event trigger etg_ddl_command_end disable;
	alter event trigger etg_ddl_command_end enable;
