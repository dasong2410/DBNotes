alter database add supplemental log data;

--数据字典存在文本文件中
alter system set utl_file_dir='/home/oracle/dict' scope=spfile;

exec dbms_logmnr_d.build('dict.ora', '/home/oracle/dict', options => dbms_logmnr_d.store_in_flat_file);

exec dbms_logmnr.add_logfile(logfilename => '/oradataa/arch/1_248_926416629.dbf', options => dbms_logmnr.new);
exec dbms_logmnr.add_logfile(logfilename => '/oradataa/arch/1_249_926416629.dbf', options => dbms_logmnr.addfile);
exec dbms_logmnr.add_logfile(logfilename => '/oradataa/arch/1_250_926416629.dbf', options => dbms_logmnr.addfile);

exec dbms_logmnr.start_logmnr(dictfilename => '/home/oracle/dict/dict.ora');

select seg_owner, seg_name, operation, sql_redo, sql_undo from v$logmnr_contents;

exec dbms_logmnr.end_logmnr();

--数据字典存在online redo中，包含数据字典的日志必须add进来
exec dbms_logmnr_d.build(options=> dbms_logmnr_d.store_in_redo_logs);

exec dbms_logmnr.add_logfile(logfilename => '/oracle/db/oradata/ora11g/redo01.log', options => dbms_logmnr.new);
exec dbms_logmnr.add_logfile(logfilename => '/oracle/db/oradata/ora11g/redo02.log', options => dbms_logmnr.addfile);
exec dbms_logmnr.add_logfile(logfilename => '/oracle/db/oradata/ora11g/redo03.log', options => dbms_logmnr.addfile);

exec dbms_logmnr.add_logfile(logfilename => '/oradataa/arch/1_50_926416629.dbf', options => dbms_logmnr.addfile);
exec dbms_logmnr.add_logfile(logfilename => '/oradataa/arch/1_51_926416629.dbf', options => dbms_logmnr.addfile);
exec dbms_logmnr.add_logfile(logfilename => '/oradataa/arch/1_52_926416629.dbf', options => dbms_logmnr.addfile);

exec dbms_logmnr.start_logmnr(options => dbms_logmnr.dict_from_redo_logs);

select * from v$logmnr_contents;

exec dbms_logmnr.end_logmnr();

--使用当前数据库数据字典，不需要build
exec dbms_logmnr.add_logfile(logfilename => '/oracle/db/oradata/ora11g/redo01.log', options => dbms_logmnr.new);
exec dbms_logmnr.add_logfile(logfilename => '/oracle/db/oradata/ora11g/redo02.log', options => dbms_logmnr.addfile);
exec dbms_logmnr.add_logfile(logfilename => '/oracle/db/oradata/ora11g/redo03.log', options => dbms_logmnr.addfile);
exec dbms_logmnr.add_logfile(logfilename => '/oradataa/arch/1_50_926416629.dbf', options => dbms_logmnr.addfile);
exec dbms_logmnr.add_logfile(logfilename => '/oradataa/arch/1_51_926416629.dbf', options => dbms_logmnr.addfile);
exec dbms_logmnr.add_logfile(logfilename => '/oradataa/arch/1_52_926416629.dbf', options => dbms_logmnr.addfile);

exec dbms_logmnr.start_logmnr(options => dbms_logmnr.dict_from_online_catalog);

select * from v$logmnr_contents;

exec dbms_logmnr.end_logmnr();
