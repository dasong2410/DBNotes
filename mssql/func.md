# Func

## OBJECT_DEFINITION

```sql
select OBJECT_DEFINITION(object_id), object_id, name
  from sys.objects where type='P';
```

## OBJECT_ID, OBJECT_NAME

```sql
select name,
       object_name(object_id)   object_name,
       object_id,
       object_id(name, type)    object_id2
from sys.objects;
```

## OBJECT_SCHEMA_NAME

```sql
select OBJECT_SCHEMA_NAME(object_id) schema_name,
       object_id,
       name
  from sys.objects
```

## user_id, user_name
```sql
select name,
       user_name(principal_id)  user_name,
       principal_id,
       user_id(name)            user_id
  from sys.database_principals;
```
