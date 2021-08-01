- [Tools](#tools)
- [Table manipulations](#table-manipulations)
  * [Table](#table)
  * [Column](#column)
  * [Collation](#collation)
  * [Constraints](#constraints)
  * [Stored procedures](#stored-procedures)
  * [Joins](#joins)
  * [Cursor](#cursor)
  * [Dynamic query](#dynamic-query)
  * [Triggers](#triggers)
  * [User-defined function](#user-defined-function)
  * [Primary key](#primary-key)
  * [Geo-locations](#geo-locations)
  * [Examples](#examples)
____

## Tools

- [Instant SQL Formatter](http://www.dpriver.com/pp/sqlformat.htm)

## Table manipulations

### Table

##### Rename a table

```sql
EXEC sp_rename 'OldTableName', 'NewTableName'
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

### Column

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

##### To modify column definition

```sql
ALTER TABLE Examples ALTER COLUMN ExampleId VARCHAR(20) NOT NULL
```

##### Example on column insertion

```sql
ALTER TABLE Examples ADD [Title] NVARCHAR(50) NULL
```

##### Rename a column

```sql
EXEC sp_rename
    @objname = 'TableName.OldColumnName',
    @newname = 'NewColumnName',
    @objtype = 'COLUMN'
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

### Collation

##### To change the collation of a column

```sql
ALTER TABLE MyTable ALTER COLUMN MyColumn VARCHAR(10) COLLATE Latin1_General_CI_AS NOT NULL;
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

### Constraints

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

##### Drop a constraint

```sql
ALTER TABLE MyTable DROP CONSTRAINT MyTable_Contraint
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

### Stored procedures

##### To list all stored procedures

```sql
SELECT name, type FROM sys.objects WHERE [type] = 'P'
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

### Joins

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

### Cursor

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

### Dynamic query

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

### Triggers

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

### User-defined function

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

### Primary key

##### Altering primary key

```sql
ALTER TABLE Examples ADD PRIMARY KEY([ExampleId], [UserId])
```


##### Example on primary key

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

### Geo-locations

Type `GEOGRAPHY` is available since MSSQL Server 2008.

To update data to a column of type `GEOGRAPHY`,

```sql
UPDATE MyTable SET MyLocation = GEOGRAPHY::Point(22, 116, 4326)
```

where `4326` is a commonly used GPS system.

Function `.STAsText()` shows coordinates as string in a single field whereas`.STDistance()` shows distance between two points in metres.

##### Geolocation query

```sql
SELECT location.Lat, location.Long FROM BlogGeoTags
```

### Examples

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
