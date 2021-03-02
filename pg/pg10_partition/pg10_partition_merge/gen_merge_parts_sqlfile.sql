do $$
declare
  l_tab_name      varchar   := 'tb1';
  l_start_date    date      := '20190301'::date;
  l_end_date      date      := '20190303'::date;

  l_part_sql      text;
  l_part_name     varchar;
  l_part_info     record;
  l_new_part_name varchar;
  l_tmp_part_name varchar;
  l_f_val         varchar;
  l_t_val         varchar;
  l_part_cnt      int       := 0;
begin
  raise info 'Params => table name: % - start date: % - end date: %', l_tab_name, l_start_date, l_end_date;

  select min(partition_dt_f) f_val,
         max(partition_dt_t) t_val,
         count(1) into l_f_val, l_t_val, l_part_cnt
    from rds.user_tab_partitions
   where table_oid=l_tab_name::regclass::oid
     and (partition_dt_f::date >= l_start_date and partition_dt_t::date-interval '1 day' <= l_end_date);

  raise info 'Params => from value: % - to value: % - part cnt: %', l_f_val, l_t_val, l_part_cnt;

  if (l_part_cnt<2) then
    raise exception '%', 'No partitions need to be merged.';
  end if;

  l_new_part_name := l_tab_name || '_' || replace(l_f_val, '-', '');
  l_tmp_part_name := l_tab_name || '_' || replace(l_f_val, '-', '') || '_000000';

  l_part_sql := 'create table ' || l_tmp_part_name || ' partition of ' || l_tab_name || ' for values from (''91020101'') to (''91021231'');';
  execute format($f$COPY (select $x$%s$x$) TO '/tmp/merge_parts.sql';$f$, l_part_sql);
  raise info '%', l_part_sql;

  l_part_sql := 'alter table ' || l_tab_name || ' detach partition ' || l_tmp_part_name || ';';
  execute format($f$COPY (select $x$%s$x$) TO program 'cat >> /tmp/merge_parts.sql';$f$, l_part_sql);
  raise info '%', l_part_sql;

  for l_part_info in select * from rds.user_tab_partitions
                       where table_oid=l_tab_name::regclass::oid
                         and (partition_dt_f::date >= l_start_date and partition_dt_t::date-interval '1 day' <= l_end_date) loop
    l_part_name := l_part_info.partition_oid::regclass::text;

    l_part_sql := 'alter table ' || l_part_info.table_oid::regclass::text || ' detach partition ' || l_part_name || ';';
    execute format($f$COPY (select $x$%s$x$) TO program 'cat >> /tmp/merge_parts.sql';$f$, l_part_sql);
    raise info '%', l_part_sql;

    l_part_sql := 'alter table ' || l_part_info.partition_oid::regclass::text || ' rename to ' || l_part_name || '_de;';
    execute format($f$COPY (select $x$%s$x$) TO program 'cat >> /tmp/merge_parts.sql';$f$, l_part_sql);
    raise info '%', l_part_sql;

    l_part_sql := 'insert into ' || l_tmp_part_name || ' select * from ' || l_part_name || '_de;';
    execute format($f$COPY (select $x$%s$x$) TO program 'cat >> /tmp/merge_parts.sql';$f$, l_part_sql);
    raise info '%', l_part_sql;
  end loop;

  l_part_sql := 'alter table ' || l_tmp_part_name || ' rename to ' || l_new_part_name || ';';
  execute format($f$COPY (select $x$%s$x$) TO program 'cat >> /tmp/merge_parts.sql';$f$, l_part_sql);
  raise info '%', l_part_sql;

  l_part_sql := 'alter table ' || l_tab_name || ' attach partition ' || l_new_part_name || ' for values from(''' || l_f_val || ''') to(''' || l_t_val || ''');';
  execute format($f$COPY (select $x$%s$x$) TO program 'cat >> /tmp/merge_parts.sql';$f$, l_part_sql);
  raise info '%', l_part_sql;
end;
$$ language plpgsql;
