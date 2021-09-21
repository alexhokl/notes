
____

##### SET QUOTED_IDENTIFIER

Option `-I` should be used all the time to make sure `SET QUOTED_IDENTIFIER ON`
is used. This is the default behaviour of MSSQL Management Studio.

##### To capture error

```sh
sqlcmd -b -Q "SELECT 1 FROM non_exist_table" || echo failed
```

##### To show simple query statistics

```sh
sqlcmd -p -Q "SELECT * FROM sys.tables"
```
