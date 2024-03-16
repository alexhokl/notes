- [Links](#links)
  * [Commands](#commands)
- [SQL statements](#sql-statements)
  * [Management](#management)
  * [Performance](#performance)
  * [JSON](#json)
  * [User and role management](#user-and-role-management)
- [Features](#features)
- [Limitations](#limitations)
____

## Links

- [explain.dalibo.com](https://explain.dalibo.com/) - visualising query plans
- [pganalyze](https://pganalyze.com/) - a SaaS product for tuning PostgreSQL
  queries

### Commands

#### pg_dump

##### To create script with database creation

```sh
pg_dump -C -h host1 -U user1 -d your-db-name
```

##### To create script of a table with schema and data

```sh
pg_dump -h host1 -U user1 -t "public.\"your-table\"" -d your-db-name
```

##### To create script with schema only

```sh
pg_dump -s -h host1 -U user1 -d your-db-name
```

##### To create script with data only

```sh
pg_dump -a -h host1 -U user1 -d your-db-name
```

#### psql

##### To avoid prompting for password for every psql command

```sh
PGPASSWORD=a_strong_password psql -U some-user@some-database -h some-database.example.com -d name_of_database
```

##### To connect to a database user psql

```sh
psql -U some-user@some-database -h some-database.example.com -d name_of_database
```

##### To run a SQL script from standard input

```sh
cat query.sql | psql -U some-user@some-database -h some-database.example.com -d name_of_database
```

##### To run a SQL script from file

```sh
psql -U some-user@some-database -h some-database.example.com -d name_of_database -f query.sql
```

##### To run a SQL statement

```sh
psql -U some-user@some-database -h some-database.example.com -d name_of_database -c "SELECT Id FROM your-table;"
```

##### To list all users of a database server

```sh
psql -U some-user@some-database -h some-database.example.com -c "\du"
```

##### To list all schemas of a database

```sh
psql -U some-user@some-database -h some-database.example.com -d name_of_database -c "\dn"
```

##### To list all tables of a database (in schema public)

```sh
psql -U some-user@some-database -h some-database.example.com -d name_of_database -c "\dt"
```

##### To list all tables of a database in a schema

```sh
psql -U some-user@some-database -h some-database.example.com -d name_of_database -c "\dt name_of_schema.*"
```

##### To list all column types, indexes and foreign keys of a database table

```sh
psql -U some-user@some-database -h some-database.example.com -d name_of_database -c "\d some_table_name"
```

## SQL statements

### Management

#### Links

- [Database Roles](https://www.postgresql.org/docs/current/user-manag.html)

#### Concepts

##### Roles

- A role can be thought of as either a database user, or a group of database
  users
- `CREATE USER` is equivalent to `CREATE ROLE` except that `CREATE USER`
  includes `LOGIN` by default, while `CREATE ROLE` does not.

#### Operations

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

##### To grant privileges of a role to another role

```sql
GRANT read_write_role TO someone;
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

##### Array and join (Cartesian product)

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

##### Array and count

```sql
SELECT
    c."customer_name",
    o."timestamp",
    json_array_length(o."detail" -> 'items') as cnt
FROM
    public."customer" as c JOIN
    public."order" o ON
        o."customer_id" = c."customer_id"
```

### User and role management

- `user` is a subset of `role` and `user` has login
- `role` may not have a login
- a `role` can be added to another `role`
  * permission is better to be granted to a `role` and then granting the `role`
    to another `role` or `user`
- `role` is database-wide

##### To create a role

```sql
CREATE ROLE your_readonly;
```

##### To add a role to another role

```sql
GRANT some_role TO another_role;
```

where both `some_role` and `another_role` can be a user

##### To list all roles in database

and also the roles included in a role

```sql
SELECT r.rolname, r.rolsuper, r.rolinherit,
  r.rolcreaterole, r.rolcreatedb, r.rolcanlogin,
  r.rolconnlimit, r.rolvaliduntil,
  ARRAY(SELECT b.rolname
        FROM pg_catalog.pg_auth_members m
        JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid)
        WHERE m.member = r.oid) as memberof
, r.rolreplication
, r.rolbypassrls
FROM pg_catalog.pg_roles r
WHERE r.rolname <> '^pg_'
ORDER BY 1
```

##### To grant access to a schema

```sql
GRANT USAGE ON SCHEMA your_schema TO your_readonly;
```

##### To grant basic read-only permission to objects in a schema

```sql
GRANT SELECT ON ALL TABLES IN SCHEMA your_schema TO your_readonly;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA your_schema TO your_readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA your_schema TO your_readonly;
```

##### To grant schema creation permission

```sql
GRANT CREATE ON DATABASE your_database TO appuser;
```

This is particularly useful for an application account to run migrations to
create schema.

##### To grant object creation permission

```sql
GRANT CREATE ON SCHEMA your_schema TO appuser;
```

Note that object includes table, functions, ... etc.

##### To grant permission for foreign key creation

```sql
GRANT REFERENCES ON ALL TABLES IN SCHEMA your_schema TO appuser;
```

##### To change ownership of a schema

```sql
ALTER SCHEMA your_schema OWNER TO appuser;
```

## Features

- [index types](https://www.postgresql.org/docs/current/indexes-types.html)
  * B-Tree (default)
  * Hash
  * GiST
  * SP-GiST
  * GIN (an inverted index)
    + it is like tokenized a column so that rows are indexed by the tokens
  * BRIN

## Limitations

- it does not have a way to deal with surrogate pair of UTF-16 characters
