 /* TRUNCATE ALL TABLES IN A DATABASE */
DECLARE @dropAndCreateConstraintsTable TABLE
        (
         DropStmt VARCHAR(MAX)
        ,CreateStmt VARCHAR(MAX)
        )
/* Gather information to drop and then recreate the current foreign key constraints  */
INSERT  @dropAndCreateConstraintsTable
        SELECT  DropStmt = 'ALTER TABLE [' + ForeignKeys.ForeignTableSchema
                + '].[' + ForeignKeys.ForeignTableName + '] DROP CONSTRAINT ['
                + ForeignKeys.ForeignKeyName + ']; '
               ,CreateStmt = 'ALTER TABLE [' + ForeignKeys.ForeignTableSchema
                + '].[' + ForeignKeys.ForeignTableName
                + '] WITH CHECK ADD CONSTRAINT [' + ForeignKeys.ForeignKeyName
                + '] FOREIGN KEY([' + ForeignKeys.ForeignTableColumn
                + ']) REFERENCES [' + SCHEMA_NAME(sys.objects.schema_id)
                + '].[' + sys.objects.[name] + ']([' + sys.columns.[name]
                + ']); '
        FROM    sys.objects
        INNER JOIN sys.columns
                ON ( sys.columns.[object_id] = sys.objects.[object_id] )
        INNER JOIN ( SELECT sys.foreign_keys.[name] AS ForeignKeyName
                           ,SCHEMA_NAME(sys.objects.schema_id) AS ForeignTableSchema
                           ,sys.objects.[name] AS ForeignTableName
                           ,sys.columns.[name] AS ForeignTableColumn
                           ,sys.foreign_keys.referenced_object_id AS referenced_object_id
                           ,sys.foreign_key_columns.referenced_column_id AS referenced_column_id
                     FROM   sys.foreign_keys
                     INNER JOIN sys.foreign_key_columns
                            ON ( sys.foreign_key_columns.constraint_object_id = sys.foreign_keys.[object_id] )
                     INNER JOIN sys.objects
                            ON ( sys.objects.[object_id] = sys.foreign_keys.parent_object_id )
                     INNER JOIN sys.columns
                            ON ( sys.columns.[object_id] = sys.objects.[object_id] )
                               AND ( sys.columns.column_id = sys.foreign_key_columns.parent_column_id )
                   ) ForeignKeys
                ON ( ForeignKeys.referenced_object_id = sys.objects.[object_id] )
                   AND ( ForeignKeys.referenced_column_id = sys.columns.column_id )
        WHERE   ( sys.objects.[type] = 'U' )
                AND ( sys.objects.[name] NOT IN ( 'sysdiagrams' ) )
/* SELECT * FROM @dropAndCreateConstraintsTable AS DACCT  --Test statement*/
DECLARE @DropStatement NVARCHAR(MAX)
DECLARE @RecreateStatement NVARCHAR(MAX)
/* Drop Constraints */
DECLARE Cur1 CURSOR READ_ONLY
FOR
        SELECT  DropStmt
        FROM    @dropAndCreateConstraintsTable
OPEN Cur1
FETCH NEXT FROM Cur1 INTO @DropStatement
WHILE @@FETCH_STATUS = 0
      BEGIN
            PRINT 'Executing ' + @DropStatement
            EXECUTE sp_executesql @DropStatement
            FETCH NEXT FROM Cur1 INTO @DropStatement
      END
CLOSE Cur1
DEALLOCATE Cur1
/* Truncate all tables in the database in the dbo schema */
DECLARE @DeleteTableStatement NVARCHAR(MAX)
DECLARE Cur2 CURSOR READ_ONLY
FOR
        SELECT  'TRUNCATE TABLE [dbo].[' + TABLE_NAME + ']'
        FROM    INFORMATION_SCHEMA.TABLES
        WHERE   TABLE_SCHEMA = 'dbo'
                AND TABLE_TYPE = 'BASE TABLE'
  /* Change your schema appropriately if you don't want to use dbo */
OPEN Cur2
FETCH NEXT FROM Cur2 INTO @DeleteTableStatement
WHILE @@FETCH_STATUS = 0
      BEGIN
            PRINT 'Executing ' + @DeleteTableStatement
            EXECUTE sp_executesql @DeleteTableStatement
            FETCH NEXT FROM Cur2 INTO @DeleteTableStatement
      END
CLOSE Cur2
DEALLOCATE Cur2
/* Recreate foreign key constraints  */
DECLARE Cur3 CURSOR READ_ONLY
FOR
        SELECT  CreateStmt
        FROM    @dropAndCreateConstraintsTable
OPEN Cur3
FETCH NEXT FROM Cur3 INTO @RecreateStatement
WHILE @@FETCH_STATUS = 0
      BEGIN
            PRINT 'Executing ' + @RecreateStatement
            EXECUTE sp_executesql @RecreateStatement
            FETCH NEXT FROM Cur3 INTO @RecreateStatement
      END
CLOSE Cur3
DEALLOCATE Cur3
GO

