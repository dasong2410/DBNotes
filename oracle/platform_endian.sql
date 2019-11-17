select a.platform_id fp_id, a.platform_name fp_name, a.endian_format fp_endian,
       b.platform_id tp_id, b.platform_name tp_name, b.endian_format tp_edian
  from v$transportable_platform a, v$transportable_platform b
 where a.endian_format!=b.endian_format
 order by a.platform_id, b.platform_id;
