CREATE CONTROLFILE REUSE DATABASE "ORA11G" RESETLOGS NOARCHIVELOG
    MAXLOGFILES 5
    MAXLOGMEMBERS 3
    MAXDATAFILES 100
    MAXINSTANCES 1
    MAXLOGHISTORY 226
LOGFILE
  GROUP 1 '/oraredo/redo01.log'  SIZE 2G,
  GROUP 2 '/oraredo/redo02.log'  SIZE 2G,
  GROUP 3 '/oraredo/redo03.log'  SIZE 2G
DATAFILE
  '/oracle/ora11/oradata/ora11g/system01.dbf',
  '/oracle/ora11/oradata/ora11g/sysaux01.dbf',
  '/oraundo/undotbs01.dbf',
  '/oracle/ora11/oradata/ora11g/users01.dbf',
  '/oradatab/setnet01.dbf',
  '/oradatab/tbs_mrdata.dbf',
  '/oradatab/tbs_mrindex.dbf'
CHARACTER SET AL32UTF8
;
