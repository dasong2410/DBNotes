accept fno varchar2(512) prompt '请输入要恢复的数据文件号：'
set verify off;
set serveroutput on;

declare
  l_dev       varchar2(50);   -- device type allocated for restore
  l_done      boolean;        -- has the controlfile been fully extracted yet
  l_new_fname varchar2(1024); -- 恢复生成的数据文件名（包含路径）
  l_fdir      varchar2(1024);
  l_fno       number(32);
begin
  --根据实际目录修改
  l_fdir      := '/oradataa';
  l_fno       := &&fno;
  l_new_fname := l_fdir || '/dbf_&&fno..dbf';
  
  dbms_output.put_line('Start restore...' || chr(10) || '  file#: ' || l_fno || chr(10) || '  data file: ' || l_new_fname);
  -- Allocate a device. In this example, I have specified 'sbt_tape' as I am
  -- reading backuppieces from the media manager. If the backuppiece is on disk,
  -- specify type=>null
  l_dev := dbms_backup_restore.deviceallocate(type=>null, ident=>'fhodb');
  
  -- Begin the restore conversation
  dbms_backup_restore.restoresetdatafile;
  dbms_backup_restore.restoredatafileto(dfnumber=>l_fno, toname=>l_new_fname);
  
  for f in(select a.file#, b.handle
             from v$backup_datafile a, v$backup_piece b
            where a.set_count=b.set_count
              and b.handle is not null
              and a.file#=l_fno) loop
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
  
  dbms_output.put_line('Done...');
end prc_backup_restore;
/

set verify on;
set serveroutput off;
