--创建kv表
drop table t_test_kv;
create table t_test_kv
(
  name varchar2(34),
  subject varchar2(34),
  score number
);

insert into t_test_kv values('dasong1', '语文', 56);
insert into t_test_kv values('dasong1', '数学', 50);
insert into t_test_kv values('dasong1', '英语', 80);
insert into t_test_kv values('dasong2', '语文', 45);
insert into t_test_kv values('dasong2', '数学', 76);
insert into t_test_kv values('dasong2', '英语', 90);
commit;

--pivot，行转列
select * from t_test_kv;
select * from t_test_kv pivot(max(score) for subject in ('语文' as zh, '数学' as math, '英语' as en));

--创建列表
drop table t_test_col;
create table t_test_col
(
  name varchar2(34),
  zh   number,
  math number,
  en   number
);

insert into t_test_col values('dasong1', 56, 50, 80);
insert into t_test_col values('dasong2', 45, 76, 90);
commit;

select * from t_test_col;
select * from t_test_col unpivot(score for subject in (zh as '语文', math as '数学', en as '英语'));
