##### To backup from one database and restore to another

pg_dump -C -h host1 -U user1 your-db-name | psql -h host2 -U user2 your-db-name

##### To backup from one database table and restore to another

pg_dump -C -h host1 -U user1 --table "public.\"your-table\"" your-db-name | psql -h host2 -U user2 --table "public.\"your-table\"" your-db-name
