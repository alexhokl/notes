- [Links](#links)
  * [Commands](#commands)
- [SQL statements](#sql-statements)
  * [Management](#management)
  * [Performance](#performance)
  * [JSON](#json)
  * [Array and join (Cartesian product)](#array-and-join-cartesian-product)
____

## Links

- [explain.dalibo.com](https://explain.dalibo.com/) - visualising query plans

### Commands

##### To backup from one database and restore to another

```sh
pg_dump -C -h host1 -U user1 your-db-name | psql -h host2 -U user2 your-db-name
```

##### To backup from one database table and restore to another

```sh
pg_dump -C -h host1 -U user1 --table "public.\"your-table\"" your-db-name | psql -h host2 -U user2 --table "public.\"your-table\"" your-db-name
```

##### To avoid prompting for password for every psql command

```sh
PGPASSWORD=a_strong_password psql -U some-user@some-database -h some-database.example.com -d name-of-database
```

##### To connect to a database user psql

```sh
psql -U some-user@some-database -h some-database.example.com -d name-of-database
```

##### To run a SQL script from standard input

```sh
cat query.sql | psql -U some-user@some-database -h some-database.example.com -d name-of-database
```

##### To run a SQL script from file

```sh
psql -U some-user@some-database -h some-database.example.com -d name-of-database -f query.sql
```

##### To run a SQL statement

```sh
psql -U some-user@some-database -h some-database.example.com -d name-of-database -c "SELECT Id FROM your-table;"
```

## SQL statements

### Management

##### To create a user

```sql
CREATE USER "some_user" WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD 'your_strong_password';
```

##### To grant a user with read-only permissions

```sql
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "some_user";
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO "some_user";
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO "some_user";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO PUBLIC;
```

##### To grant a user with write permissions

```sql
GRANT INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO "some_user";
```

Note that the above statements only covers schema `public`.

##### To remove a user

In each database the user is involved,

```sql
REASSIGN OWNED BY "some_user" TO postgres; -- or other users
DROP OWNED BY "some_user";
```

Run the following in any of the databases.

```sql
DROP USER "some_user";
```

Note that `REASSIGN OWNED` and `DROP OWNED` has to be done on a per-database
basis.

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

##### To list all table privileges

```sql
SELECT grantee,table_catalog, table_schema, table_name, privilege_type
FROM   information_schema.table_privileges
WHERE  grantee = 'some_user';
```

##### To change ownership of a table

Suppose the table is owned by `abcadmin` and we want to change the ownership to
user/role `appuser`. To enable the process, we add role `appuser` to role
`abcadmin` and change the ownership.

```sql
GRANT appuser TO abcadmin
ALTER TABLE public."some_table" OWNER TO appuser
```

### Performance

##### To get a count of number of connections and its state

```sql
SELECT state, count(*) FROM pg_stat_activity GROUP BY state;
```

##### To get connections waiting for a lock

```sql
SELECT count(distinct pid) FROM pg_locks WHERE granted = false
```

##### To get maximum transaction age

```sql
SELECT max(now() -xact_start) FROM pg_stat_activity WHERE state IN ('idle in transaction','active');
```

##### To retrieve information about checkpoints

```sql
SELECT * FROM pg_stat_bgwriter;
```

##### To retrieve execution times

```sql
SELECT * FROM pg_stat_statements;
```

### JSON

##### Arrow operations

```sql
SELECT info -> 'items' ->> 'product' as product
FROM orders
ORDER BY product;
```

where `->` outputs a JSON object and `->>` outputs a string.

##### Aggregation

```sql
SELECT
   MIN (CAST (info -> 'items' ->> 'qty' AS INTEGER)),
   MAX (CAST (info -> 'items' ->> 'qty' AS INTEGER)),
   SUM (CAST (info -> 'items' ->> 'qty' AS INTEGER)),
   AVG (CAST (info -> 'items' ->> 'qty' AS INTEGER))
FROM orders;
```

### Array and join (Cartesian product)

```sql
SELECT
    c."customer_name",
    o."timestamp",
    json_array_elements(o."detail" -> 'items') ->> 'description' as "description"
FROM
    public."customer" as c JOIN
    public."order" o ON
        o."customer_id" = c."customer_id"
```

Assuming there are 1 customer and 5 order associated with the customer and each
order has 5 items, the above query results in 25 rows of data.
