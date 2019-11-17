select index_name, partition_name, subpartition_name
  from (select index_name, 'N/A' partition_name, 'N/A' subpartition_name
          from user_indexes
         where status='UNUSABLE'
         union all
        select index_name, partition_name, 'N/A' subpartition_name
          from user_ind_partitions
         where status='UNUSABLE'
         union all
        select index_name, partition_name, subpartition_name
          from user_ind_subpartitions
         where status='UNUSABLE')
 order by index_name, partition_name, subpartition_name;
