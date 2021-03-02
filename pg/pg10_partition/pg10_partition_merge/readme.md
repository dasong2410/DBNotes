## 分区合并

注：

在分区合并后，原分区没有删除，而是rename成 **原表名_de** 结尾的表，需要删除时可自行删除


### 1. 修改 gen_merge_parts_sqlfile.sql 中变量值

将一下 3 个变量修改成实际需要的值

	// 主表名
	l_tab_name      varchar   := 'tb1';

	// 开始日期
	l_start_date    date      := '20190301'::date;

	// 结束日期
	l_end_date      date      := '20190303'::date;


### 2. 生成合并分区 sql 文件

数据库库连接信息跟进实际情况修改，执行 psql 后会在生成文件 /tmp/merge_parts.sql

	psql "service=admin dbname=app_db" -f gen_merge_parts_sqlfile.sql


### 3. 执行合并分区 sql 文件

数据库连接信息同上一步

	psql "service=admin dbname=app_db" -f /tmp/merge_parts.sql
