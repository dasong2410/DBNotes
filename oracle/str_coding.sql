--将字符转为oracle存储的十六进制
select utl_raw.cast_to_raw('dasong') from dual;

--将oracle存储的十六进制转为字符
select utl_raw.cast_to_varchar2('6461736F6E67') from dual;

--将数字转为oracle存储的十六进制
select utl_raw.cast_from_number(1) from dual;

--将oracle存储的十六进制转为数字
select utl_raw.cast_to_number('C102') from dual;


--字符转ascii码
select ascii('a') from dual;

--ascii码转字符
select chr(97) from dual;

--字符转utf8编码
select asciistr('中') from dual;

--utf8编码转字符
select unistr('\4E2D') from dual;


--十进制转十六进制
select to_char(100, 'XXX') from dual;

--十六进制转十进制
select to_number('FFF', 'XXX') from dual;
