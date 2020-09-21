- [Database and T-SQL](#database-and-t-sql)
    + [Tools](#tools)
    + [Database Operations](#database-operations)
    + [Database performance](#database-performance)
    + [Database table manipulations](#database-table-manipulations)
    + [Query](#query)
    + [Troubleshooting](#troubleshooting)
____

# Database and T-SQL

### Tools

- [Instant SQL Formatter](http://www.dpriver.com/pp/sqlformat.htm)

### Database Operations

##### Create a database backup

```sql
BACKUP DATABASE [MyDatabaseName] TO DISK='C:\backup\MyDatabaseName.bak' WITH COMPRESSION
GO
```

##### Restore a database from File

```sql
RESTORE DATABASE [MyDatabaseName] FROM DISK='C:\backup\MyDatabaseName.bak' WITH RECOVERY, MOVE 'MyDatabaseName' TO 'C:\backup\MyDatabaseName.mdf', MOVE 'MyDatabaseName_log' TO 'C:\backup\MyDatabaseName_log.ldf'
GO
```

##### Attach a database

Make sure that the folders containing the database files are granted with write permissions for the MSSQL server process (Check "Logon" tab in `services.msc`).

```sql
CREATE DATABASE AssetsDB ON
(FILENAME = N'c:\database\AssetsDB_Primary.mdf'),
(FILENAME = N'c:\database\AssetsDB_Primary.ldf')
FOR ATTACH;
```

If the attached database is running as read-only mode due to the file permissions, fix the file permissions and run `ALTER DATABASE [DatabaseName] SET READ_WRITE` to make it running in non-read-only mode again.

##### Export a database

```sh
sqlpackage /a:Export /ssn:database.example.com /sdn:MyDatabase /su:sa /sp:AStrongPassword /tf:MyDatabase.bacpac
```

Note: [Installing sqlpackage](https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download?view=sql-server-2017)

##### Import a database

```sh
sqlpackage /a:Import /tsn:database.example.com /tdn:MyDatabase /tu:sa /tp:AStrongPassword /sf:MyDatabase.bacpac
```

Note that if the target database already exists and contains objects such as
tables or views, then the import will fail. The database must either not exist,
or be completely empty.

##### Shrink database logs

To find the logical name of log file

```sql
SELECT name
FROM sys.master_files
WHERE database_id = db_id() AND type = 1
```

To shrink the logs

```sql
ALTER DATABASE ExampleDatabaseName SET RECOVERY SIMPLE WITH NO_WAIT
DBCC SHRINKFILE(ExampleDatabaseName_log, 1)
ALTER DATABASE ExampleDatabaseName SET RECOVERY FULL WITH NO_WAIT
GO
```

##### Rebuild indicies and statistics

```sql
DECLARE @TableName varchar(255)
DECLARE TableCursor CURSOR FOR

SELECT table_name FROM information_schema.tables
WHERE table_type = 'base table' AND table_catalog='CustomDatabaseName' AND TABLE_SCHEMA='dbo'

DECLARE @Statement NVARCHAR(300)

OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @TableName
WHILE @@FETCH_STATUS = 0

BEGIN
  BEGIN TRY
    -- Reindex
    DBCC DBREINDEX(@TableName ,'', 100);
  END TRY
  BEGIN CATCH
     PRINT @TableName + ' Failed to reindex';
  END CATCH

  BEGIN TRY
    -- Update Statistic
    SET @Statement = 'UPDATE STATISTICS ' + @TableName + ' WITH FULLSCAN;'
    EXEC sp_executesql @Statement
  END TRY
  BEGIN CATCH
     PRINT @TableName + ' Failed to build statistic';
  END CATCH

  FETCH NEXT FROM TableCursor INTO @TableName
END

CLOSE TableCursor
DEALLOCATE TableCursor
```

##### User modes

To change to single-user mode (usually done at the beginning of a set of operations)

```sql
ALTER DATABASE MyCustomDatabaseName SET SINGLE_USER
```

To change to multi-user mode (usually done at the end of a set of operations)

```sql
ALTER DATABASE MyCustomDatabaseName SET MULTI_USER
```

##### Re-enable SQL login and change its password

```sql
ALTER LOGIN YourSqlLoginName ENABLE
ALTER Login YourSqlLoginName WITH PASSWORD = 'SomeStrongPassword'
```


### Database performance

##### To clean up SQL server cache

```sql
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
```

##### To check query warnings via execution plan

1.  Make a query via Management Studio with execution plan enabled
2.  Right click on any blank space on the execution plan
3.  Select "Show Execution Plan XML..."
4.  Search for `warnings`

##### To check cached query plans

```sql
-- Querying the plan cache for plans that have warnings
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

;WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan'),
    WarningSearch AS (
            SELECT
                  qp.query_plan
                , cp.usecounts
                , cp.objtype
                , wn.query('.') AS StmtSimple
            FROM   sys.dm_exec_cached_plans cp
              CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) qp
              CROSS APPLY qp.query_plan.nodes('//StmtSimple') AS p(wn)
            WHERE wn.exist('//Warnings') = 1
            AND  wn.exist('//ColumnsWithNoStatistics') =1
                        AND wn.exist('@QueryHash') = 1
                        )
SELECT
      ws.query_plan
    , ws.query_plan.query('//Warnings') as Warning
    , ws.query_plan.query('//ColumnsWithNoStatistics')
              as WarningColumnsWithNoStatistics
    , StmtSimple.value('StmtSimple[1]/@StatementText', 'VARCHAR(4000)')
             AS sqlText
    , StmtSimple.value('StmtSimple[1]/@StatementId', 'int') AS StatementId
    , c1.value('@NodeId','int') AS node_id
    , c1.value('@PhysicalOp','sysname') AS physical_op
    , c1.value('@LogicalOp','sysname') AS logical_op
        , ws.objtype
    , c3.value('@Database', 'sysname') as [DatabaseName]
    , c3.value('@Schema', 'sysname') as [Schema]
    , c3.value('@Table', 'sysname') as  [TableName]
    , c3.value('@Column', 'sysname') as [Column]
FROM WarningSearch ws
      CROSS APPLY StmtSimple.nodes('//RelOp') AS q1(c1)
      CROSS APPLY c1.nodes('./Warnings') AS q2(c2)
      CROSS APPLY c2.nodes('./ColumnsWithNoStatistics/ColumnReference') AS q3(c3)
```

##### To update broken (or no) statistics of a table

```sql
UPDATE STATISTICS MyCustomTableName WITH FULLSCAN
```

##### To query disk space consumed by table sizes

```sql
SELECT
    t.NAME AS TableName,
    s.Name AS SchemaName,
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8/ 1024.00 AS TotalSpaceMB,
    SUM(a.used_pages) * 8 /1024.00AS UsedSpaceMB,
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8/1024.00 AS UnusedSpaceMB
FROM
    sys.tables t
INNER JOIN
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN
    sys.allocation_units a ON p.partition_id = a.container_id
LEFT OUTER JOIN
    sys.schemas s ON t.schema_id = s.schema_id
WHERE
    t.NAME NOT LIKE 'dt%'
    AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255
GROUP BY
    t.Name, s.Name, p.Rows
ORDER BY
    t.Name
```

##### To check if current connected database is a read-only replica

```sql
SELECT DATABASEPROPERTYEX(DB_NAME(), 'updateability')
```

##### Check current connections

```sql
SELECT * FROM sys.dm_exec_connections
```

Connection count by database and login

```sql
SELECT
    DB_NAME(dbid) as DBName,
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName
FROM
    sys.sysprocesses
WHERE
    dbid > 0
GROUP BY
    dbid, loginame
```

Total connection count

```sql
SELECT
    COUNT(dbid) as TotalConnections
FROM
    sys.sysprocesses
WHERE
    dbid > 0
```

##### Check current locks on a table

```sql
SELECT * FROM sys.dm_tran_locks
WHERE
    resource_database_id = DB_ID() AND
    resource_associated_entity_id = OBJECT_ID(N'dbo.YourTableName');
```

##### Check index of a table

```sql
SELECT
    a.index_id,
    name,
    avg_fragmentation_in_percent,
    fragment_count,
    avg_fragment_size_in_pages
FROM
    sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'[dbo].[YourTableName]'), NULL, NULL, NULL) AS a JOIN
    sys.indexes AS b ON
        a.object_id = b.object_id AND
        a.index_id = b.index_id;
```

##### To list recent SQL job history

```sql
SELECT top 100 j.[name]
       ,[step_name]
      ,[message]
      ,[run_status]
      ,[run_date]
      ,[run_time]
      ,[run_duration]
  FROM [msdb].[dbo].[sysjobhistory] jh
  JOIN [msdb].[dbo].[sysjobs] j
  on jh.job_id= j.job_id
  order by run_date desc
```

##### Create indexes with included columns

```sql
CREATE NONCLUSTERED INDEX IX_Address_PostalCode
ON Address (PostalCode)
INCLUDE (AddressLine1, AddressLine2, City, StateProvinceID);
GO
```

The above index is useful when the following query is made.

```sh
SELECT
    AddressLine1, AddressLine2, City, StateProvinceID
FROM Address
WHERE PostalCode = 'ABC'
```

An index with nonkey columns can significantly improve query performance when
all columns in the query are included in the index either as key or nonkey
columns. Performance gains are achieved because the query optimizer can locate
all the column values within the index; table or clustered index data is not
accessed resulting in fewer disk I/O operations. Included columns are not
considered by the Database Engine when calculating the number of index key
columns or index key size.

A detailed explanation using query plan - [SQL Server Indexes with Included Columns](http://www.sqlservertutorial.net/sql-server-indexes/sql-server-indexes-with-included-columns/)

##### Query plans

- Index scan involves checking values of all rows in a table
- Index seek involves only values of rows matching a specific criteria

##### To check query history

```sql
SELECT t.[text], s.last_execution_time
FROM sys.dm_exec_cached_plans AS p
INNER JOIN sys.dm_exec_query_stats AS s
   ON p.plan_handle = s.plan_handle
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) AS t
WHERE t.[text] LIKE N'%sp_something%'
AND s.last_execution_time between '2020-08-01 17:00:00' AND '2020-08-01 17:05:00'
ORDER BY s.last_execution_time DESC;
```

##### To list top CPU usage of frequently used queries

```sql
SELECT TOP 50
    [Avg.MultiCore/CPU time(sec)] = qs.total_worker_time / 1000000 / qs.execution_count,
    [Total MultiCore/CPU time(sec)] = qs.total_worker_time / 1000000,
    [Avg.Elapsed Time(sec)] = qs.total_elapsed_time / 1000000 / qs.execution_count,
    [Total Elapsed Time(sec)] = qs.total_elapsed_time / 1000000,
    qs.execution_count,
    [Avg.I/O] = (total_logical_reads + total_logical_writes) / qs.execution_count,
    [Total I/O] = total_logical_reads + total_logical_writes,
    Query = SUBSTRING(qt.[text], (qs.statement_start_offset / 2) + 1,
    (
    (
    CASE qs.statement_end_offset
        WHEN -1 THEN DATALENGTH(qt.[text])
        ELSE qs.statement_end_offset
    END - qs.statement_start_offset
    ) / 2
    ) + 1
    ),
    Batch = qt.[text],
    [DB] = DB_NAME(qt.[dbid]),
    qs.last_execution_time,
    qp.query_plan
FROM
    sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_sql_text(qs.[sql_handle]) AS qt
    CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE
    qs.execution_count > 5--more than 5 occurences
ORDER BY
    [Total MultiCore/CPU time(sec)] DESC
```

##### To change maximum memory usage of a MSSQL server

```sql
EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'max server memory (MB)', N'100000'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO
```

### Database table manipulations

##### To modify column definition

```sql
ALTER TABLE Examples ALTER COLUMN ExampleId VARCHAR(20) NOT NULL
```

##### Altering primary key

```sql
ALTER TABLE Examples ADD PRIMARY KEY([ExampleId], [UserId])
```

##### Example on column insertion

```sql
ALTER TABLE Examples ADD [Title] NVARCHAR(50) NULL
```

##### Rename a table

```sql
EXEC sp_rename 'OldTableName', 'NewTableName'
```

##### Rename a column

```sql
EXEC sp_rename
    @objname = 'TableName.OldColumnName',
    @newname = 'NewColumnName',
    @objtype = 'COLUMN'
```

##### Drop a constraint

```sql
ALTER TABLE MyTable DROP CONSTRAINT MyTable_Contraint
```

##### To check if there a different collation and generate statements to fix it

```sql
SELECT
  'ALTER TABLE [dbo].[' + t.name + '] ALTER COLUMN [' + c.name + '] ' +
  ty.name + '(' +
  CASE WHEN c.max_length < 0 THEN 'MAX'
       WHEN ty.name = 'nvarchar' THEN CONVERT(VARCHAR(5), c.max_length/2)
     ELSE CONVERT(VARCHAR(5), c.max_length) END +
   ') COLLATE database_default ' +
  CASE WHEN c.is_nullable = 1 THEN 'NULL' ELSE 'NOT NULL' END
FROM
  sys.columns c JOIN
  sys.tables t ON
    t.object_id = c.object_id JOIN
  sys.types ty ON
    ty.system_type_id = c.system_type_id
WHERE
  --c.name <> 'Code' AND
  c.collation_name <> (SELECT CONVERT (varchar, SERVERPROPERTY('collation'))) AND
  ty.name <> 'sysname'
ORDER BY t.name


SELECT 'DROP VIEW dbo.[' + name + ']'
FROM (
SELECT
  DISTINCT t.name
FROM
  sys.columns c JOIN
  sys.views t ON
    t.object_id = c.object_id JOIN
  sys.types ty ON
    ty.system_type_id = c.system_type_id
WHERE
  --c.name <> 'Code' AND
  c.collation_name <> (SELECT CONVERT (varchar, SERVERPROPERTY('collation'))) AND
  ty.name <> 'sysname'
  ) temp
ORDER BY name
```

##### To generate drop constraint statements

```sql
select
  'DROP INDEX ' + i.name + ' ON dbo.[' + t.name + ']'
from sys.indexes i JOIN
  sys.tables t ON
    t.object_id = i.object_id
WHERE i.name LIKE 'IX_%_Name'
ORDER BY t.name, i.name

select
  'DROP INDEX ' + i.name + ' ON dbo.[' + t.name + ']'
from sys.indexes i JOIN
  sys.tables t ON
    t.object_id = i.object_id
WHERE i.name LIKE 'UQ_%'
ORDER BY t.name, i.name


select
  'ALTER TABLE dbo.[' + t.name + '] DROP CONSTRAINT ' + i.name
from sys.indexes i JOIN
  sys.tables t ON
    t.object_id = i.object_id
WHERE i.name LIKE 'UQ_%'
ORDER BY t.name, i.name


SELECT
  'ALTER TABLE [' + t.name + '] DROP CONSTRAINT ' + c.name
FROM sys.check_constraints c JOIN
  sys.tables t ON
    t.object_id = c.parent_object_id

SELECT t.name, c.name FROM sys.check_constraints c JOIN
  sys.tables t ON
    t.object_id = c.parent_object_id
```

### Query

##### To search columns in tables

```sql
SELECT t.name, c.name
FROM
  sys.columns c INNER JOIN
  sys.tables t ON
    t.object_id = c.object_id
WHERE c.name = 'ColumnToBeSearched'
ORDER BY t.name, c.name
```

##### To search table constraints

```sql
select *
from information_schema.table_constraints
where constraint_schema = 'dbo'
```

##### To search table constraints

```sql
select *
from information_schema.referential_constraints
where constraint_schema = 'dbo'
```

#### JOIN

- factors affecting query optimiser in determining which physical join to be used
  - It depends upon the table size
  - It depends upon the index on the join column
  - It depends upon the Sorted order on the join column

##### MERGE JOIN

- match rows from two suitably sorted input tables exploiting their sort order
- very low I/O cost
- lower CPU cost
- possible for the tables have an index on the join column

###### Assuming unique clustered indexes are used

| Table size | With index (both) | Without index (both) | Either table has index |
| --- | --- | --- | --- |
| Big(Both) | MERGE | HASH | HASH |
| Medium(Both) | MERGE | HASH | HASH |
| Small(Both) | NESTED LOOP | HASH | NESTED LOOP |
| Big Vs Small | NESTED LOOP | HASH | NESTED LOOP |

###### Assuming clustered indexes are used

| Table size | With index (both) | Without index (both) | Either table has index |
| --- | --- | --- | --- |
| Big(Both) | HASH | HASH | HASH |
| Medium(Both) | HASH | HASH | HASH |
| Small(Both) | NESTED LOOP | NESTED LOOP | HASH |
| Big Vs Small | HASH | HASH | HASH |


##### HASH JOIN

- use each row from the top input to build a hash table, and each row from the bottom input to probe into the hash table, outputting all matching rows
- higher I/O cost and CPU cost
- possible for the tables with no index or either of the big tables has indexed

##### NESTED LOOP JOIN

- can only be used in INNER JOIN and LEFT JOIN
- possible for small tables with index or either of the big tables have indexed

##### REMOTE JOIN

- should be used only when the left table has fewer rows the right table

##### Cross Join

Effectively a simple cartesian product, or a `LEFT OUTER JOIN` and `RIGHT
OUTER JOIN` applied at the same time. The following are equivalent syntax.

```sql
SELECT * FROM TableA CROSS JOIN TableB
SELECT * FROM TableA, TableB
```

##### Cross Apply

```sql
SELECT *
FROM table1
CROSS APPLY
  (
    SELECT TOP (table1.rowcount) *
    FROM table2name
    ORDER BY id
  ) t2
```

is equivalent to

```sql
SELECT *
FROM
  table1 t1 INNER JOIN
  (
    SELECT
      t2o.*,
      (SELECT COUNT(1) FROM table2 t2i WHERE t2i.id <= t22o.id) AS rn
    FROM table2 t2o
  ) t2 ON t2.rn <= t1.rowcount
```

##### To use cursor

```sql
DECLARE @PhoneID int
DECLARE @Count int

SET @Count=0

CREATE TABLE #PhoneHits
(
  ID int,
  Model varchar(20),
  Hits int
)

DECLARE phone_cursor CURSOR FOR
  SELECT [PhoneID], COUNT([PhoneID])
  FROM Visit
  group by [PhoneID]
  order by COUNT([PhoneID]) desc
OPEN phone_cursor
FETCH NEXT FROM phone_cursor INTO @PhoneID, @Count

WHILE @@FETCH_STATUS = 0
BEGIN
  INSERT INTO #PhoneHits
  SELECT ID, Model, @Count
  FROM Phone
  WHERE ID = @PhoneID

  FETCH NEXT FROM phone_cursor INTO @PhoneID, @Count
END

CLOSE phone_cursor
DEALLOCATE phone_cursor

SELECT * FROM #PhoneHits
DROP TABLE #PhoneHits
```

##### Dynamic query

```sql
CREATE PROCEDURE [dbo].[GetList]
  @UserId int = -1,
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE
    @Columns varchar(MAX),
    @Tables varchar(MAX),
    @Conditions nvarchar(MAX),
    @OrderClauses varchar(MAX)

  SELECT @Columns = '[Examples].[ExampleId]'
  SELECT @Tables = '[Examples]'
  SELECT @Conditions = '[Title] = CAST(@Title as varchar)'
  SELECT @OrderClauses = '[Priority]'

  IF NOT (@UserId=-1)
  BEGIN
    SELECT @Tables = @Tables + 'LEFT OUTER JOIN [Users] u ON u.[UserId] = [Examples].[UserId]'
  END

  EXEC ('SELECT ' + @Columns + ' FROM ' + @Tables + ' WHERE ' + @Conditions + ' ORDER BY ' + @OrderClauses);
END

GO
```

##### To generate ID

```sql
ALTER PROCEDURE [dbo].[AddExample]
  @ExampleText nvarchar(max),
  @ID int out
AS
BEGIN
  INSERT INTO [Examples]([ExampleText])
  VALUES (@ExampleText)

  SELECT @ID = SCOPE_IDENTITY()
END
```

##### Delete trigger

```sql
CREATE TRIGGER [dbo].[TRI_Examples_Delete]
ON [dbo].[Examples] AFTER DELETE
AS BEGIN
  DELETE c
  FROM
    ExampleChildren c INNER JOIN
    DELETED d ON c.[ExampleId] = d.ExampleId
    WHERE c.[IsCannotDelete] <> 1
END

GO
```

##### Insert trigger

```sql
CREATE TRIGGER [dbo].[TRI_Example_Insert]
ON [dbo].[Examples] AFTER INSERT
AS BEGIN
  INSERT INTO ExampleChildren([ExampleId], [Text])
  SELECT
    i.ExampleId AS [ExampleId],
    t.ExampleText AS [Text]
  FROM
    INSERTED i INNER JOIN
    Texts t ON
      i.ExampleId = t.ExampleId
END

GO
```

##### Update trigger

```sql
CREATE TRIGGER [dbo].[TRI_Examples_Update]
ON [dbo].[Examples] AFTER UPDATE
AS BEGIN
  DELETE c
  FROM
    ExampleChildren c INNER JOIN
    DELETED d ON
      c.[ExampleId] IN (
        SELECT c1.ExampleId
        FROM ExampleChildren c1
        WHERE c1.ExampleId = d.ExampleId)

    INSERT INTO ExampleChildren([ExampleId], [Text])
    SELECT
      c.ExampleId AS [ExampleId],
      c.[Text] AS [Text]
    FROM
      ExampleChildren c INNER JOIN
      INSERTED i ON
        c.ExampleId = i.ExampleId
END

GO
```

##### User-defined function

```sql
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsTextExist]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
  DROP FUNCTION [dbo].[IsTextExist]
GO

CREATE FUNCTION [dbo].[IsTextExist]
(
  @TextKey int
)
RETURNS bit(1)
AS
BEGIN
  IF (SELECT COUNT(1) FROM Texts WHERE TextKey = @TextKey) > 0
    RETURN 1
  RETURN 0
END

GO
```

##### Geolocation query

```sql
SELECT location.Lat, location.Long FROM BlogGeoTags
```

##### Example on LastUpdatedDate

```sql
CREATE TABLE [dbo].[ContentFiles](
  [Id] [int] IDENTITY(1,1) NOT NULL,
  [FilePath] [varchar](300) NOT NULL,
  [CreatedDate] [datetime2](3) NOT NULL,
  [CreatedBy] [varchar](50) NOT NULL,
  [LastUpdatedDate] [datetime2](3) NOT NULL,
  [LastUpdatedBy] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ContentFiles] PRIMARY KEY CLUSTERED
(
  [Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[ContentFiles] ADD CONSTRAINT [DF_ContentFiles_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[ContentFiles] ADD CONSTRAINT [DF_ContentFiles_LastUpdatedDate] DEFAULT (getdate()) FOR [LastUpdatedDate]
GO

CREATE TRIGGER [dbo].[TRI_ContentFiles_Update]
ON [dbo].[ContentFiles] AFTER UPDATE
AS BEGIN
    UPDATE [dbo].[ContentFiles]
    SET [LastUpdatedDate] = GETDATE()
    FROM INSERTED i
    WHERE [dbo].[ContentFiles].[Id] = i.Id
END

GO
```

##### Example on adding primary key

```sql
ALTER TABLE UserPermission ADD [Id] [int] IDENTITY(1,1) NOT NULL
GO

ALTER TABLE UserPermission ADD
  CONSTRAINT [PK_UserPermission] PRIMARY KEY CLUSTERED
  (
    [Id] ASC
  )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
```

##### Passing an array to stored procedures

```sql
CREATE TYPE [dbo].[TypeIds] AS TABLE(
  [Id] [INT] NULL
)
GO

CREATE PROC [dbo].[sp_AnImportantProcedure] @Ids TypeIds READONLY
AS
...
```

##### Compare table schema

```sql
DECLARE @table1name VARCHAR(50)
DECLARE @table2name VARCHAR(50)

SET @table1name = 'OpenEntry'
SET @table2name = 'ClosedEntry'

SELECT t1.*, t2.*
FROM
(
  SELECT t.name AS TableName, c.name AS ColumnName, c.system_type_id, c.is_nullable, c.max_length, c.precision
  FROM
    sys.columns c INNER JOIN
    sys.tables t ON
      c.object_id = t.object_id
  WHERE
    t.name = @table1name
) t1 FULL JOIN
(
  SELECT t.name AS TableName, c.name AS ColumnName, c.system_type_id, c.is_nullable, c.max_length, c.precision
  FROM
    sys.columns c INNER JOIN
    sys.tables t ON
      c.object_id = t.object_id
  WHERE t.name = @table2name
) t2 ON
  t2.ColumnName = t1.ColumnName AND
  t2.system_type_id = t1.system_type_id AND
  t2.is_nullable = t1.is_nullable
```

##### Geo-locations

Type `GEOGRAPHY` is available since MSSQL Server 2008.

To update data to a column of type `GEOGRAPHY`,

```sql
UPDATE MyTable SET MyLocation = GEOGRAPHY::Point(22, 116, 4326)
```

where `4326` is a commonly used GPS system.

Function `.STAsText()` shows coordinates as string in a single field whereas`.STDistance()` shows distance between two points in metres.

##### Collation

To change the collation of a column,

```sql
ALTER TABLE MyTable ALTER COLUMN MyColumn VARCHAR(10) COLLATE Latin1_General_CI_AS NOT NULL;
```

### Troubleshooting

##### To check network connection

```sh
telnet your-mssql-server.example.com 1433
```

Note if the connection works fine, a blank page would be shown; an error
message would be shown, otherwise.
