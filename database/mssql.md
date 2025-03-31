- [Links](#links)
- [Tools](#tools)
- [Troubleshooting](#troubleshooting)
- [Database Operations](#database-operations)
  * [Backup](#backup)
  * [Recovery models](#recovery-models)
  * [Size management](#size-management)
  * [User modes](#user-modes)
  * [Login](#login)
  * [Encryption](#encryption)
  * [Queries](#queries)
- [Database performance](#database-performance)
  * [Troubleshooting perfromance issues](#troubleshooting-perfromance-issues)
  * [Statistics](#statistics)
  * [Memory](#memory)
  * [Query plans](#query-plans)
  * [Indexes](#indexes)
  * [Locks and blocking processes](#locks-and-blocking-processes)
  * [General information](#general-information)
  * [Read-only replica and snapshot isolation](#read-only-replica-and-snapshot-isolation)
  * [Wait types](#wait-types)
  * [Jobs](#jobs)
  * [CPU and parallelism](#cpu-and-parallelism)
  * [Linked servers](#linked-servers)
  * [Table partitioning](#table-partitioning)
  * [User-defined function (UDF)](#user-defined-function-udf)
  * [LIKE wildcard queries](#like-wildcard-queries)
  * [Untrusted constraints](#untrusted-constraints)
  * [Foreign keys](#foreign-keys)
  * [MERGE statements](#merge-statements)
____

## Links

- [Cloud SQL for SQL Server
  features](https://cloud.google.com/sql/docs/sqlserver/features) and features
  not available on Cloud SQL
- [Installing ODBC drivers on
  Linux](https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server)
- [Editions and supported features of SQL Server
  2019](https://learn.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2019)
- [Database Enginer events and
errors](https://learn.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-events-and-errors) - error codes / numbers
- [Brent Ozar - consulting for quick pain
  relief](https://www.brentozar.com/sql-critical-care/)
- [Brent Ozar - Free How to Think Like the SQL Server Engine
  Course](https://www.brentozar.com/training/think-like-sql-server-engine/)

## Tools

- [sqlcollaborative/dbatools](https://github.com/sqlcollaborative/dbatools)
  powershell commands
- [Brent Ozar - Paste the plan](https://www.brentozar.com/pastetheplan/) -
  visualising query plan
- [BrentOzarULTD/SQL-Server-First-Responder-Kit](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit)
- [Plan Explorer](https://www.solarwinds.com/free-tools/plan-explorer) - a free
  tool from SolarWinds to visualise query plans, index and statistics analysis;
  paid full version is available

## Troubleshooting

##### To check network connection

```sh
telnet your-mssql-server.example.com 1433
```

Note if the connection works fine, a blank page would be shown; an error
message would be shown, otherwise.

##### Error message on restore

```
MODIFY FILE encountered operating system error 31(A device attached to the
system is not functioning.) while attempting to expand the physical file
'/var/opt/mssql/data/TestDB.mdf'.
```

It is likely that the disk is full.

##### Use of JOIN HINT

It should be used as a last resort by experienced developers and database
administrators.

## Database Operations

### Backup

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

##### To check logical names of a backup file

```sql
RESTORE FILELISTONLY FROM DISK = '/tmp/backup/your-databse.bak' WITH FILE = 1
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

### Recovery models

- recovery models are designed to control transaction log maintenance
- simple
  * no log backup
  * saving disk space for transaction logs
  * implies
    + no log shipping
    + no point-in-time recovery
    + no always-on or database mirroring
- full
  * requires log backup
- bulk-logged
  * requires log backup
  * permits high-performance bulk copy operations
  * reduces log space usage by using minimal logging for most bulk operations
    + log backups might be of a significant size because the minimally logged
      operations are captured in the log backup
  * no point-in-time recovery support

### Size management

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
    TotalSpaceMB DESC
```

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

##### To shrink tempdb

Usually `tempdb` is mostly occupied by query plan cache. Thus, the step before
shrink the database is to apply

```sql
DBCC FREEPROCCACHE
```

Shinking `tempdb` will work fine after.

### User modes

To change to single-user mode (usually done at the beginning of a set of operations)

```sql
ALTER DATABASE MyCustomDatabaseName SET SINGLE_USER
```

To change to multi-user mode (usually done at the end of a set of operations)

```sql
ALTER DATABASE MyCustomDatabaseName SET MULTI_USER
```

### Login

##### To list all logins

```sql
SELECT name FROM sys.sql_logins
```

##### Re-enable SQL login and change its password

```sql
ALTER LOGIN YourSqlLoginName ENABLE
ALTER Login YourSqlLoginName WITH PASSWORD = 'SomeStrongPassword'
```

##### To list all roles

```sql
SELECT name FROM sys.database_principals WHERE type = 'R'
```

##### To list mapping between roles and logins

```sql
SELECT DP1.name AS DatabaseRoleName,
    isnull (DP2.name, '') AS DatabaseUserName
FROM sys.database_role_members AS DRM
RIGHT OUTER JOIN sys.database_principals AS DP1
    ON DRM.role_principal_id = DP1.principal_id
LEFT OUTER JOIN sys.database_principals AS DP2
    ON DRM.member_principal_id = DP2.principal_id
WHERE DP1.type = 'R'
ORDER BY DP1.name;
```

##### To list mappings between database and logins

```sql
CREATE TABLE #tempww (
    LoginName nvarchar(max),
    DBname nvarchar(max),
    Username nvarchar(max),
    AliasName nvarchar(max)
)

INSERT INTO #tempww
EXEC master..sp_msloginmappings

-- display results
SELECT LoginName, DBname, Username
FROM   #tempww
ORDER BY dbname, username

-- cleanup
DROP TABLE #tempww
```

Note that `LoginName` is added at server level while `Username` is added at
a database level.

##### To grant table read permission to a database user

```sql
GRANT SELECT ON your-table-name TO your-database-username
```

##### To grant read permission of a database to a database user

```sql
USE [your-datbase-name]
GRANT SELECT TO your-database-username
```

##### To grant permissions on GCP Cloud SQL

```sql
GRANT VIEW SERVER STATE TO [someone] AS CustomerDbRootRole
```

where `CustomerDbRootRole` is a role created by GCP.

Reference: [Granting server
permissions](https://cloud.google.com/sql/docs/sqlserver/users#grant-command)

The above example grants the permission to run stored procedures such as
`sp_who2`.

##### To create a login

```sql
CREATE LOGIN your-login
  WITH PASSWORD = 'your-password',
  DEFAULT_DATABASE = your-database;
GO

USE your-database
CREATE USER your-login FOR LOGIN your-login;
GO

ALTER ROLE db_datareader ADD MEMBER your-login;
GO
```

### Encryption

##### To list encrpytion keys setup

```sql
SELECT d.name, d.is_encrypted, k.encryption_state, k.encryption_state_desc, k.encryption_scan_state_desc
FROM
  sys.dm_database_encryption_keys k JOIN
  sys.databases d ON
    d.database_id = k.database_id
```

where `encryption_state` can be interpreted as

| Value | Description                                                                                                                        |
| ---   | ---                                                                                                                                |
| 0     | No database encryption key present, no encryption                                                                                  |
| 1     | Unencrypted                                                                                                                        |
| 2     | Encryption in progress                                                                                                             |
| 3     | Encrypted                                                                                                                          |
| 4     | Key change in progress                                                                                                             |
| 5     | Decryption in progress                                                                                                             |
| 6     | Protection change in progress (The certificate or asymmetric key that is encrypting the database encryption key is being changed.) |

##### To remove TDE (encryption at rest)

```sql
ALTER DATABASE your_database_name SET ENCRYPTION OFF
DROP DATABASE ENCRYPTION KEY
```

### Queries

##### To find a default constraint of a column

```sql
SELECT name
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('your_table_name')
AND parent_column_id = COLUMNPROPERTY(OBJECT_ID('your_table_name'), 'your_column_name', 'ColumnId');
```

##### To find table name of a constraint

```sql
SELECT
    OBJECT_NAME(parent_object_id) AS TableName,
    name AS ConstraintName,
    type_desc AS ConstraintType
FROM sys.objects
WHERE type_desc LIKE '%CONSTRAINT'
    AND name = 'DF__YourTab__YourCol__1DDC1E2F'
```

## Database performance

### Troubleshooting perfromance issues

- [Troubleshooting performance
  issues](https://docs.microsoft.com/en-us/azure/azure-sql/database/intelligent-insights-troubleshoot-performance)
- [Understand blocking
  problems](https://docs.microsoft.com/en-us/azure/azure-sql/database/understand-resolve-blocking)
- [Resolve blocking problems caused by lock escalation in SQL
  Server](https://docs.microsoft.com/en-GB/troubleshoot/sql/performance/resolve-blocking-problems-caused-lock-escalation)

### Statistics

- optimizer alaways assume table variables to have a single row
- temporary tables has statistics generated as in other normal tables
- statistics can get updated after a query edxecution if optizimer finds the
  plan was out of date or have changed since the original plan was created
- the main cause of a difference between the plan is differences beetween the
  statistics and the actual data
- automatic update of statistics that occurs only samples a subset of the data
  in order to reduce the cost of the operation

##### To show statistics as message

```sql
SET STATISTICS io ON, TIME on

SELECT *
FROM YourTable t
```

Reference: [Reading
Pages](https://docs.microsoft.com/en-us/sql/relational-databases/reading-pages)

> The I/O from an instance of the SQL Server Database Engine includes logical
> and physical reads. A logical read occurs every time the Database Engine
> requests a page from the buffer cache. If the page is not currently in the
> buffer cache, a physical read first copies the page from disk into the cache.

### Memory

##### Managed instance

Ref: [Do you need more memory on Azure SQL Managed
Instance?](https://techcommunity.microsoft.com/t5/azure-sql/do-you-need-more-memory-on-azure-sql-managed-instance/ba-p/563444)

Checking memory usage on a managed instance may not be the best metric to
understand memory pressure. A better metric is page life expectancy (PLE) where
it indicates how many seconds the pages live in the memory before they are
flushed back to disk. The higher this value is, the better. The minimum value of
PLE corresponds to the total buffer pool memory available. The following query
serves buffer pool memory, PLE and the minimum PLE. Note that the query only
indicates the situation at the time of running.

```sql
SELECT
  v.object_name,
  bp_mem_gb = (l.cntr_value*8/1024)/1024,
  ple = v.cntr_value,
  min_ple = (((l.cntr_value*8/1024)/1024)/4)*300
FROM
  sys.dm_os_performance_counters v JOIN
  sys.dm_os_performance_counters l ON
    v.object_name = l.object_name
WHERE
  v.counter_name = 'Page Life Expectancy' AND
  l.counter_name = 'Database pages' AND
  l.object_name LIKE '%Buffer Node%'
```

If PLE is very close to its minimum value, one should investigate more into the
issue and consider enlarging the size of the instance.

### Query plans

- execution plans are not kept in memory forever
  * it aged out of the system using an "age" formula that multiplies the
    estimated cost of the plan by the number of times it has been used
- untrusted contraints are not used
  * these contraints usually created by the operation of dropping constraints,
    foreign keys, or indexes to import a large amount of data
  * see section [Untrusted constraints](#untrusted-constraints)

#### Memory grant

Adaptive Query processing is a feature available since SQL Server 2017 and it
improves the performance of the queries by adjusting the memory grant based on
the actual data processed in previous executions. In subsequent executions of
the same query, the memory grant is adjusted automatically and it may lead to
a better execution plan or less memory grant waiting.

Row mode memory grant feedback is a feature available since SQL Server 2019 and
it can be enabled by

```sql
ALTER DATABASE SCOPED CONFIGURATION SET ROW_MODE_MEMORY_GRANT_FEEDBACK = ON;
```

or disabled by

```sql
ALTER DATABASE SCOPED CONFIGURATION SET ROW_MODE_MEMORY_GRANT_FEEDBACK = OFF;
```

To troubleshoot memory grant updates, extended event
`query_post_execution_showplan` can be used. The event is fired after a SQL
statement is executed. This event can be found in XML representation of the
actual query plan. Note that enabling this event can create a significant amount
of performance overhead, so it should be used only when troubleshooting or
monitoring specific problems for brief periods of time.

#### Other topics

##### To grant permission to view execution plans

- if the user has role `sysadmin`, `dbcreator` or `db_owner`, the user has the
  permission already

For other users,

```sql
GRANT SHOWPLAN TO [username]
```

##### To remove plan cache entries

and remove all clean buffers

```sql
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
```

##### To show plans in Management Studio

- `ctrl-l` to get estimated plan
- `ctrl-m` to get actual plan

##### To show estimated text plans

```sql
SET SHOWPLAN_ALL ON;
```

It is important to remember to `SET SHOWPLAN_ALL OFF` after an investigation has
been completed; statements of `CREATE`, `UPDATE` or `DELETE` would not be
executed, otherwise.

##### To show actual text plans

```sql
SET STATISTICS PROFILE ON;
```

and, to turn it off,

```sql
SET STATISTICS PROFILE OFF;
```

##### Understanding query plans

- Index scan involves checking values of all rows in a table
- Index seek involves only values of rows matching a specific criteria

##### To check query history

##### To check query warnings via execution plan in Management Studio

1.  Make a query via Management Studio with execution plan enabled
2.  Right click on any blank space on the execution plan
3.  Select "Show Execution Plan XML..."
4.  Search for `warnings`

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

### Indexes

Reference: [Optimize index maintenance to improve query performance and reduce
  resource consumption](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/reorganize-and-rebuild-indexes)

- Index Fragmentation percentage varies when the logical page orders do not
  coordinate with the physical page order in the page allocation of an index
  - high fragmentation percentage has a bigger impact on query requires reading
    many pages using full or range index scans
  - When page density is low, more pages are required to store the same amount
    of data. This means that more I/O is necessary to read and write this data,
    and more memory is necessary to cache this data
  - When Database Engine adds rows to a page, it will not fill the page fully if
    the fill factor for the index is set to a value other than 100 (or 0, which
    is equivalent in this context); the default fill factor is 100.
  - When the Query Optimizer compiles a query plan, it considers the cost of I/O
    needed to read the data required by the query. With low page density, there
    are more pages to read, therefore the cost of I/O is higher
  - To avoid lowering page density unnecessarily, Microsoft does not recommend
    setting fill factor to values other than 100 or 0, except in certain cases
    for indexes experiencing a high number of page splits, for example
    frequently modified indexes with leading columns containing non-sequential
    GUID values.
- `REBUILD` or `REORGANIZE` indexes should be done in off-peak hours
  - Reorganizing an index is less resource intensive than rebuilding an index
- Rebuild an index implies dropping and re-create index and its related
  statistics, and creating entries to log files
  - An index rebuild has an important side benefit where it updates statistics
    on key columns of the index by scanning all rows in the index. This is the
    equivalent of executing `UPDATE STATISTICS ... WITH FULLSCAN`
  - For most types of storage used in Azure SQL Database and Azure SQL Managed
    Instance, there is no difference in performance between sequential I/O and
    random I/O. This reduces the impact of index fragmentation on query
    performance.
- `REORGANIZE INDEX` reorders the index page by expelling the free or unused
  space on the page. Ideally, index pages are reordered physically in the data
  file. REORGANIZE does not drop and create the index but simply restructure the
  information on the page
  - `REORGANIZE` always performs online
  - defragments only the leaf level of clustered and nonclustered indexes on
    tables and views by physically reordering the leaf-level pages to match the
    logical order of the leaf nodes
    - whereas rebuild defragments at all levels
  - Azure SQL Database, and Azure SQL Managed Instance, the tuple-mover is
    helped by a background merge task that automatically compresses smaller open
    delta rowgroups that have existed for some time as determined by an internal
    threshold, or merges compressed rowgroups from where a large number of rows
    has been deleted. This improves the columnstore index quality over time. For
    most cases this dismisses the need for issuing `ALTER INDEX ... REORGANIZE`
    commands.
  - If you cancel a reorganize operation, or if it is otherwise interrupted, the
    progress it made to that point is persisted in the database. To reorganize
    large indexes, the operation can be started and stopped multiple times until
    it completes.

##### To rebuild an index

```sql
ALTER INDEX Index_Name ON Table_Name REBUILD WITH(ONLINE=ON)
```

where `WITH(ONLINE=ON)` indicates rebuild should be done online (an enterprise
feature) which does not affect the running requests and tasks of a similar
table. (If "offline", the table of the index would not be accessible till the
end of `REBUILD` process completion.

Note that `DBCC DBREINDEX` is an offline operation.

##### To rebuild indexes of a table

```sql
ALTER INDEX ALL ON Production.Product REBUILD;
```

##### To re-organise (defragment) an index

```sql
ALTER INDEX ALL ON HumanResources.Employee REORGANIZE;
```

##### To show indexes of a table

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

##### To find out statistics update effectiveness

```sql
SELECT
    OBJECT_SCHEMA_NAME(obj.object_id) SchemaName,
    obj.name TableName,
    stat.name,
    modification_counter,
    [rows],
    rows_sampled,
    rows_sampled* 100 / [rows] AS [% Rows Sampled],
    last_updated
FROM sys.objects AS obj
INNER JOIN sys.stats AS stat ON stat.object_id = obj.object_id
CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
WHERE obj.is_ms_shipped = 0
--and obj.name ='tablename'
ORDER BY modification_counter DESC
```

##### Rebuild indexes

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
    ALTER INDEX ALL ON @Table REBUILD;
    -- DBCC DBREINDEX(@TableName ,'', 100);
  END TRY
  BEGIN CATCH
     PRINT @TableName + ' Failed to reindex';
  END CATCH

  FETCH NEXT FROM TableCursor INTO @TableName
END

CLOSE TableCursor
DEALLOCATE TableCursor
```

##### Update statistics

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

##### To update broken (or no) statistics of a table

```sql
UPDATE STATISTICS MyCustomTableName WITH FULLSCAN
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

A detailed explanation using query plan - [SQL Server Indexes with Included
Columns](http://www.sqlservertutorial.net/sql-server-indexes/sql-server-indexes-with-included-columns/)

### Locks and blocking processes

- references
  * [Transaction (Process ID) was deadlocked on lock resources with another
  process and has been chosen as the deadlock victim (Msg
  1205)](https://sqlbak.com/academy/transaction-process-id-was-deadlocked-on-lock-resources-with-another-process-and-has-been-chosen-as-the-deadlock-victim-msg-1205/)
- deadlock graphs are stored in extended events of `system_health` session
  * Management Studio
    + `Management` -> `Extended Events` -> `Sessions` -> `system_health` ->
      `package0.event_file` -> `View Target Data`
    + resource section shows the contention

#### Schema locks

- types
  * SCH-S – schema stability lock
  * SCH-M - schema modification lock
- SCH-S
  * it is acquired by DML statements and held for duration of the statement
  * it will be acquired even in read uncommitted level
  * multiple SCH-S locks on the same table by different queries can be granted
    at the same time
    + however, it blocks acquiring of SCH-M (from an alter table operation) and
      intent lock (IX) (from an insert statement).
- SCH-M
  * it is acquired by sessions that are altering the metadata and live for
    duration of transaction
  * this lock can be described as super-exclusive lock

#### Transactions read data before an update

- without doing anything, usually both transactions will be acquire `S-lock`
  during the read operation; however, when any of the process tries to update,
  it deadlocks as it tries to wait for `S-lock` to be released
  * hint `WITH (UPDLOCK)` can be used in the read operation to acquire `U-lock`
    instead of `S-lock` during the read operation; the other transaction will
    wait for the `U-lock` to be released and, thus, avoid deadlock

#### Deadlock priority

- `DEADLOCK_PRIORITY` can be set to allow database to choose which session to
  kill
  * it is set to `NORMAL` or `0` by default
  * the higher the number or level, the better chance the session will survive

##### To check deadlock priority

```sql
SELECT session_id, DEADLOCK_PRIORITY
FROM sys.dm_exec_sessions
WHERE SESSION_ID = @@SPID
```

#### Other topics

##### Check current locks on a table

```sql
SELECT * FROM sys.dm_tran_locks
WHERE
    resource_database_id = DB_ID() AND
    resource_associated_entity_id = OBJECT_ID(N'dbo.YourTableName');
```

To check application locks,

```sh
SELECT *
FROM   sys.dm_tran_locks
WHERE  resource_type = 'APPLICATION'
       AND request_mode = 'X'
       AND request_status = 'GRANT'
```

##### To find table locks

```sh
SELECT DISTINCT
  spid,
  sp.[status],
  loginame [Login],
  hostname,
  blocked BlkBy,
  sd.name DBName,
  IIF(resource_type = 'OBJECT', OBJECT_NAME(dl.resource_associated_entity_id), OBJECT_NAME(p.OBJECT_ID)) ObjectName,
  cmd Command,
  cpu CPUTime,
  physical_io DiskIO,
  last_batch LastBatch,
  [program_name] ProgramName,
  request_mode LockRequestMode,
  request_type LockRequestType,
  request_status LockRequestStatus,
  txt.text Query
FROM
  master.dbo.sysprocesses sp JOIN
  master.dbo.sysdatabases sd ON
    sp.dbid = sd.dbid JOIN
  master.sys.dm_tran_locks dl ON
    dl.request_session_id = sp.spid LEFT JOIN
  master.sys.dm_exec_requests ec ON
    ec.session_id = dl.request_session_id OUTER APPLY
  master.sys.dm_exec_Sql_text(ec.sql_handle) txt LEFT JOIN
  master.sys.partitions p ON
    p.hobt_id = dl.resource_associated_entity_id LEFT JOIN
  master.sys.indexes i ON
    i.OBJECT_ID = p.OBJECT_ID AND
    i.index_id = p.index_id
WHERE
  (blocked <> 0 AND (IIF(resource_type = 'OBJECT', OBJECT_NAME(dl.resource_associated_entity_id), OBJECT_NAME(p.OBJECT_ID)) IS NOT NULL AND txt.text IS NOT NULL)) OR
  (blocked = 0 AND spid IN (SELECT CAST(blocked AS INT) FROM master.dbo.sysprocesses sp))
ORDER BY spid
```

##### To show deadlock graphs

```sql
WITH CTE AS (
    SELECT CAST(event_data AS XML)  AS [target_data_XML]
    FROM sys.fn_xe_telemetry_blob_target_read_file('dl', null, null, null)
)
SELECT
    target_data_XML.value('(/event/@timestamp)[1]', 'DateTime2') AS Timestamp,
    target_data_XML.query('/event/data[@name=''xml_report'']/value/deadlock') AS deadlock_xml,
    target_data_XML.query('/event/data[@name=''database_name'']/value').value('(/value)[1]', 'nvarchar(100)') AS db_name
FROM CTE
```

##### To show blocking processes

```sql
SELECT
    r.session_id,
    r.plan_handle,
    r.sql_handle,
    r.request_id,
    r.start_time,
    r.status,
    r.command,
    r.database_id,
    r.user_id,
    r.wait_type,
    r.wait_time,
    r.last_wait_type,
    r.wait_resource,
    r.total_elapsed_time,
    r.cpu_time,
    r.transaction_isolation_level,
    r.row_count,st.text
FROM
    sys.dm_exec_requests r CROSS APPLY
    sys.dm_exec_sql_text(r.sql_handle) as st
WHERE
    r.blocking_session_id = 0 and
    r.session_id in (SELECT distinct(blocking_session_id) FROM sys.dm_exec_requests)
GROUP BY
    r.session_id,
    r.plan_handle,
    r.sql_handle,
    r.request_id,
    r.start_time,
    r.status,
    r.command,
    r.database_id,
    r.user_id,
    r.wait_type,
    r.wait_time,
    r.last_wait_type,
    r.wait_resource,
    r.total_elapsed_time,
    r.cpu_time,
    r.transaction_isolation_level,
    r.row_count,st.text
ORDER BY r.total_elapsed_time desc
```

##### To show the current waiting requests

```sql
SELECT * FROM sys.dm_os_waiting_tasks
```

##### To show the historical waiting requests

```sql
SELECT * FROM sys.dm_os_wait_stats ORDER BY waiting_tasks_count DESC
```

Note that the following wait types are of more interest.

1. `CXPACKET`
2. `HADR_WORK_QUEUE`
3. `SOS_SCHEDULER_YIELD`

### General information

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

##### To show machine information

```sql
SELECT * FROM sys.dm_os_sys_info
```

##### To show workers information of CPU

```sql
SELECT * FROM sys.dm_os_schedulers
```

##### To show current configuration

```sql
SELECT * FROM sys.database_scoped_configurations
```

### Read-only replica and snapshot isolation

##### To check if current connected database is a read-only replica

```sql
SELECT DATABASEPROPERTYEX(DB_NAME(), 'updateability')
```

##### To understand if the current queries are using a snapshot and its isolation level

```sql
SELECT
    er.session_id,
    er.command,
    st.text,
    er.start_time,
    er.transaction_isolation_level,
    sn.is_snapshot,
    ClientAddress = con.client_net_address
FROM
    sys.dm_tran_active_snapshot_database_transactions SN JOIN
    sys.dm_exec_requests er on
        SN.session_id = er.session_id OUTER APPLY
    sys.dm_exec_sql_text(er.sql_handle) st LEFT JOIN
    sys.dm_exec_sessions ses ON
        ses.session_id = er.session_id LEFT JOIN
    sys.dm_exec_connections con ON
        con.session_id = ses.session_id
```

Note that the possible `transaction_isolation_level` values are

- `0` = Unspecified
- `1` = ReadUncomitted
- `2` = ReadCommitted
- `3` = Repeatable
- `4` = Serializable
- `5` = Snapshot

### Wait types

- `CMEMTHREAD`
  * when a thread is waiting for access to a thread-safe memory object
    (`CMemThread`)
  * potential problems
    + high number of this wait type may suggest excessive concurrent access to
      the same memory object
      + check "cost threshold for parallelism" and "max degree of parallelism"
        (MAXDOP)
      + queries with a high number of read count is more susceptible to this
- `IO_QUEUE_LIMIT`
  * potential problems
    + it usually implies throttling by cloud provider
- `IO_RETRY`
  * a read or write failed due to insufficient resources, and the statement is
    waiting for a retry
- `LOG_RATE_GOVERNOR`
  * potential problems
    + it usually implies throttling by cloud provider
      + check if the traffic of the SQL server hits the limit of storage IOPs
        + if it is, time to use a larger instance as increasing number of CPUs
          increases the limit of IOPs
        + beaware that `16` cores is pretty much the limit as the throughput is
          also limited by IOPs of transaction logs
- `POOL_LOG_RATE_GOVERNOR`
  * see `LOG_RATE_GOVERNOR`.
- `PREEMPTIVE_DEBUG`
  * probably accidentally hit the DEBUG button in SSMS rather than Execute
- `RESMGR_THROTTLED`
  * potential problems
    + it usually implies throttling by cloud provider
      + check setting `GROUP_MAX_REQUESTS`
- `RESOURCE_SEMAPHORE`
  * the server ran out of available memory to run queries, and queries had to
    wait on available memory before they could even start
- `RESOURCE_SEMAPHORE_QUERY_COMPILE`
  * it is a lot like `RESOURCE_SEMAPHORE`, but it means SQL Server did not even
    have enough memory to compile a query plan
    + two position situations
      + underpowered servers
      + really complex queries with dozens or hundreds of joins and it is
        possible even the server involved is powerful
        + SQL Server does not have an easy way to find out the query with the
          highest compilation times
- `SE_REPL*`
  * waiting for the secondary replicas to catch up
- `THREADPOOL`
  * ran out of worker threads, and new queries thought the SQL Server was frozen
    solid
    + the CPU usage might appear to be near zero

### Jobs

##### To list SQL jobs

```sql
SELECT job_id, [name] FROM msdb.dbo.sysjobs;
```

##### To list command of a SQL job step

```sql
SELECT step_id, [database_name], [command]
FROM msdb.dbo.sysjobsteps
WHERE job_id = 'your-job-id'
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

where `run_status` indicates the following statuses.

- `0` Failed
- `1` Succeeded
- `2` Retry
- `3` Cancelled
- `4` In Progress

##### To start a SQL job

```sql
EXEC msdb.dbo.sp_start_job 'your-job-name'
```

or,

```sql
EXEC msdb.dbo.sp_start_job 'your-job-id'
```

##### To delete a SQL job

```sql
EXEC msdb.dbo.sp_delete_job @job_name = 'your-job-name'

```

### CPU and parallelism

- before a query execution, a decision will be made to see if the cost of the
  plan exceeds the threshold for a parallel execution
  * the optimizer will generate a second plan and stored with a different set of
    operations to support parallelism

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

##### To limit parallelism per query

```sql
SELECT *
FROM Sales.SalesOrderDetail
ORDER BY ProductID
OPTION (MAXDOP 1)
```

##### To find out the suggested MAXDOP setting

```sql
DECLARE @hyperthreadingRatio bit
DECLARE @logicalCPUs int
DECLARE @HTEnabled int
DECLARE @physicalCPU int
DECLARE @SOCKET int
DECLARE @logicalCPUPerNuma int
DECLARE @NoOfNUMA int

SELECT
  @logicalCPUs = cpu_count, -- [Logical CPU Count]
  @hyperthreadingRatio = hyperthread_ratio, --  [Hyperthread Ratio]
  @physicalCPU = cpu_count / hyperthread_ratio, -- [Physical CPU Count]
  @HTEnabled = CASE
    WHEN cpu_count > hyperthread_ratio
        THEN 1
    ELSE 0
    END -- HTEnabled
FROM sys.dm_os_sys_info
OPTION (recompile);

SELECT @logicalCPUPerNuma = COUNT(parent_node_id) -- [NumberOfLogicalProcessorsPerNuma]
FROM sys.dm_os_schedulers
WHERE
  [status] = 'VISIBLE ONLINE' AND
  parent_node_id < 64
GROUP BY parent_node_id
OPTION (recompile);

SELECT @NoOfNUMA = COUNT(DISTINCT parent_node_id)
FROM sys.dm_os_schedulers -- find NO OF NUMA Nodes
WHERE
  [status] = 'VISIBLE ONLINE' AND
  parent_node_id < 64

-- Report the recommendations ....
SELECT
    --- 8 or less processors and NO HT enabled
    CASE
        WHEN @logicalCPUs < 8
            AND @HTEnabled = 0
            THEN 'MAXDOP setting should be : ' + CAST(@logicalCPUs AS VARCHAR(3))
                --- 8 or more processors and NO HT enabled
        WHEN @logicalCPUs >= 8
            AND @HTEnabled = 0
            THEN 'MAXDOP setting should be : 8'
                --- 8 or more processors and HT enabled and NO NUMA
        WHEN @logicalCPUs >= 8
            AND @HTEnabled = 1
            AND @NoofNUMA = 1
            THEN 'MaxDop setting should be : ' + CAST(@logicalCPUPerNuma / @physicalCPU AS VARCHAR(3))
                --- 8 or more processors and HT enabled and NUMA
        WHEN @logicalCPUs >= 8
            AND @HTEnabled = 1
            AND @NoofNUMA > 1
            THEN 'MaxDop setting should be : ' + CAST(@logicalCPUPerNuma / @physicalCPU AS VARCHAR(3))
        ELSE ''
        END AS Recommendations
```

##### To get the current CPU, memory and I/O usage

```sql
SELECT
AVG(avg_cpu_percent) AS 'Average CPU Utilization In Percent',
MAX(avg_cpu_percent) AS 'Maximum CPU Utilization In Percent',
AVG(avg_data_io_percent) AS 'Average Data IO In Percent',
MAX(avg_data_io_percent) AS 'Maximum Data IO In Percent',
AVG(avg_log_write_percent) AS 'Average Log Write I/O Throughput Utilization In Percent',
MAX(avg_log_write_percent) AS 'Maximum Log Write I/O Throughput Utilization In Percent',
AVG(avg_memory_usage_percent) AS 'Average Memory Usage In Percent',
MAX(avg_memory_usage_percent) AS 'Maximum Memory Usage In Percent'
FROM sys.dm_db_resource_stats;
```

##### To get the average CPU usage of the last few days

```sql
DECLARE @s datetime;
DECLARE @e datetime;
SET @s= DateAdd(d,-7,GetUTCDate());
SET @e= GETUTCDATE();
SELECT database_name, AVG(avg_cpu_percent) AS Average_Compute_Utilization
FROM master.sys.resource_stats_raw
WHERE start_time BETWEEN @s AND @e
GROUP BY database_name
HAVING AVG(avg_cpu_percent) >= 0
```

##### To enforce parallelism on a query

Apply the following option to the end of a query.

```sql
OPTION(USE HINT('ENABLE_PARALLEL_PLAN_PREFERENCE'))
```

### Linked servers

#### References

- [Create Linked Servers (SQL Server Database
  Engine)](https://docs.microsoft.com/en-us/sql/relational-databases/linked-servers/create-linked-servers-sql-server-database-engine)
- [Create linked server to readable secondary replica in Managed Instance
  Business Critical service
  tier](https://argonsys.com/microsoft-cloud/library/create-linked-server-to-readable-secondary-replica-in-managed-instance-business-critical-service-tier/)

#### Operations

##### To add a linked server of read-scale-out replica

Execute the following with a login with role `setupadmin`.

```sql
EXEC master.dbo.sp_addlinkedserver @server = N'SECONDARY', @srvproduct=N'', @provider=N'SQLNCLI', @datasrc=@@SERVERNAME, @provstr=N'ApplicationIntent=ReadOnly'
```

To test the setup, execute the following query and `READ_ONLY` should be the
result.

```sql
SELECT *
FROM OPENQUERY([SECONDARY],
'SELECT DATABASEPROPERTYEX (''master'', ''Updateability'' ) ')
```

##### To list linked server logins

```sql
SELECT * FROM sys.linked_logins
```

### Table partitioning

- [How To Decide if You Should Use Table
  Partitioning](https://www.brentozar.com/archive/2012/03/how-decide-if-should-use-table-partitioning/)
- [Potential Problems with
  Partitioning](https://www.brentozar.com/archive/2012/08/potential-problems-partitioning/)
- [SQL Server Table Partitioning:
  Resources](https://www.brentozar.com/sql/table-partitioning-resources/)

### User-defined function (UDF)

Reference: [Scalar UDF
Inlining](https://learn.microsoft.com/en-us/sql/relational-databases/user-defined-functions/scalar-udf-inlining)

UDF are slow due to

- iterative invocation
  * each iteration incurs additional costs of repeated context switching due to
    function invocation
- lack of costing
  * scalar operators are not costed during optimisation
- interpreted execution
  * UDFs are evaluated as a batch of statements, executed
    statement-by-statement. Each statement itself is compiled, and the compiled
    plan is cached. Although this caching strategy saves some time as it avoids
    recompilations, each statement executes in isolation. No cross-statement
    optimizations are carried out.
- serial execution
  * SQL Server does not allow intra-query parallelism in queries that invoke
    UDFs

#### Automatic inlining of scalar UDF

- a new feature in SQL 2019 (15.0)
- a feature to improve performance of queries that invoke T-SQL scalar UDFs,
  where UDF execution is the main bottleneck.
- scalar UDFs are automatically transformed into scalar expressions or scalar
  subqueries that are substituted in the calling query in place of the UDF
  operator
  * expressions and subqueries are then optimized
  * the query plan will no longer have a user-defined function operator
- [requirements](https://learn.microsoft.com/en-us/sql/relational-databases/user-defined-functions/scalar-udf-inlining#requirements)
  * UDF can only contain a single `RETURN` statement
  * UDF does not invoke any intrinsic function that is either time-dependent
    (such as `GETDATE()`) or has side effects (such as `NEWSEQUENTIALID()`)
  * UDF does not reference table variables or table-valued parameters
  * UDF doesn't reference a scalar UDF call in its `GROUP BY` clause.
  * the query invoking a scalar UDF in its select list with `DISTINCT` clause
    does not have `ORDER BY` clause
  * UDF is not used in `ORDER BY` clause
  * UDF is not used in a computed column
  * UDF does not reference user-defined types
  * UDF does not contain references to Common Table Expressions (CTEs)
  * UDF does not reference built-in views (such as `OBJECT_ID`)
  * UDF does not reference XML methods
  * UDF does not contain a `SELECT` with `ORDER BY` without a `TOP 1` clause
  * UDF does not reference the `STRING_AGG` function

### LIKE wildcard queries

- it is general bad to "contain" as index cannot be utilised
- use binary collation instead of SQL or Dictionary collation can improve
  performance in some specific cases
  * in case of a column stores some sort of codes, barcodes
  * `ALTER TABLE TableName ALTER COLUMN Code NVARCHAR(20) COLLATE Latin1_General_BIN`
  * it works best when the query is repeated with a warm cache

### Untrusted constraints

##### To find untrusted constraints

```sql
SELECT '[' + s.name + '].[' + o.name + '].[' + i.name + ']' AS keyname
from sys.foreign_keys i
INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0;
GO

SELECT '[' + s.name + '].[' + o.name + '].[' + i.name + ']' AS keyname
from sys.check_constraints i
INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0 AND i.is_disabled = 0;
GO
```

To check data for the constraint (to get trusted),

```sql
ALTER TABLE dbo.YourTableName WITH CHECK CHECK CONSTRAINT YourConstraintName
```

Note that checking of the existing data can take time, burn a lot of IO, and it
will require schema modification locks, so you may want to do this during
maintenance windows if the table is large.

### Foreign keys

##### To find foreign keys that are not indexed

```sql
SELECT o.name [table], s.name [schema], fk.name [foreign_key_no_index]
FROM sys.foreign_keys fk
INNER JOIN sys.objects o
 ON o.[object_id] = fk.parent_object_id
INNER JOIN sys.schemas s
 ON s.[schema_id] = o.[schema_id]
WHERE o.is_ms_shipped = 0
AND NOT EXISTS ( SELECT *
         FROM sys.index_columns ic
         WHERE EXISTS ( SELECT *
    FROM sys.foreign_key_columns fkc
           WHERE fkc.constraint_object_id = fk.[object_id]
    AND fkc.parent_object_id = ic.[object_id]
           AND fkc.parent_column_id = ic.column_id )
         GROUP BY ic.index_id
         HAVING COUNT(*) = MAX(index_column_id)
         AND COUNT(*) = ( SELECT COUNT(*)
    FROM sys.foreign_key_columns fkc
           WHERE fkc.constraint_object_id = fk.[object_id] ) )
ORDER BY o.[name], fk.[name];
```

##### To find tree of foreign keys

Create a stored procedure to find the tree of foreign keys.

```sql
if object_id('dbo.usp_searchFK', 'P') is not null
  drop proc dbo.usp_SearchFK;
go

create proc dbo.usp_SearchFK
  @table varchar(256) -- use two part name convention
, @lvl int=0 -- do not change
, @ParentTable varchar(256)='' -- do not change
, @debug bit = 1
as
begin
  set nocount on;

  declare @dbg bit;
  set @dbg=@debug;

  if object_id('tempdb..#tbl', 'U') is null
    create table  #tbl  (id int identity, tablename varchar(256), lvl int, ParentTable varchar(256));

  declare @curS cursor;

  if @lvl = 0
    insert into #tbl (tablename, lvl, ParentTable)
    select @table, @lvl, Null;
  else
    insert into #tbl (tablename, lvl, ParentTable)
    select @table, @lvl,@ParentTable;

  if @dbg=1
    print replicate('----', @lvl) + 'lvl ' + cast(@lvl as varchar(10)) + ' = ' + @table;

  if not exists (select * from sys.foreign_keys where referenced_object_id = object_id(@table))
    return;
  else
  begin -- else
    set @ParentTable = @table;
    set @curS = cursor for

    select tablename=object_schema_name(parent_object_id)+'.'+object_name(parent_object_id)
    from sys.foreign_keys
    where referenced_object_id = object_id(@table)
    and parent_object_id <> referenced_object_id; -- add this to prevent self-referencing which can create a indefinitive loop;

    open @curS;
    fetch next from @curS into @table;
    while @@fetch_status = 0
    begin --while
      set @lvl = @lvl+1;
      -- recursive call
      exec dbo.usp_SearchFK @table, @lvl, @ParentTable, @dbg;
      set @lvl = @lvl-1;
      fetch next from @curS into @table;
    end --while

    close @curS;
    deallocate @curS;
  end -- else

  if @lvl = 0
    select * from #tbl;
  return;
end
go
```

Execute the stored procedure.

```sql
exec dbo.usp_SearchFK 'dbo.YourTableName'
```

### MERGE statements

- `WHEN NOT MATCHED BY SOURCE`
  * a row exists in the target table, but not in the source
  * effectively `LEFT JOIN`
- `WHEN MATCHED`
  * a matching row exists in both data sets
  * effectively `INNER JOIN`
  * extra conditions should be added to avoid unnecessary updates
    + beaware that the extra conditions are indexed or not
  * it can appear multiple times in the `MERGE` statement if the conditions are
    different
- `WHEN NOT MATCHED BY TARGET`
  * a row exists in the source, but not in the target table
  * effectively `LEFT JOIN`
- `OUTPUT`
  * to capture the results of the `MERGE` statement
  * `INSERTED` and `DELETED` tables are available

