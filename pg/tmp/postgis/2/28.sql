with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography)::int as distance
              from stores where city_id = '755')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;
