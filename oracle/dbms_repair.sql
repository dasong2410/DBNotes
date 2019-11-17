--创建表
begin
  dbms_repair.admin_tables
  (
    table_name  =>  'REPAIR_TABLE',
    table_type  =>  dbms_repair.repair_table,
    action      =>  dbms_repair.create_action,
    tablespace  =>  'OUTSIDE'
  );
end;
/

--检查坏块
set serveroutput on
declare
  l_num_corrupt int;
begin
  l_num_corrupt := 0;
  dbms_repair.check_object
  (
    schema_name       =>  'OUTSIDE',
    object_name       =>  'TB_NET_GROUP',
    repair_table_name =>  'REPAIR_TABLE',
    corrupt_count     =>  l_num_corrupt
  );

  dbms_output.put_line('number corrupt: ' || to_char (l_num_corrupt));
end;
/

--修复坏块
set serveroutput on
declare
  l_num_fix int;
begin
  l_num_fix := 0;
  dbms_repair.fix_corrupt_blocks
  (
    schema_name       => 'OUTSIDE',
    object_name       => 'TB_NET_GROUP',
    object_type       => dbms_repair.table_object,
    repair_table_name => 'REPAIR_TABLE',
    fix_count         => l_num_fix
  );

  dbms_output.put_line('num fix: ' || to_char(l_num_fix));
end;
/

--跳过坏块
begin
  dbms_repair.skip_corrupt_blocks
  (
     schema_name  => 'OUTSIDE',
     object_name  => 'TB_NET_GROUP',
     object_type  => dbms_repair.table_object,
     flags        => dbms_repair.skip_flag
  );
end;
/


select object_name, block_id, corrupt_type, marked_corrupt, corrupt_description, repair_description
  from repair_table;

select * from v$database_block_corruption
