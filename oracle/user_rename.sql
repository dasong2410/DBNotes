--最好不要操作
update user$ set name='KEYWORD' where name='FHNSDB';
commit;

alter system flush shared_pool;
alter system flush buffer_cache;
alter user keyword identified by keyword;

--修复用户名可能会导致job失效
