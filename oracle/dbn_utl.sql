create or replace package dbn_utl
/* Author:    Marcus Mao
 * Date:      2012-01-17
 * Desc:      dbn工具包，包含常用函数及过程。
 * Modified:
 *            Marcus 2012-03-06 添加函数num2ip64
 *            Marcus 2012-04-18 添加函数ip2num_host
 *                              添加函数num2ip_host
 */
as
  type varchar2_table is table of varchar2(4000);
  type varchar2_array is array(11) of varchar2(1);
  g_const_zero constant number := 0;
  g_const_null constant number := null;

  /* func:
   *   检查对象是否存在
   * param
   *   p_name：对象名
   *   p_type：对象类型
   *   p_owner：对象拥有者
   * return
   *   0：不存在
   *   1：存在
   */
  function exist
  (
    p_name  varchar2,
    p_type  varchar2 default 'TABLE'
  ) return number;

  /* func:
   *   拆分所给字符串
   * param
   *   p_str：被拆分的字符
   *   p_sep：分隔符
   * return
   *   包含一列的表，将如'a,b,c,d'字段串拆分成如下结果
   *   a
   *   b
   *   c
   *   d
   */
  function split
  (
    p_str varchar2,
    p_sep varchar2 default ','
  ) return varchar2_table pipelined;

  /* func:
   *   将绝对秒数转为日期字符串
   * param
   *   p_sec：绝对秒数
   *   p_pattern：日期字符串格式
   * return
   *   日期字符串
   */
  function sec2date
  (
    p_sec     number,
    p_pattern varchar2  default 'YYYYMMDD'
  ) return varchar2;

  /* func:
   *   将日期字符串转为绝对秒数
   * param
   *   p_date：日期字符串
   *   p_pattern：日期字符串格式
   * return
   *   绝对秒数
   */
  function date2sec
  (
    p_date    varchar2,
    p_pattern varchar2  default 'YYYYMMDD'
  ) return number;

  /* func:
   *   检查p_sub在p_ori中出现几次
   * param
   *   p_ori：源字符串
   *   p_sub：子字符串
   * return
   *   出现次数
   */
  function substr_cnt
  (
    p_ori varchar2,
    p_sub varchar2
  ) return number;

  /* func:
   *   ip转换为数字
   * param
   *   p_ipaddress：ip地址
   * return
   *   数字
   */
  function ip2num
  (
    p_ipaddress varchar2
  ) return number;

  /* func:
   *   数字转换为ip
   * param
   *   p_num：数字
   * return
   *   ip地址
   */
  function num2ip
  (
    p_num number
  ) return varchar2;

  /* func:
   *   ip转换为数字
   * param
   *   p_ipaddress：ip地址
   * return
   *   数字
   */
  function ip2num_host
  (
    p_ipaddress varchar2
  ) return number;

  /* func:
   *   数字转换为ip
   * param
   *   p_num：数字
   * return
   *   ip地址
   */
  function num2ip_host
  (
    p_num number
  ) return varchar2;

  /* func:
   *   ip转换为数字
   * param
   *   p_ipaddress：ip地址（包含8段，即两个v4ip拼结的字符串）
   * return
   *   数字
   */
  function ip2num64
  (
    p_ipaddress varchar2
  ) return number;

  /* func:
   *   数字转换为ip
   * param
   *   p_num：数字
   * return
   *   ip地址（包含8段，即两个v4ip拼结的字符串）
   */
  function num2ip64
  (
    p_num number
  ) return varchar2;

  /* func:
   *   获取对象名称
   * param
   * return
   *   当前调用此函数的对象的名称
   */
  function whoami
  return varchar2;

  /* func:
   *   十进制转为二进制
   * param
   *   p_dec：十进制数字
   * return
   *   二进制字符串
   */
  function dec2bin
  (
    p_dec number  default 0
  ) return varchar2;

  /* func:
   *   二进制转为十进制
   * param
   *   p_bin：二进制字符串
   * return
   *   十进制数字
   */
  function bin2dec
  (
    p_bin varchar2  default 0
  ) return number;

  /* func:
   *   15位身份证号转成18位
   * param
   *   p_id15：15位身份证号
   * return
   *   18位身份证号
   */
  function id15to18
  (
    p_id15 varchar2
  ) return varchar2;

  /* func:
   *   18位身份证号转成15位
   * param
   *   p_id18：18位身份证号
   * return
   *   15位身份证号
   */
  function id18to15
  (
    p_id18 varchar2
  ) return varchar2;

  /* func:
   *   判断是不是手机号
   * param
   *   p_cellphoneno：手机号
   * return
   *   如果传入值为手机号，则返回手机号；否则返回0
   */
  function cellphoneno
  (
    p_cellphoneno varchar2
  ) return varchar2;
end dbn_utl;
/

create or replace package body dbn_utl
as
  function exist
  (
    p_name  varchar2,
    p_type  varchar2 default 'TABLE'
  ) return number
  as
    l_cnt number;
  begin
    select count(1) into l_cnt
      from user_objects
     where object_name=upper(p_name)
       and object_type=upper(p_type);

    return l_cnt;
  exception
    when others then
      return g_const_zero;
  end exist;

  function split
  (
    p_str varchar2,
    p_sep varchar2 default ','
  ) return varchar2_table pipelined
  as
    l_start_pos number  := 0;
    l_end_pos   number  := 0;
    l_str       varchar2(32767);
    l_field     varchar2(4000);
    l_len        number;
  begin
    l_str := p_str || p_sep;
    l_len := length(l_str);

    while(l_end_pos<l_len-1) loop
      l_start_pos := l_end_pos+1;
      l_end_pos   := instr(l_str, p_sep, l_start_pos);
      l_field     := substr(l_str, l_start_pos, l_end_pos-l_start_pos);

      pipe row(l_field);
    end loop;

    return;
  exception
    when others then
      dbms_output.put_line(substr(sqlerrm(sqlcode), 1, 200));
  end split;

  function sec2date
  (
    p_sec     number,
    p_pattern varchar2  default 'YYYYMMDD'
  ) return varchar2
  as
    l_epoch varchar2(24) := '19700101080000';
    l_date  varchar2(24);
    l_sec   number(38);
  begin
    --如果传入的p_sec为空，则使用默认值
    if (p_sec is null) then
      l_sec := 0;
    else
      l_sec := p_sec;
    end if;

    --计算日期
    l_date := to_char(to_date(l_epoch, 'YYYYMMDDHH24MISS') + l_sec/86400, p_pattern);

    return l_date;
  exception
    when others then
      return l_epoch;
  end sec2date;

  function date2sec
  (
    p_date    varchar2,
    p_pattern varchar2  default 'YYYYMMDD'
  ) return number
  as
    l_epoch varchar2(24) := '19700101080000';
    l_date  varchar2(24);
    l_sec   number(38);
  begin
    --如果传入的p_date为空，则使用默认值
    if (p_date is null) then
      l_date := l_epoch;
    else
      l_date := p_date;
    end if;

    --计算绝对秒数
    l_sec := (to_date(l_date, p_pattern) - to_date(l_epoch, 'YYYYMMDDHH24MISS')) * 86400;

    return l_sec;
  exception
    when others then
      return g_const_zero;
  end date2sec;

  function substr_cnt
  (
    p_ori varchar2,
    p_sub varchar2
  ) return number
  as
    l_len1  number;
    l_len2  number;
    l_ret   number;
  begin
    l_len1 := length(p_ori);
    l_len2 := nvl(length(replace(p_ori, p_sub)), 0);

    l_ret  := l_len1-l_len2;

    return l_ret;
  exception
    when others then
      return g_const_zero;
  end substr_cnt;

  function ip2num
  (
    p_ipaddress varchar2
  ) return number
  as
    l_ret number;
  begin
    --简单决断ip格式是否合法
    if (regexp_like(p_ipaddress, '^([0-9]){1,3}(\.([0-9]){1,3}){3}$')) then
      select sum(power(2, 8*(4-rownum))*column_value) into l_ret
        from table(dbn_utl.split(p_ipaddress, '.'));

      --2147483647=127.255.255.255; 4294967296=255.255.255.255+1
      if (l_ret>2147483647) then
        l_ret := l_ret-4294967296;
      end if;
    else
      l_ret := g_const_zero;
    end if;

    return l_ret;
  exception
    when others then
      return g_const_zero;
  end ip2num;

  function num2ip
  (
    p_num number
  ) return varchar2
  as
    l_num   number;
    l_field number;
    l_ret   varchar2(32);
    l_sep   varchar2(1);
  begin
    --4294967296=255.255.255.255+1
    if (p_num<0) then
      l_num := p_num+4294967296;
    else
      l_num := p_num;
    end if;

    for i in reverse 1..4 loop
      l_field := trunc(l_num/power(2, 8*(i-1)));
      l_ret := l_ret || l_sep || l_field;
      l_num := l_num-power(2,8*(i-1))*l_field;

      l_sep := '.';
    end loop;

    return l_ret;
  exception
    when others then
      return g_const_null;
  end num2ip;

  function ip2num_host
  (
    p_ipaddress varchar2
  ) return number
  as
    l_ret number;
  begin
    --简单决断ip格式是否合法
    if (regexp_like(p_ipaddress, '^([0-9]){1,3}(\.([0-9]){1,3}){3}$')) then
      select sum(power(2, 8*(4-rownum))*column_value) into l_ret
        from table(dbn_utl.split(p_ipaddress, '.'));
    else
      l_ret := g_const_zero;
    end if;

    return l_ret;
  exception
    when others then
      return g_const_zero;
  end ip2num_host;

  function num2ip_host
  (
    p_num number
  ) return varchar2
  as
    l_num   number;
    l_field number;
    l_ret   varchar2(32);
    l_sep   varchar2(1);
  begin
    --p_num为负数则直接返回null
    if (p_num<0) then
      return g_const_null;
    end if;

    l_num := p_num;

    for i in reverse 1..4 loop
      l_field := trunc(l_num/power(2, 8*(i-1)));
      l_ret := l_ret || l_sep || l_field;
      l_num := l_num-power(2,8*(i-1))*l_field;

      l_sep := '.';
    end loop;

    return l_ret;
  exception
    when others then
      return g_const_null;
  end num2ip_host;

  function ip2num64
  (
    p_ipaddress varchar2
  ) return number
  as
    l_ret number;
  begin
    if (regexp_like(p_ipaddress, '^([0-9]){1,3}(\.([0-9]){1,3}){7}$')) then
      select sum(power(2, 8*(8-rownum))*column_value) into l_ret
        from table(dbn_utl.split(p_ipaddress, '.'));

      --注：右补0到20位可能会存在多个ip段对应相同结果值，如：20.0.0.1.127.0.0.10和200.0.0.14.246.0.0.100；
      --并且补齐过之后将被还原成原来的ip段的可能性比较小，即可以说不可逆。
      l_ret := rpad(l_ret, 20, 0);
    else
      l_ret := g_const_zero;
    end if;

    return l_ret;
  exception
    when others then
      return g_const_zero;
  end ip2num64;

  function num2ip64
  (
    p_num number
  ) return varchar2
  as
    l_num   number;
    l_field number;
    l_ret   varchar2(128);
    l_sep   varchar2(1);
  begin
    l_num := p_num;
    for i in reverse 1..8 loop
      l_field := trunc(l_num/power(2, 8*(i-1)));
      l_ret := l_ret || l_sep || l_field;
      l_num := l_num-power(2,8*(i-1))*l_field;

      l_sep := '.';
    end loop;

    return l_ret;
  exception
    when others then
      return g_const_null;
  end num2ip64;

  function whoami
  return varchar2
  as
    l_owner     varchar2(256);
    l_name      varchar2(256);
    l_lineno    integer;
    l_caller_t  varchar2(256);
  begin
    owa_util.who_called_me
    (
      owner     => l_owner,
      name      => l_name,
      lineno    => l_lineno,
      caller_t  => l_caller_t
    );

    return l_name;
  exception
    when others then
      return g_const_null;
  end whoami;

  function dec2bin
  (
    p_dec number  default 0
  ) return varchar2
  as
    --被除数
    l_numerator number;

    l_ret varchar2(1024);
  begin
    l_numerator := abs(trunc(p_dec));
    loop
      l_ret := mod(l_numerator, 2) || l_ret;
      l_numerator := trunc(l_numerator/2);
      exit when l_numerator=0;
    end loop;
    return l_ret;
  exception
    when others then
      return g_const_zero;
  end dec2bin;

  function bin2dec
  (
    p_bin varchar2  default 0
  ) return number
  as
    l_bin varchar2(38);
    l_len number;
    l_ret number        := 0;
  begin
    l_bin := abs(trunc(p_bin));
    l_len := length(l_bin);

    for i in 1..l_len loop
      l_ret := l_ret+power(2, l_len-i)*substr(l_bin, i, 1);
    end loop;
    return l_ret;
  exception
    when others then
      return g_const_zero;
  end bin2dec;

  function id15to18
  (
    p_id15 varchar2
  ) return varchar2
  as
    l_sum       number := 0;
    l_id18      varchar2(18);
    l_mod_array varchar2_array := varchar2_array('1','0','X','9','8','7','6','5','4','3','2');
  begin
    l_id18 := to_single_byte(p_id15);

    --如果不是15位数字则返回空
    if(not regexp_like(l_id18, '[0-9]{15}')) then
      return g_const_null;
    end if;

    --添加两位世纪
    l_id18 := substr(l_id18, 1, 6) || '19' || substr(l_id18, 7);

    for cards in (select rownum rn, column_value card
                    from table(dbn_utl.split('7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2'))) loop

      l_sum := l_sum + substr(l_id18, cards.rn, 1)*cards.card;
    end loop;

    --添加校验位
    l_id18 := l_id18 || l_mod_array(mod(l_sum, 11)+1);

    return l_id18;
  exception
    when others then
      return g_const_null;
  end id15to18;

  function id18to15
  (
    p_id18 varchar2
  ) return varchar2
  as
    l_id15  varchar2(15);
    l_id18  varchar2(18);
  begin
    l_id18 := to_single_byte(p_id18);

    --如果不是17位数字+1位数字或x则返回空
    if(not regexp_like(l_id18, '[0-9]{17}[0-9|x|X]')) then
      return p_id18;
    end if;

    l_id15 := substr(l_id18, 1, 6) || substr(l_id18, 9, 9);

    return l_id15;
  exception
    when others then
      return p_id18;
  end id18to15;

  function cellphoneno
  (
    p_cellphoneno varchar2
  ) return varchar2
  as
    l_cellphoneno varchar2(11);
    l_pattern     varchar2(4000);
    l_p13         varchar2(1000) := '130[0-9]{8},131[0-9]{8},132[0-9]{8},133[0-9]{8},134[0-8]{1}[0-9]{7},135[0-9]{8},136[0-9]{8},137[0-9]{8},138[0-9]{8},139[0-9]{8}';
    l_p15         varchar2(1000) := '150[0-9]{8},151[0-9]{8},152[0-9]{8},153[0-9]{8},155[0-9]{8},156[0-9]{8},157[0-9]{8},158[0-9]{8},159[0-9]{8}';
    l_p17         varchar2(1000) := '176[0-9]{8}';
    l_p18         varchar2(1000) := '180[0-9]{8},181[0-9]{8},182[0-9]{8},183[0-9]{8},184[0-9]{8},185[0-9]{8},186[0-9]{8},187[0-9]{8},188[0-9]{8},189[0-9]{8}';
  begin
    --手机号段的匹配模式，如果新增号段则需要修改变量的值或是新增变量
    l_pattern := l_p13 || ',' || l_p15 || ',' || l_p17 || ',' || l_p18;

    l_cellphoneno := to_single_byte(p_cellphoneno);

    --匹配号段
    select l_cellphoneno into l_cellphoneno
      from (select '^' || column_value || '$' p
              from table(dbn_utl.split(l_pattern)))
     where regexp_like(l_cellphoneno, p);

    return l_cellphoneno;
  exception
    when others then
      return g_const_zero;
  end cellphoneno;
end dbn_utl;
/
