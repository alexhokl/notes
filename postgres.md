##### To backup from one database and restore to another

pg_dump -C -h host1 -U user1 your-db-name | psql -h host2 -U user2 your-db-name

##### To backup from one database table and restore to another

pg_dump -C -h host1 -U user1 --table "public.\"your-table\"" your-db-name | psql -h host2 -U user2 --table "public.\"your-table\"" your-db-name

##### To connect to a database user psql

```sh
psql -U some-user@some-database -h some-database.example.com -d name-of-database
```

##### To create a user

```sql
CREATE USER some-user WITH ENCRYPTED PASSWORD 'some-password';
GRANT USAGE ON SCHEMA public TO some-user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO some-user;
```

##### To remove a user

```sql
DROP USER some-user;
```

##### To list all users

```sql
SELECT usename AS role_name,
  CASE 
     WHEN usesuper AND usecreatedb THEN 
	   CAST('superuser, create database' AS pg_catalog.text)
     WHEN usesuper THEN 
	    CAST('superuser' AS pg_catalog.text)
     WHEN usecreatedb THEN 
	    CAST('create database' AS pg_catalog.text)
     ELSE 
	    CAST('' AS pg_catalog.text)
  END role_attributes
FROM pg_catalog.pg_user
ORDER BY role_name desc;
```
