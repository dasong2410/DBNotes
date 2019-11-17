--创建directory，用来存储要加载的数据
create or replace directory dir_datapump as '/home/oracle/datapump';

--创建外部表
--drop table ext_wxrecord;
create table ext_wxrecord
(
  version     varchar2(20),
  type        varchar2(20),
  dtp         varchar2(255),
  charset1    varchar2(20),
  msgid       varchar2(255),
  groupid     varchar2(255),
  userid      varchar2(255),
  accountname varchar2(255),
  capturetime varchar2(255),
  msgtype     varchar2(255),
  content     clob,
  playlength  varchar2(255),
  length      varchar2(255),
  clientip    varchar2(255),
  mainfile    varchar2(255),
  filename    varchar2(255),
  codeid      varchar2(255)
)
organization external
(
  type oracle_loader
  default directory dir_datapump
  access parameters
  (
    records delimited by newline
    fields terminated by '\t'
    (
      version     char(20),
      type        char(20),
      dtp         char(255),
      charset1    char(20),
      msgid       char(255),
      groupid     char(255),
      userid      char(255),
      accountname char(255),
      capturetime char(255),
      msgtype     char(255),
      content     char(32767),
      playlength  char(255),
      length      char(255),
      clientip    char(255),
      mainfile    char(255),
      filename    char(255),
      codeid      char(255)
    )
  )
  location ('out_put_1000.txt', 'out_put_1001.txt')
);

--从外部表加载数据到普通表，现在的情况是有5台机器按groupid加载数据；
--ora_hash(groupid, 4)的值为0-4，每台机器选取一个值；
--创建的普通表按groupid建128个分区
--
--drop table wxrecord;
create table wxrecord nologging
partition by hash(groupid)
partitions 128
as
select /*+ append */ * from ext_wxrecord a where ora_hash(groupid, 4)=0;

--因为要过滤groupid，groupid又是散乱在每个文件中，所以每台机器上都要导所有的 文本数据 的文件；
--加载到普通的表的时候再过滤，数据不会复入
