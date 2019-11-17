--提取 函数、过程 等 ddl
set serveroutput on;
declare
  l_sql varchar2(1024);
begin
  for l_prc in (select decode(line, 1, 'create or replace ' || rtrim(replace(text, chr(10))),
                       rtrim(replace(text, chr(10)))) src,
                       line,
                       max(line) over(partition by name, type) max_line
                  from user_source
                 order by name, type, line) loop
    if(l_prc.line=l_prc.max_line) then
      l_sql := l_prc.src || chr(10) || '/' || chr(10);
    else
      l_sql := l_prc.src;
    end if;

    dbms_output.put_line(l_sql);
  end loop;
end;
/
