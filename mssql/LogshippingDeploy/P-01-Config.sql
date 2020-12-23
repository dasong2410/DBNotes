use master
go

create table logshipping_cfg
(
    database_id     int,
    name            varchar(64),
    recovery_model  varchar(32),
    logshipping     int, -- 0: No, 1: Yes
    standby         int, -- 0: No, 1: Yes
    remark          varchar(512)
);

insert into logshipping_cfg(database_id, name, recovery_model, logshipping, standby)
select database_id,
       name,
       recovery_model_desc,
       case recovery_model when 3 then 0 else 1 end logshipping,
       0 standby
  from sys.databases
 where state=0
   and database_id>4;

