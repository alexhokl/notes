
____

##### SET QUOTED_IDENTIFIER

Option `-I` is not required anymore in Go-version of `sqlcmd`. It used to be to
ensure `SET QUOTED_IDENTIFIER ON` . This aligns with the default behaviour of
MSSQL Management Studio.

##### To capture error

```sh
sqlcmd -b -Q "SELECT 1 FROM non_exist_table" || echo failed
```

##### To show simple query statistics

```sh
sqlcmd -p -Q "SELECT * FROM sys.tables"
```
