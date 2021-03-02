with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(120.8772138261 36.4634831714)'::geography)::int as distance
              from stores where city_id = '532')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(120.8772138261 36.4634831714)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;
