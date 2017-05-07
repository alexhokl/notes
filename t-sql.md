##### Shrink database
```sql
ALTER DATABASE ExampleDatabaseName SET RECOVERY SIMPLE WITH NO_WAIT
DBCC SHRINKFILE(ExampleDatabaseName_log, 1)
ALTER DATABASE ExampleDatabaseName SET RECOVERY FULL WITH NO_WAIT
GO
```

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
