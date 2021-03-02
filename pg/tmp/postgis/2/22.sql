with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(114.4113027420 40.6630658332)'::geography)::int as distance
              from stores where city_id = '313')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(114.4113027420 40.6630658332)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;
