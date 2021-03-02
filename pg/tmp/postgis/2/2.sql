with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(121.3878945400 31.2704262881)'::geography)::int as distance
              from stores where city_id = '021')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(121.3878945400 31.2704262881)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;

with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(114.4113027420 40.6630658332)'::geography)::int as distance
              from stores where city_id = '313')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(114.4113027420 40.6630658332)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;

with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(120.8772138261 36.4634831714)'::geography)::int as distance
              from stores where city_id = '532')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(120.8772138261 36.4634831714)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;

with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(113.6872483584 34.7983366388)'::geography)::int as distance
              from stores where city_id = '371')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(113.6872483584 34.7983366388)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;

with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(116.7702980545 39.9688657272)'::geography)::int as distance
              from stores where city_id = '316')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(116.7702980545 39.9688657272)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;

with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(113.1402669742 23.1199294664)'::geography)::int as distance
              from stores where city_id = '757')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(113.1402669742 23.1199294664)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;

with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(105.1380678636 32.3480110540)'::geography)::int as distance
              from stores where city_id = '839')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(105.1380678636 32.3480110540)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;

with a as (select id, name,open_state,geop,
                   ST_Distance(geop,'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography)::int as distance
              from stores where city_id = '755')
select id, name,open_state, distance
  from (select *, row_number() over(partition by open_state order by 'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography <-> geop) as rn
           from a) tmp
 where rn<2;

