--flush sga components
alter system flush buffer_cache;
alter system flush shared_pool;
alter system flush global context;
