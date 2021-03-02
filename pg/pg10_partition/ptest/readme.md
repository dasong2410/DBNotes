
### 回归测试命令

在 ptest 目录下执行

	make -C . check-citus/check-pg

在其它目录下执行（-C 后写实际目录名）

	make -C /tmp/pg10_partition/ptest check-citus/check-pg
