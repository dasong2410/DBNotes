begin
  begin
    for l_idx in (select index_name from user_indexes where status='UNUSABLE') loop
      execute immediate 'alter index ' || l_idx.index_name || ' rebuild';
    end loop;
  end;

  begin
    for l_idx in (select index_name, partition_name from user_ind_partitions where status='UNUSABLE') loop
      execute immediate 'alter index ' || l_idx.index_name || ' rebuild partition ' || l_idx.partition_name;
    end loop;
  end;

  begin
    for l_idx in (select index_name, subpartition_name from user_ind_subpartitions where status='UNUSABLE') loop
      execute immediate 'alter index ' || l_idx.index_name || ' rebuild subpartition ' || l_idx.subpartition_name;
    end loop;
  end;
end;
/
