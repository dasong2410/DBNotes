--创建恢复dbf的存储过程，每次只恢复指定的数据文件
create or replace procedure prc_backup_restore
(
  p_fno   number,   -- file#
  p_fdir  varchar2  -- 生成的文件放在些目录下
)
as
  l_dev       varchar2(50);   -- device type allocated for restore
  l_done      boolean;        -- has the controlfile been fully extracted yet
  l_new_fname varchar2(1024); -- 恢复生成的数据文件名（包含路径）
begin
  l_new_fname := p_fdir || '/dbf_' || p_fno || '.dbf';
  
  dbms_output.put_line('Start restore: file#->' || p_fno || ' dest file->' || l_new_fname);
  -- Allocate a device. In this example, I have specified 'sbt_tape' as I am
  -- reading backuppieces from the media manager. If the backuppiece is on disk,
  -- specify type=>null
  l_dev := dbms_backup_restore.deviceallocate(type=>null, ident=>'fhodb');
  
  -- Begin the restore conversation
  dbms_backup_restore.restoresetdatafile;
  dbms_backup_restore.restoredatafileto(dfnumber=>p_fno, toname=>l_new_fname);
  
  for f in(select a.file#, b.handle
             from v$backup_datafile a, v$backup_piece b
            where a.set_count=b.set_count
              and b.handle is not null
              and a.incremental_level is null
              and a.file#=p_fno) loop
    begin
      dbms_backup_restore.restorebackuppiece(done=>l_done, handle=>f.handle, params=>null);
      
--      if(l_done) then
--        break;
--      end if;
    exception
      when others then
        dbms_output.put_line(sqlerrm);
    end;
  end loop;
  
  dbms_backup_restore.devicedeallocate;
end prc_backup_restore;
/
