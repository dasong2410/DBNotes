select segment_name, trunc(sum(bytes)/1024/1024/1024, 2) "SIZE(G)"
  from user_segments
 where segment_type like '%TABLE%'
 group by segment_name
 order by sum(bytes) desc;

select segment_name, partition_name, trunc(sum(bytes)/1024/1024/1024, 2) "SIZE(G)"
  from user_segments
 where upper(segment_name)=('table_name')
 group by rollup(segment_name, partition_name);

