-- 各数据库 sql 函数等对比

1. 获取当前日期
oracle     : select trunc(sysdate, 'DD') from dual;
mysql      : select current_date;
sql server : select cast(getdate() as date);

2. 生成序列
oracle     : select rownum rn from dual connect by rownum<100;
mysql      : with recursive int_seq (idx) as
                   (
                       select 1
                       union all
                       select idx + 1
                       from int_seq
                       where idx < 100
                   )
             select *
             from int_seq;
sql server :
