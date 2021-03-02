/*
 * when it comes to citus, you just need to execute this script on cn,
 * remember do not run it on wk.
 */

-- drop event trigger if exists etg_ddl_command_start;
-- drop event trigger if exists etg_ddl_command_end;
-- drop view if exists rds.user_tab_part_indexes;
-- drop view if exists rds.user_tab_partitions;
-- drop table if exists rds.user_tab_part_indexes_def;
-- drop function if exists rds.func_ddl_command_start;
-- drop function if exists rds.func_ddl_command_end;
-- drop function if exists rds.create_idx_on_parted_table;
-- drop function if exists rds.func_create_idx_on_paritition;
-- drop function if exists rds.drop_idx_on_parted_table;
-- drop function if exists rds.add_range_partitions;
-- drop function if exists rds.drop_range_partitions;
-- drop function if exists rds.truncate_range_partitions;
-- drop function if exists rds.run_command_on_parted_table;

create schema if not exists rds;

create table if not exists rds.user_tab_part_indexes_def
(
  tab_name  regclass,
  idx_name  varchar,
  idx_sql   text,
  is_pkey   boolean,
  primary key (tab_name, idx_name)
);


-- tab partitions
create or replace view rds.user_tab_partitions
as
select nmsp_parent.nspname                                                    table_schema,
       parent.relname                                                         table_name,
       parent.oid                                                             table_oid,
       nmsp_child.nspname                                                     partition_schema,
       child.relname                                                          partition_name,
       child.oid                                                              partition_oid,
       pg_get_expr(child.relpartbound, child.oid, true)                       vals,
       split_part(pg_get_expr(child.relpartbound, child.oid, true), '''', 2)  partition_dt_f,
       split_part(pg_get_expr(child.relpartbound, child.oid, true), '''', 4)  partition_dt_t
  from pg_inherits inh
  join pg_class parent on inh.inhparent = parent.oid
  join pg_class child on inh.inhrelid = child.oid
  join pg_namespace nmsp_parent on nmsp_parent.oid = parent.relnamespace
  join pg_namespace nmsp_child on nmsp_child.oid = child.relnamespace
 where child.relispartition=true;


--indexes on partitions
create or replace view rds.user_tab_part_indexes
as
select a.*
  from (select a.table_schema, a.table_name, a.partition_name, b.indexname, replace(b.indexname, '_' || a.partition_oid, '') def_idx_name, a.table_oid
           from rds.user_tab_partitions a
           left join pg_indexes b on a.partition_schema=b.schemaname and a.partition_name=b.tablename) a
  left join rds.user_tab_part_indexes_def c on a.table_oid=c.tab_name::oid and a.def_idx_name=c.idx_name;


create or replace function rds.func_ddl_command_start()
returns event_trigger as $$
/*
 * Author : 18101789
 * Date   : 2019.03.13
 * Desc   : 1. disable creating index directly on table partition
 *          2. delete index configurations before dropping a partition table
 */
declare
  pg_call_stack           text;
  l_is_invoked_by_idxfunc int;
  l_schema_name           varchar;
  l_tb_full_name          varchar;
  l_tb_name               varchar;
  l_idx_full_name         varchar;
  l_idx_name              varchar;
  l_is_partition          int;
  l_is_parted_table       int;

  l_myname                varchar;
  l_sql_stat              varchar;
begin
  l_myname := 'func_ddl_command_start';
  raise debug 'My name: %', l_myname;

  GET DIAGNOSTICS pg_call_stack = PG_CONTEXT;
  l_sql_stat := split_part(pg_call_stack, '"' ,2);

  raise debug '% => %', l_myname, tg_tag;

  raise debug '<<==================== stack begin ====================>>';
  raise debug '%', pg_call_stack;
  raise debug '<<==================== stack end   ====================>>';

  if(l_sql_stat='') then
    l_sql_stat := current_query();
  end if;

  -- translate sql to lower case, remove semicolon at the end
  l_sql_stat := lower(l_sql_stat);
  l_sql_stat := split_part(l_sql_stat, ';', 1);

  raise debug '% => sql statement: %', l_myname, l_sql_stat;

  if(position('"' in l_sql_stat)>0) then
    raise exception '%', 'DDL statement can not contain double quotes.';
  end if;

  if(tg_tag='CREATE INDEX') then
    -- extract table name from sql statement
    -- sql format:
    --   <1>. create index idx_test on tb_test(c1)
    --   <2>. create index idx_test on tb_test (c1)
    --   <3>. create index idx_test on tb_test using method(c1)
    l_tb_full_name := regexp_replace(l_sql_stat, '.+(\s+on\s+)([^\s(]+).+', '\2');

    -- l_tb_full_name could include schema name or not
    if(position('.' in l_tb_full_name)>0) then
      l_schema_name := split_part(l_tb_full_name, '.', 1);
      l_tb_name     := split_part(l_tb_full_name, '.', 2);
    else
      l_schema_name := current_schema;
      l_tb_name     := l_tb_full_name;
    end if;

    raise debug '% => schema name: % table name: %', l_myname, l_schema_name, l_tb_name;

    -- check if the table on which you create index is a partition(where table_oid=l_tb_name::regclass::oid)
    select count(1) into l_is_partition from rds.user_tab_partitions where partition_schema=l_schema_name and partition_name=l_tb_name;

    -- if this table is a partition, the only way allowed to create index on it is to invoke func_create_idx_on_paritition.
    if(l_is_partition>0) then
      l_is_invoked_by_idxfunc = position('func_create_idx_on_paritition(text,text)' in pg_call_stack);

      if(l_is_invoked_by_idxfunc=0) then
        raise exception '%', 'Creating an index directly on a table partition is not allowed, please invoke create_idx_on_parted_table to do this.';
      end if;
    end if;
  elsif(tg_tag='DROP TABLE') then
    -- extract table name from sql statement
    -- sql format:
    --   <1>. drop table tb_test
    --   <2>. drop table if exists tb_test
    --   <3>. drop table if exists tb_test cascade/restrict
    l_tb_full_name := regexp_replace(l_sql_stat, '\s*drop\s+table\s+(if\s+exists\s+)?(\S+)(\s+\S+)?', '\2');

    -- l_tb_full_name could include schema name or not
    if(position('.' in l_tb_full_name)>0) then
      l_schema_name := split_part(l_tb_full_name, '.', 1);
      l_tb_name     := split_part(l_tb_full_name, '.', 2);
    else
      l_schema_name := current_schema;
      l_tb_name     := l_tb_full_name;
    end if;

    raise debug '% => schema name: % table name: %', l_myname, l_schema_name, l_tb_name;

    -- check if the table on which you create index is a partition table(where table_oid=l_tb_name::regclass::oid)
    select count(1) into l_is_parted_table from rds.user_tab_partitions where table_schema=l_schema_name and table_name=l_tb_name;

    -- delete index definitions if this table is a partition table
    if(l_is_parted_table>0) then
      delete from rds.user_tab_part_indexes_def where tab_name=l_tb_full_name::regclass;
    end if;
  elsif(tg_tag='DROP INDEX') then
    -- extract index name from sql statement
    -- sql format:
    --   <1>. drop index idx_test
    --   <2>. drop index if exists idx_test
    --   <3>. drop index if exists idx_test cascade/restrict
    l_idx_full_name := regexp_replace(l_sql_stat, '\s*drop\s+index\s+(if\s+exists\s+)?(\S+)(\s+\S+)?', '\2');

    raise debug '% => index full name: %', l_myname, l_idx_full_name;

    -- l_tb_full_name could include schema name or not
    if(position('.' in l_idx_full_name)>0) then
      l_schema_name := split_part(l_idx_full_name, '.', 1);
      l_idx_name    := split_part(l_idx_full_name, '.', 2);
    else
      l_schema_name := current_schema;
      l_idx_name    := l_idx_full_name;
    end if;

    raise debug '% => schema name: % idx name: %', l_myname, l_schema_name, l_idx_name;

    select count(1) into l_is_parted_table from rds.user_tab_partitions where (partition_schema, partition_name) in(select schemaname, tablename from pg_indexes where schemaname=l_schema_name and indexname=l_idx_name);

    raise debug '% => part cnt: % ', l_myname, l_is_parted_table;

    if(l_is_parted_table>0) then
      l_is_invoked_by_idxfunc = position('drop_idx_on_parted_table(regclass,character varying)' in pg_call_stack);

      raise debug '% => invoked via func: % ', l_myname, l_is_invoked_by_idxfunc;

      if(l_is_invoked_by_idxfunc=0) then
        raise exception '%', 'Dropping an index on a table partition directly is not allowed, please invoke drop_idx_on_parted_table to do this.';
      end if;
    end if;
  end if;
end;
$$ language plpgsql;

create event trigger etg_ddl_command_start on ddl_command_start execute procedure rds.func_ddl_command_start();


create or replace function rds.func_ddl_command_end()
returns event_trigger as $$
/*
 * Author : 18101789
 * Date   : 2019.03.13
 * Desc   : 1. create related indexes after adding a partition to a partition table
 */
declare
  pg_call_stack     text;

  l_tb_name         varchar;
  l_part_name       varchar;
  l_idx_name        varchar;
  l_idx             record;
  l_real_idx_sql    text;
  l_pk_sql          text;

  l_myname          varchar;
  l_sql_stat        varchar;
begin
  l_myname := 'func_ddl_command_end';
  raise debug 'My name: %', l_myname;

  GET DIAGNOSTICS pg_call_stack = PG_CONTEXT;
  l_sql_stat := split_part(pg_call_stack, '"' ,2);

  raise debug '% => %', l_myname, tg_tag;

  raise debug '<<==================== stack begin ====================>>';
  raise debug '%', pg_call_stack;
  raise debug '<<==================== stack end   ====================>>';

  if(l_sql_stat='') then
    l_sql_stat := current_query();
  end if;

  -- translate sql to lower case, remove semicolon at the end
  l_sql_stat := lower(l_sql_stat);
  l_sql_stat := split_part(l_sql_stat, ';', 1);

  raise debug '% => sql statement: %', l_myname, l_sql_stat;

  if(position('"' in l_sql_stat)>0) then
    raise exception '%', 'DDL statement can not contain double quotes.';
  end if;

  if(tg_tag='CREATE TABLE' and l_sql_stat~'.+(\s+partition\s+of\s+).+') then
    -- extract table name from curent sql
    -- sql format:
    --   create table tb_test_20190101 partition of tb_test balabala
    l_tb_name := regexp_replace(l_sql_stat, '.+(\s+of\s+)([^\s(]+).+', '\2');
    l_part_name := regexp_replace(l_sql_stat, '.+(\s+table\s+)([^\s]+)(\s+partition\s+of\s+).+', '\2');

    raise debug 'table name: % - partition name:%', l_tb_name, l_part_name;

    if(l_tb_name!='' and l_part_name!='') then
      for l_idx in select * from rds.user_tab_part_indexes_def where tab_name=l_tb_name::regclass loop
        l_idx_name     := l_idx.idx_name || '_' || l_part_name::regclass::oid;
        l_real_idx_sql := replace(l_idx.idx_sql, '%i', l_idx_name);
        l_real_idx_sql := replace(l_real_idx_sql, '%t', l_part_name);

        -- primary key based on this index
        if(l_idx.is_pkey) then
          l_pk_sql :=create_idx_on_parted_table 'alter table ' || l_part_name || ' add constraint ' || l_idx_name || ' primary key using index ' || l_idx_name;
        end if;

        perform rds.func_create_idx_on_paritition(l_real_idx_sql, l_pk_sql);

        raise debug '% => %', l_myname, l_real_idx_sql;
      end loop;
    end if;
  end if;
end;
$$ language plpgsql;

create event trigger etg_ddl_command_end on ddl_command_end execute procedure rds.func_ddl_command_end();


create or replace function rds.func_create_idx_on_paritition
(
  p_idx_sql   text,
  p_pk_sql    text
)
returns void as $$
/*
 * Author : 18101789
 * Date   : 2019.03.13
 * Desc   : 1. create index on partition, actually this function is just a flag, which will be checked in trigger func_ddl_command_start.
               The trigger will reject index creation on table partition if the call stack doesn't contain this function.
 *
 * params : p_idx_sql  => create index sql statement
 */
declare
  l_myname varchar;
begin
  l_myname := 'func_create_idx_on_paritition';
  raise debug 'My name: %', l_myname;

  raise debug '% => %', l_myname, p_idx_sql;

  execute p_idx_sql;

  -- add primary key
  if(p_pk_sql!='') then
    execute p_pk_sql;
  end if;
end;
$$ language plpgsql;


create or replace function rds.create_idx_on_parted_table
(
  p_tab_name  regclass,
  p_idx_name  varchar,
  p_idx_sql   text,
  p_is_pkey   boolean default false
)
returns table(sql text, status text, result text) as $$
/*
 * Author : 18101789
 * Date   : 2019.03.13
 * Desc   : 1. create index on partition table
 *
 * params : p_tab_name => partition table name, format: schema_name.tab_name
 *          p_idx_name => index name
 *          p_idx_sql  => format: create index %i on %t (c1)
 *          p_is_pkey  => if need to create primary key on this index
 */
declare
  l_part_info     record;
  l_part_name     varchar;
  l_idx_name      varchar;
  l_real_idx_sql  text;
  l_idx_sql       text;
  l_pk_sql        text;
  l_ret           text;

  l_idx_cnt       int := 1;
  l_idx_err_cnt   int := 1;

  l_myname        varchar;
begin
  l_myname := 'create_idx_on_parted_table';
  raise debug 'My name: %', l_myname;

  -- index name could not be more than 34 bytes
  -- oid = an unsigned four-byte integer => max value = 4294967295 => 10 chars => 10 bytes
  -- shardid = bigint(signed eight-byte integer) => max value = (-9223372036854775808 to +9223372036854775807) => 19 chars => 19 bytes
  -- 63 - 10 - 19 = 34
  if(bit_length(p_idx_name)/8>34) then
    raise exception 'The length of index name could not be more than 34 bytes, table name: % index name: %', p_tab_name, p_idx_name;
  end if;

  -- if the index already exists and it has a different ddl, raise an exception.
  -- need deal with p_is_pkey
  select idx_sql into l_idx_sql from rds.user_tab_part_indexes_def where tab_name=p_tab_name and idx_name=p_idx_name;

  if(l_idx_sql!='' and l_idx_sql!=lower(p_idx_sql)) then
    raise exception 'Index % on table % already exists, sql: %', p_idx_name, p_tab_name, l_idx_sql;
  end if;

  for l_part_info in select * from rds.user_tab_partitions where table_oid=p_tab_name loop
    raise debug '% => %', l_myname, l_part_info.partition_name;

    l_idx_cnt := l_idx_cnt+1;

    l_idx_name := p_idx_name || '_' || l_part_info.partition_oid::text;
    l_part_name  := l_part_info.partition_schema || '.' || l_part_info.partition_name;

    -- primary key based on this index
    if(p_is_pkey) then
      l_pk_sql := 'alter table ' || l_part_name || ' add constraint ' || l_idx_name || ' primary key using index ' || l_idx_name;
    else
      l_pk_sql := '';
    end if;

    l_real_idx_sql := replace(p_idx_sql, '%i', l_idx_name);
    l_real_idx_sql := replace(l_real_idx_sql, '%t', l_part_name);
    l_real_idx_sql := $x$select rds.func_create_idx_on_paritition('$x$ || l_real_idx_sql || $x$','$x$ || l_pk_sql || $x$')$x$;

    raise debug '% => %', l_myname, l_real_idx_sql;

    begin
      select * into l_ret from dblink('host=127.1 port=' || inet_server_port() || ' dbname=' || current_database() || ' user=' || current_user, l_real_idx_sql, true) as t1 (c1 text);

      return query select l_real_idx_sql, 'success', '';
    exception
      when duplicate_table then
        return query select l_real_idx_sql, 'warning', SQLERRM;
      when others then
        l_idx_err_cnt = l_idx_err_cnt+1;
        return query select l_real_idx_sql, 'error', SQLERRM;
    end;

    -- save index ddl
    -- 1. l_idx_cnt=0: no partition exists when creating index
    -- 2. l_idx_cnt>0 and l_idx_cnt!=l_idx_err_cnt: not all creating index on partitions failed
    if(l_idx_cnt=0 or (l_idx_cnt>0 and l_idx_cnt!=l_idx_err_cnt)) then
      insert into rds.user_tab_part_indexes_def(tab_name, idx_name, idx_sql, is_pkey) values(p_tab_name, p_idx_name, lower(p_idx_sql), p_is_pkey) on conflict do nothing;
    end if;
  end loop;
end;
$$ language plpgsql;


create or replace function rds.drop_idx_on_parted_table
(
  p_tab_name  regclass,
  p_idx_name  varchar
)
returns void as $$
/*
 * Author : 18101789
 * Date   : 2019.03.13
 * Desc   : 1. drop index on partition table
 *
 * params : p_tab_name => partition table name, format: schema_name.tab_name
 *          p_idx_name => index name without relid
 */
declare
  l_idx_info     record;
  l_real_idx_sql  text;

  l_myname        varchar;
begin
  l_myname := 'drop_idx_on_parted_table';
  raise debug 'My name: %', l_myname;

  for l_idx_info in select * from rds.user_tab_part_indexes where table_oid=p_tab_name::oid and def_idx_name=p_idx_name loop
    l_real_idx_sql := 'drop index if exists ' || l_idx_info.indexname || ' cascade';

    raise debug '% => %', l_myname, l_real_idx_sql;

    execute l_real_idx_sql;
  end loop;

  delete from rds.user_tab_part_indexes_def where tab_name=p_tab_name and idx_name=p_idx_name;
end;
$$ language plpgsql;

create or replace function rds.add_range_partitions
(
  p_tab_name    regclass,
  p_start_date  date,
  p_interval    varchar,
  p_part_cnt    int
)
returns void as $$
/*
 * Author : 18101789
 * Date   : 2019.03.13
 * Desc   : 1. add partitions to a partition table
 *
 * params : p_tab_name    => partition table name, format: schema_name.tab_name
 *          p_start_date  => first partition
 *          p_interval    => partition time span, etc. '1 day', '1 month'...
 *          p_part_cnt    => partition quantity you wanna add
 */
declare
  l_part_sql    text;
  l_part_name   varchar;
  l_from_val    varchar;
  l_to_val      varchar;

  l_pattern     varchar;

  l_myname      varchar;
begin
  l_myname := 'add_range_partitions';
  raise debug 'My name: %', l_myname;

  l_pattern := 'YYYYMMDD';

  for i in 0..p_part_cnt-1 loop
    l_part_name := p_tab_name || '_' || to_char(p_start_date + p_interval::interval*i, l_pattern);
    l_from_val  := to_char(p_start_date+p_interval::interval*i, l_pattern);
    l_to_val    := to_char(p_start_date+p_interval::interval*(i+1), l_pattern);

    raise debug 'partition name: % from val: % to val: %', l_part_name, l_from_val, l_to_val;

    l_part_sql := 'create table ' || l_part_name || ' partition of ' || p_tab_name || ' for values from (''' || l_from_val || ''') to (''' || l_to_val || ''')';

    raise debug '%', l_part_sql;

    execute l_part_sql;
  end loop;
end;
$$ language plpgsql;

create or replace function rds.drop_range_partitions
(
  p_tab_name    regclass,
  p_start_date  date,
  p_end_date    date,
  p_del_type    varchar default 'drop'
)
returns void as $$
/*
 * Author : 18101789
 * Date   : 2019.03.13
 * Desc   : 1. drop partitions of a partition table
 *          2. truncate partitions of a partition table
 *
 * params : p_tab_name    => partition table name, format: schema_name.tab_name
 *          p_start_date  => first partition
 *          p_end_date    => last partition
 *          p_del_type    => drop or truncate partition, valid values: drop, truncate
 */
declare
  l_part_sql  text;
  l_part_info record;
  l_del_type  varchar;
  l_del_opt  varchar;

  l_myname    varchar;
begin
  l_myname := 'drop_range_partitions';
  raise debug 'My name: %', l_myname;

  l_del_type=lower(p_del_type);

  if(l_del_type='drop') then
    l_del_opt=' cascade';
  elsif(l_del_type='truncate') then
    l_del_opt='';
  else
    raise exception 'The value of l_del_type is invalid: %, it must be drop/truncate.', l_del_type;
  end if;

  for l_part_info in select * from rds.user_tab_partitions
                      where table_oid=p_tab_name::oid
                        and (partition_dt_f::date >= p_start_date and partition_dt_t::date-interval '1 day' <= p_end_date) loop
    l_part_sql := l_del_type || ' table ' || l_part_info.partition_oid::regclass::text || l_del_opt;

    raise debug '%', l_part_sql;

    execute l_part_sql;
  end loop;
end;
$$ language plpgsql;

create or replace function rds.truncate_range_partitions
(
  p_tab_name    regclass,
  p_start_date  date,
  p_end_date    date
)
returns void as $$
/*
 * Author : 18101789
 * Date   : 2019.03.13
 * Desc   : 1. truncate partitions of a partition table
 *
 * params : p_tab_name    => partition table name, format: schema_name.tab_name
 *          p_start_date  => first partition
 *          p_end_date    => last partition
 */
declare
  l_part_sql  text;
  l_part_info record;
  l_del_type  varchar;
  l_del_opt  varchar;

  l_myname    varchar;
begin
  l_myname := 'truncate_range_partitions';
  raise debug 'My name: %', l_myname;

  perform rds.drop_range_partitions(p_tab_name, p_start_date, p_end_date, 'truncate');
end;
$$ language plpgsql;

create or replace function rds.run_command_on_parted_table
(
  p_tab_name    regclass,
  p_cmd_sql     varchar
)
returns table(sql text, status text, result text) as $$
/*
 * Author : 18101789
 * Date   : 2019.03.13
 * Desc   : 1. run command on table's partitions
 *
 * params : p_tab_name    => partition table name, format: schema_name.tab_name
 *          p_cmd_sql     => sql ran on partitions, format: alter table %t set(fillfactor = 90)
 */
declare
  l_cmd_sql  text;
  l_part_info record;

  l_myname    varchar;
begin
  l_myname := 'run_command_on_parted_table';
  raise debug 'My name: %', l_myname;

  for l_part_info in select * from rds.user_tab_partitions where table_oid=p_tab_name::oid loop
    l_cmd_sql := replace(p_cmd_sql, '%t', l_part_info.partition_oid::regclass::text);

    raise debug '%', l_cmd_sql;

    begin
      execute l_cmd_sql;

      return query select l_cmd_sql, 'success', '';
    exception
      when others then
        return query select l_cmd_sql, 'error', SQLERRM;
    end;
  end loop;
end;
$$ language plpgsql;
