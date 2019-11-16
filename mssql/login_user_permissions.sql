--------------------------------------------------------------------
-- user, role, permissions dmv: begin
--------------------------------------------------------------------
select * from sys.database_principals;
select * from sys.database_role_members;
select * from sys.server_principals;
select * from sys.sql_logins;
--------------------------------------------------------------------
-- user, role, permissions dmv: begin
--------------------------------------------------------------------

--------------------------------------------------------------------
-- user and role permissions: begin
--------------------------------------------------------------------
use [database_name];
go

select u.name                   user_name,
       u.principal_id           user_id,
       schema_name(o.schema_id) schema_name,
       o.name                   object_name, /*o.object_id,*/
       o.type_desc              object_type,
       p.permission_name,
       p.state_desc
from sys.database_permissions p
         join
     sys.objects o on p.major_id = o.object_id
         join
     sys.database_principals u on p.grantee_principal_id = u.principal_id
order by user_name, object_type, object_name;
--------------------------------------------------------------------
-- user and role permissions: end
--------------------------------------------------------------------

--------------------------------------------------------------------
-- user and role mapping: begin
--------------------------------------------------------------------
use [database_name];
go

select u.name         user_name,
       u.principal_id user_id,
       u.type_desc    user_type,
       r.name         role_name,
       r.principal_id role_id,
       r.type_desc    role_type
from sys.database_principals u,
     sys.database_principals r,
     sys.database_role_members ur
where u.principal_id = ur.member_principal_id
  and r.principal_id = ur.role_principal_id
order by user_id;
--------------------------------------------------------------------
-- user and role mapping: begin
--------------------------------------------------------------------

--------------------------------------------------------------------
-- login and user mapping: begin
--------------------------------------------------------------------
use [database_name];
go

with u as (select * from sys.database_principals where type = 'S' and principal_id > 4)
select l.name         login_name,
       l.principal_id login_id,
       l.type_desc    login_type,
       u.name         user_name,
       u.principal_id user_id,
       u.type_desc    user_type
from sys.sql_logins l
         full join u on l.sid = u.sid;
--------------------------------------------------------------------
-- login and user mapping: end
--------------------------------------------------------------------
