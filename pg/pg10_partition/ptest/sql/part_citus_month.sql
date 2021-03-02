------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--                             按月建分区 测试
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
set citus.shard_replication_factor=1;
set citus.next_shard_id to 990000;
set citus.shard_count=2;

-- 创建分区表
drop table if exists tb1 cascade;
create table tb1(c1 int, c2 date, c3 int) partition by range (c2);
select create_distributed_table('tb1', 'c1');

-- 批量增加分区
select rds.add_range_partitions('public.tb1', '2019-03-01'::date, '1 month', 10);

-- 验证分区
select relname, relnamespace::regnamespace::text, pg_get_expr(relpartbound, oid, true) vals
  from pg_class
 where relnamespace::regnamespace::text='public' and relname like 'tb1%' and relispartition=true
 order by relname;

\c - - - :worker_1_port
select relname, relnamespace::regnamespace::text, pg_get_expr(relpartbound, oid, true) vals
  from pg_class
 where relnamespace::regnamespace::text='public' and relname like 'tb1%' and relispartition=true
 order by relname;

\c - - - :worker_2_port
select relname, relnamespace::regnamespace::text, pg_get_expr(relpartbound, oid, true) vals
  from pg_class
 where relnamespace::regnamespace::text='public' and relname like 'tb1%' and relispartition=true
 order by relname;

\c - - - :master_port

-- 插入数据
insert into public.tb1 values(1, '20190301'::date, 1);
insert into public.tb1 values(2, '20190402'::date, 2);
insert into public.tb1 values(3, '20190503'::date, 3);
insert into public.tb1 values(4, '20190604'::date, 4);
insert into public.tb1 values(5, '20190705'::date, 5);
insert into public.tb1 values(6, '20190806'::date, 6);
insert into public.tb1 values(7, '20190907'::date, 7);
insert into public.tb1 values(8, '20191008'::date, 8);
insert into public.tb1 values(9, '20191109'::date, 9);
insert into public.tb1 values(10, '20191210'::date, 10);

-- 验证数据
select * from public.tb1 order by c1;
select * from public.tb1_20190301 order by c1;
select * from public.tb1_20190401 order by c1;
select * from public.tb1_20190501 order by c1;
select * from public.tb1_20190601 order by c1;
select * from public.tb1_20190701 order by c1;
select * from public.tb1_20190801 order by c1;
select * from public.tb1_20190901 order by c1;
select * from public.tb1_20191001 order by c1;
select * from public.tb1_20191101 order by c1;
select * from public.tb1_20191201 order by c1;

-- 分区表添加索引（包含大小写、空格制表符）
select rds.create_idx_on_parted_table('public.TB1', 'idx_tb1', 'create INDEX 	%i on 	%t(c1)');

-- 验证索引
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;
select * from rds.user_tab_part_indexes_def;

\c - - - :worker_1_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :worker_2_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :master_port

-- 分区表添加索引（语法错误）
select rds.create_idx_on_parted_table('public.tb1', 'idx_tb1_e', 'create1 index %i on %t(c1)');

-- 验证索引
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;
select * from rds.user_tab_part_indexes_def;

\c - - - :worker_1_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :worker_2_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :master_port

-- 分区表添加索引（索引名长度超34bytes）
select rds.create_idx_on_parted_table('public.tb1', 'idx_tb12345678901234567890123456789', 'create index %i on %t(c1)');
select rds.create_idx_on_parted_table('public.tb1', 'idx_tb1234567890123456789012345678', 'create index %i on %t(c1)');

-- 验证索引
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;
select * from rds.user_tab_part_indexes_def;

\c - - - :worker_1_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :worker_2_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :master_port

-- 分区表添加索引（主键）
select rds.create_idx_on_parted_table('public.tb1', 'pk_idx_tb1', 'create unique index %i on %t(c1)', true);

-- 验证索引、主键
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;
select * from rds.user_tab_part_indexes_def;
select * from pg_constraint where conname like 'pk_idx_tb1%' order by conname;

\c - - - :worker_1_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;
select * from pg_constraint where conname like 'pk_idx_tb1%' order by conname;

\c - - - :worker_2_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;
select * from pg_constraint where conname like 'pk_idx_tb1%' order by conname;

\c - - - :master_port

-- 分区单独添加索引
create index idx_tb1_test on public.tb1_20190501(c1);

-- 验证索引
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;
select * from rds.user_tab_part_indexes_def;

\c - - - :worker_1_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :worker_2_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :master_port

-- 新增分区补建索引
select rds.add_range_partitions('public.tb1', '2020-01-01'::date, '1 month', 3);

-- 验证分区
select relname, relnamespace::regnamespace::text, pg_get_expr(relpartbound, oid, true) vals
  from pg_class
 where relnamespace::regnamespace::text='public' and relname like 'tb1%' and relispartition=true
 order by relname;

\c - - - :worker_1_port
select relname, relnamespace::regnamespace::text, pg_get_expr(relpartbound, oid, true) vals
  from pg_class
 where relnamespace::regnamespace::text='public' and relname like 'tb1%' and relispartition=true
 order by relname;

\c - - - :worker_2_port
select relname, relnamespace::regnamespace::text, pg_get_expr(relpartbound, oid, true) vals
  from pg_class
 where relnamespace::regnamespace::text='public' and relname like 'tb1%' and relispartition=true
 order by relname;

\c - - - :master_port

-- 验证索引
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;
select * from rds.user_tab_part_indexes_def;

\c - - - :worker_1_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :worker_2_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :master_port

-- 分区单独删除索引
drop index idx_tb1_16849;

-- 验证索引
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;
select * from rds.user_tab_part_indexes_def;

\c - - - :worker_1_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :worker_2_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :master_port

-- 分区表删除索引
select rds.drop_idx_on_parted_table('public.tb1', 'idx_tb1');

-- 验证索引
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;
select * from rds.user_tab_part_indexes_def;

\c - - - :worker_1_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :worker_2_port
select * from pg_indexes where schemaname='public' and tablename like 'tb1%' order by tablename, indexname;

\c - - - :master_port

-- 批量truncate分区
select rds.truncate_range_partitions('public.tb1', '20190301', '20190603');

-- 验证数据
select * from public.tb1 order by c1;

-- ddl下推到分区（前）
select relname, reloptions from pg_class where relname like 'tb1%' order by relname;

\c - - - :worker_1_port
select relname, reloptions from pg_class where relname like 'tb1%' order by relname;

\c - - - :worker_2_port
select relname, reloptions from pg_class where relname like 'tb1%' order by relname;

-- ddl下推到分区（后）
\c - - - :master_port
select rds.run_command_on_parted_table('public.tb1', 'alter table %t set(fillfactor = 90)');
select relname, reloptions from pg_class where relname like 'tb1%' order by relname;

\c - - - :worker_1_port
select relname, reloptions from pg_class where relname like 'tb1%' order by relname;

\c - - - :worker_2_port
select relname, reloptions from pg_class where relname like 'tb1%' order by relname;

\c - - - :master_port

-- 批量删除分区
select rds.drop_range_partitions('public.tb1', '20190301', '20190603');

-- 验证分区
select relname, relnamespace::regnamespace::text, pg_get_expr(relpartbound, oid, true) vals
  from pg_class
 where relnamespace::regnamespace::text='public' and relname like 'tb1%' and relispartition=true
 order by relname;

\c - - - :worker_1_port
select relname, relnamespace::regnamespace::text, pg_get_expr(relpartbound, oid, true) vals
  from pg_class
 where relnamespace::regnamespace::text='public' and relname like 'tb1%' and relispartition=true
 order by relname;

\c - - - :worker_2_port
select relname, relnamespace::regnamespace::text, pg_get_expr(relpartbound, oid, true) vals
  from pg_class
 where relnamespace::regnamespace::text='public' and relname like 'tb1%' and relispartition=true
 order by relname;

\c - - - :master_port

-- ddl带双引号
create table "tb2"(c1 int, c2 date, c3 int) partition by range (c2);

-- 删除分区表
drop table if exists tb1 cascade;
