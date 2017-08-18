# Database and T-SQL

### Tools

- [Instant SQL Formatter](http://www.dpriver.com/pp/sqlformat.htm)

### Database Operations

##### Restore a database from File

```sql
RESTORE DATABASE [MyDatabaseName] FROM DISK='C:\backup\MyDatabaseName.bak' WITH RECOVERY, MOVE 'MyDatabaseName' TO 'C:\backup\MyDatabaseName.mdf', MOVE 'MyDatabaseName_log' TO 'C:\backup\MyDatabaseName_log.ldf'
GO
```

##### Attach a database

Make sure that the folders containing the database files are granted with write permissions for the MSSQL server process
(Check "Logon" tab in `services.msc`).

```sql
CREATE DATABASE AssetsDB ON
(FILENAME = N'c:\database\AssetsDB_Primary.mdf'),
(FILENAME = N'c:\database\AssetsDB_Primary.ldf')
FOR ATTACH;
```

If the attached database is running as read-only mode due to the file permissions,
fix the file permissions and run `ALTER DATABASE [DatabaseName] SET READ_WRITE` to make it running in non-read-only mode again.

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
		DBCC DBREINDEX(@TableName ,'', 70);
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

### Database performance

##### To clean up SQL server cache

```sql
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
```

##### To check query warnings via execution plan

1. Make a query via Management Studio with execution plan enabled
2. Right click on any blank space on the execution plan
3. Select "Show Execution Plan XML..."
4. Search for `warnings`

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

### Database table manipulations

##### To modify column definition
``` sql
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

### Query

##### Cross Join

Effectively a simple cartesian product, or a `LEFT OUTER JOIN` and `RIGHT
OUTER JOIN` applied at the same time.
The following are equivalent syntax.

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

##### Geo-locations

Type `GEOGRAPHY` is available since MSSQL Server 2008.

To update data to a column of type `GEOGRAPHY`,

```sql
UPDATE MyTable SET MyLocation = GEOGRAPHY::Point(22, 116, 4326)
```

where 4326 is a commonly used GPS system.

Function `.STAsText()` shows coordinates as string in a single field whereas
`.STDistance()` shows distance between two points in metres.

##### Collation

To change the collation of a column,

```sql
ALTER TABLE MyTable ALTER COLUMN MyColumn VARCHAR(10) COLLATE Latin1_General_CI_AS NOT NULL;
```
