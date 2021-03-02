1. 目录1，场景1 sql；目录2，场景2 sql；目录3，场景3 sql
2. exec.sh 执行pgbench
3. stat\_pgb.sh 测试机器显示pgbench cpu、mem 数据（先于 exec.sh 执行）
4. stat\_db.sh 数据库机器显示pg cpu、mem 数据（先于 exec.sh 执行）
5. stat\_calc\_tps.sh 计算 tps、lat 数据（pgbench跑完后执行）

