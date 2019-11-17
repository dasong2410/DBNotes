--删除用户（直接删除user$中的数据，用户中的数据等不会被删除，这种情况可能会由断电造成的数据字典中元数据的丢失，但是实际的数据还存在）
--select * from user$ where name='FOX';
delete from user$ where name='FOX';
commit;

--找出上一步删除的用户的user#
select * from seg$ where user# not in(select user# from user$);

--插入一条数据，新增用户
--（以下insert可以把user$中选一条普通用户的数据卖出，然后修改一下user#、name；
--用户名根据实际情况修改；
--password字段如果给null，则可以用之前的密码登录，所以此字段应该是可填可不填）
insert into user$ (user#,name,type#,password,datats#,tempts#,ctime,ptime,exptime,ltime,resource$,audit$,defrole,defgrp#,defgrp_seq#,astatus,lcount,defschclass,ext_username,spare1,spare2,spare3,spare4,spare5,spare6) values (233,'FOX',1,'352636B8F2EB9D65',16,3,to_date('2015-01-27 10:58:30','YYYY-MM-DD HH24:MI:SS'),to_date('2015-01-27 10:58:30','YYYY-MM-DD HH24:MI:SS'),null,null,0,null,1,null,null,0,0,'DEFAULT_CONSUMER_GROUP',null,0,null,null,'S:9A4467E8962B4C438A82769C76A42DD0B1B0D8226C25FF7B4886E19DF486',null,null);
commit;

--修改密码
alter system flush shared_pool;
alter system flush buffer_cache;
alter user fox identified by fox;

--使用新增加的用户登录数据，验证一下数据有没有丢失
--检查一下dba_users中默认表空间等是否正确，如果不正确根据实际情况修改
--alter user fox default tablespace fox;
