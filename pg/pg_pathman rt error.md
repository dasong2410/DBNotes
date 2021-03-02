版本：1.4.9

## 1. rt命令
make installcheck USE_PGXS=1

## 2. 问题

1. pg\_pathman 放到 shared\_preload\_libraries 的第二个(shared\_preload\_libraries = 'citus,pg_pathman,pg_stat_statements,auth_delay') pathman rt 测试报以下错，放到最后(shared\_preload\_libraries = 'citus,pg_stat_statements,auth_delay,pg_pathman')不报报错； pg_pathman 要放到 pg_stat_statements 以后，可能这两个插件有冲突

		2019-02-21 11:53:30.574 CST 11199 [local] postgres contrib_regression pg_regress/pathman_cte HINT:  pg_pathman should be the last extension listed in "shared_preload_libraries" GUC in order to prevent possible conflicts with other extensions 
