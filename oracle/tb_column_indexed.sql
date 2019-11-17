select table_name, index_name,
       listagg(column_name || ': ' || descend, ', ') within group(order by column_position) index_cols
  from user_ind_columns
 where table_name like upper('%%')
   and index_name like upper('%%')
 group by table_name, index_name
 order by table_name, index_name;
