##### To capture error

```sh
sqlcmd -b -Q "SELECT 1 FROM non_exist_table" || echo failed
```

##### To show simple query statistics

```sh
sqlcmd -p -Q "SELECT * FROM sys.tables"
```
