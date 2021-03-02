# PostgreSql学习笔记
## 1. pg_basebackup 参数
	pg_basebackup -F t -X f -c fast
	-F format
	p plain
	t tar

	-X method
	n
	none
	Don't include write-ahead log in the backup.
	
	f
	fetch
	The write-ahead log files are collected at the end of the backup. Therefore, it is necessary for
	the wal_keep_segments parameter to be set high enough that the log is not removed before
	the end of the backup. If the log has been rotated when it's time to transfer it, the backup
	will fail and be unusable.
	The write-ahead log files will be written to the base.tar file.
	
	s
	stream
	Stream the write-ahead log while the backup is created. This will open a second connection
	to the server and start streaming the write-ahead log in parallel while running the backup.
	Therefore, it will use up two connections configured by the max_wal_senders parameter. As
	long as the client can keep up with write-ahead log received, using this mode requires no
	extra write-ahead logs to be saved on the master.
	The write-ahead log files are written to a separate file named pg_wal.tar (if the server is
	a version earlier than 10, the file will be named pg_xlog.tar).
	This value is the default.
	
	-c fast|spread
	--checkpoint=fast|spread
	Sets checkpoint mode to fast (immediate) or spread (default) (see Section 25.3.3).
	
	spread: the I/O required for the checkpoint will be spread out over a significant period of time
	fast: an immediate checkpoint using as much I/O as available
	
	By default, pg_start_backup can take a long time to finish. This is because it performs a checkpoint,
	and the I/O required for the checkpoint will be spread out over a significant period of time,
	by default half your inter-checkpoint interval (see the configuration parameter checkpoint_completion_
	target). This is usually what you want, because it minimizes the impact on query processing.
	If you want to start the backup as soon as possible, change the second parameter to true, which
	will issue an immediate checkpoint using as much I/O as available.

## 2. PostgreSQL template database
	template0 不允许修改，不允许连接；
	template1 允许修改、连接，如果做了修改，则新创建的数据库会包含这些修改的内容；
	
	create database默认以template1作为种子数据库，如果需要使用其它template，可以在sql中指定，如下：
	  CREATE DATABASE dbname TEMPLATE template0;
	
	通过template创建数据库时，template上不能存在connect，也不允许新的connect，所以这种方法暂时还不能作为copy database的工具

## 3. Citus
	citus extension是数据库级别的，不是cluster级别的
	cn、wk上使用到的 dbname 要保持一致

## 4. pgbench
	pgbench -n "service=admin dbname=app_db" -c 20 -T 10000 -r -f memleak.sql
	
	-n         Perform no vacuuming before running the test.
	-c clients Number of clients simulated
	-T seconds Run the test for this many seconds
	-r         Report the average per-statement latency (execution time from the perspective of the client) of each command after the benchmark finishes

#
	valgrind --leak-check=yes --gen-suppressions=all --time-stamp=yes --log-file=/tmp/dasong/%p.log --trace-children=yes --track-origins=yes --read-var-info=yes --show-leak-kinds=all -v postgres -D /pgsql/citus/coordinator/ -p 9700 --log_line_prefix="%m %p " --log_statement=all --shared_buffers=2GB
	valgrind --leak-check=full --gen-suppressions=all --time-stamp=yes --log-file=/tmp/dasong/%p.log --trace-children=yes --track-origins=yes --read-var-info=yes --show-leak-kinds=all -v postgres -D /pgsql/citus/coordinator/ -p 9700 --log_line_prefix="%m %p " --log_statement=all --shared_buffers=4GB

## 5. iperf
	iperf -i 10 -s
	iperf -i 10 -w 1M -t 60 -c 10.37.64.55
	iperf -mc 10.37.64.55
	
	Client/Server:
	  -f, --format    [kmKM]   format to report: Kbits, Mbits, KBytes, MBytes
	  -i, --interval  #        seconds between periodic bandwidth reports
	  -l, --len       #[KM]    length of buffer to read or write (default 8 KB)
	  -m, --print_mss          print TCP maximum segment size (MTU - TCP/IP header)
	  -o, --output    <filename> output the report or error message to this specified file
	  -p, --port      #        server port to listen on/connect to
	  -u, --udp                use UDP rather than TCP
	  -w, --window    #[KM]    TCP window size (socket buffer size)
	  -B, --bind      <host>   bind to <host>, an interface or multicast address
	  -C, --compatibility      for use with older versions does not sent extra msgs
	  -M, --mss       #        set TCP maximum segment size (MTU - 40 bytes)
	  -N, --nodelay            set TCP no delay, disabling Nagle's Algorithm
	  -V, --IPv6Version        Set the domain to IPv6
	
	Server specific:
	  -s, --server             run in server mode
	  -U, --single_udp         run in single threaded UDP mode
	  -D, --daemon             run the server as a daemon

## 6. pg_pathman
	给表赋权限不会级联到已存在的分区，新添加的分区可以继承表已存在的权限

## 996. shell
	解压rpm文件
	rpm2cpio test.rpm | cpio -idmv
	
	释放内存cache
	echo 3 > /proc/sys/vm/drop_caches
	
	清理swap
	swapoff -a && swapon -a

	# 查看单进程top内容
	top -c -b -p $(cat /tmp/test.pid) | tee -a /tmp/cc.log

	# 去掉文件末尾的 逗号
	for i in `ls *.csv`; do sed 's/,$//' $i > xx/${i}; done

	# top 单个进程	
	top -c -b -p $(cat /tmp/test.pid) | tee -a /tmp/cc.log

	添加删除虚拟IP，需要arping一下才能生效
	ip addr del 10.37.210.121/24 dev bond0
	ip addr add 10.37.210.121/32 dev bond0
	arping -U -I dev -s ipAddr gateway -c 5
	arping -U -I bond0 -s 10.37.210.121 10.37.210.126 -c 5

## 997. sql
	show citus.shard_count;
	show citus.version;
	show citus.max_intermediate_result_size;

	copy (select pg_backend_pid()) to '/tmp/test.pid';

	select version();
	postgresql -V

	alter system reset wal_keep_segments;

	select * from pg_extension;
	select * from pg_available_extensions;

	select * from pg_stat_progress_vacuum;
	select * from pg_file_settings;
	select * from pg_settings;

	# 生成序列数
	select * from generate_series(1, 2000, 1);

	# 获取表 schema 名
	select relnamespace::regnamespace::text from pg_catalog.pg_class where oid = 'tb1'::regclass::oid;

	select 'drop table ' || tablename || ';' from pg_tables where tablename like 'tb1_%';
	select 'select * from ' || tablename || ' union all' from pg_tables where tablename like 'tb1_%';

	copy scprs_log4dlvycmd2los from '/pgsql/dasong/csv/xx/DEP2018122100059.164007.669.csv' with (format csv, header true, QUOTE '"', null '(null)', FORCE_NULL(modify_date));

## 998. 创建Citus单机集群
	创建数据库目录
	sudo su - postgres
	export PATH=$PATH:/usr/pgsql-10/bin
	cd ~
	mkdir -p citus/coordinator citus/worker1 citus/worker2
	
	创建数据库
	initdb -D citus/coordinator
	initdb -D citus/worker1
	initdb -D citus/worker2

	配置预加载citus extension
	echo "shared_preload_libraries = 'citus'" >> citus/coordinator/postgresql.conf
	echo "shared_preload_libraries = 'citus'" >> citus/worker1/postgresql.conf
	echo "shared_preload_libraries = 'citus'" >> citus/worker2/postgresql.conf

	关闭pg
	pg_ctl stop -D citus/coordinator/
	pg_ctl stop -D citus/worker1/
	pg_ctl stop -D citus/worker2/

	启动pg
	pg_ctl -D citus/coordinator -o "-p 9700" -l citus/coordinator_logfile start
	pg_ctl -D citus/worker1 -o "-p 9701" -l citus/worker1_logfile start
	pg_ctl -D citus/worker2 -o "-p 9702" -l citus/worker2_logfile start

	重启pg
	pg_ctl -D citus/coordinator -o "-p 9700" -l citus/coordinator_logfile restart
	pg_ctl -D citus/worker1 -o "-p 9701" -l citus/worker1_logfile restart
	pg_ctl -D citus/worker2 -o "-p 9702" -l citus/worker2_logfile restart

	创建extension
	psql -p 9700 -c "create extension citus;"
	psql -p 9701 -c "create extension citus;"
	psql -p 9702 -c "create extension citus;"

	添加worker
	psql -p 9700 -c "SELECT * from master_add_node('localhost', 9701);"
	psql -p 9700 -c "SELECT * from master_add_node('localhost', 9702);"
	psql -p 9700 -c "select * from master_get_active_worker_nodes();"

#
	更新、删除extension
	psql -p 9700 -c "alter extension citus update;"
	psql -p 9701 -c "alter extension citus update;"
	psql -p 9702 -c "alter extension citus update;"

	psql -p 9700 -c "drop extension citus cascade;"
	psql -p 9701 -c "drop extension citus cascade;"
	psql -p 9702 -c "drop extension citus cascade;"

#
	创建扩展worker
	citus.replication_model = streaming

	select start_metadata_sync_to_node('host_name', port);

	取消扩展worker
	select stop_metadata_sync_to_node('host_name', port);

#
	start_metadata_sync_to_node 同步元数据到worker；
	同步后worker角色为 扩展worker，具有cn的作用可以接受连接请求，但不能执行ddl；
	pg_dist_node 表中字段 hasmetadata=t 表示扩展worker；
	扩展worker不支持 smallserial，serial 字段类型，但是支持 bigserial，各 扩展worker 上的bigserial的起始值不同，没有使用的意义

## 999. Miscellaneous
	pg没有page（block）级别的恢复，只能数据库级别的恢复，如果有坏块的话比较不好解决，只能全库恢复或是切换到备库；
	
	编译CitusDB需要设置 PG_CONFIG 变量
	export PG_CONFIG=/usr/pgsql/bin/pg_config
	
	编译pg
	./configure --prefix=/usr/pgsql

	从srpm编译pg
	rpmbuild --rebuild -D 'pgmajorversion 10' postgresql10-10.7-1PGDG.rhel7.src.rpm
	
	安装pg_pathman
	make PG_CONFIG=/usr/pgsql/bin/pg_config install USE_PGXS=1
	
	启动pg指定socket文件目录
	pg_ctl -o "-k /tmp"
	
	pgbench -n -T 1000 -r -f  test.sql
	pgbench -n -T 10000 -r -f  test.sql -p 9700 -c 10
	pgbench -n "service=admin dbname=lobadbw3" -T 100 -r -f  test.sql
	
	watch "ps auxw|grep local |grep postgres|grep -v grep | tee -a test.log"
	
	watch -n 20 "date | tee -a free.log ; free -m | tee -a free.log ; echo "" | tee -a free.log"
	top -c -b -d 10 -p 15580 | tee -a top.log
	