with a as(select name, object_type, listagg(column_name, ', ') within group(order by column_position) part_cols from user_part_key_columns where object_type='TABLE' group by name, object_type),
     b as(select name, object_type, listagg(column_name, ', ') within group(order by column_position) subpart_cols from user_subpart_key_columns where object_type='TABLE' group by name, object_type),
     c as(select a.name, a.part_cols, b.subpart_cols from a,b where a.name=b.name(+) and a.object_type=b.object_type(+)),
     d as(select table_name, partitioning_type, subpartitioning_type, status, def_tablespace_name from user_part_tables)
select d.table_name, d.partitioning_type, c.part_cols, d.subpartitioning_type, c.subpart_cols, d.status, d.def_tablespace_name
  from c,d
 where c.name=d.table_name
   and d.table_name like upper('%%')
 order by d.table_name;
