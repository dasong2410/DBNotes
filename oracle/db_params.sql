--所有参数，包括未归档参数
select a.ksppinm,
       b.ksppstvl,
       a.ksppdesc,
       b.ksppstdvl,
       b.ksppstdf,
       b.ksppstvf
  from x$ksppi a,
       x$ksppcv b
 where a.indx = b.indx
   and a.inst_id = b.inst_id
 order by lower(a.ksppinm);

--归档参数
select name,
       value,
       display_value
  from v$parameter
 order by name;

--数据库属性
select property_name,
       property_value
  from database_properties;
