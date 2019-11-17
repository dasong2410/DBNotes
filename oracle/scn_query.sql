select checkpoint_change# from v$database;
select file#, checkpoint_change#, last_change#, name from v$datafile;
select file#, checkpoint_change#, name from v$datafile_header;
