select from master_add_node('localhost', :worker_1_port);
select from master_add_node('localhost', :worker_2_port);

set citus.shard_replication_factor=1;
set citus.next_shard_id to 990000;
set citus.shard_count=2;

create extension if not exists dblink;

\ir ../pg10_partition.sql
