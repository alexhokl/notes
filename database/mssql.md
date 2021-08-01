- [Tools](#tools)
- [Troubleshooting](#troubleshooting)
- [Database Operations](#database-operations)
  * [Backup](#backup)
  * [Size management](#size-management)
  * [User modes](#user-modes)
  * [Login](#login)
- [Database performance](#database-performance)
  * [Query plans](#query-plans)
  * [Indexes](#indexes)
  * [Locks and blocking processes](#locks-and-blocking-processes)
  * [General information](#general-information)
  * [Read-only replica and snapshot isolation](#read-only-replica-and-snapshot-isolation)
  * [Jobs](#jobs)
  * [CPU and parallelism](#cpu-and-parallelism)
____

## Tools

- [sqlcollaborative/dbatools](https://github.com/sqlcollaborative/dbatools)
  powershell commands
- [Brent Ozar - Paste the plan](https://www.brentozar.com/pastetheplan/) -
  visualising query plan

## Troubleshooting

##### To check network connection

```sh
telnet your-mssql-server.example.com 1433
```

Note if the connection works fine, a blank page would be shown; an error
message would be shown, otherwise.

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

## Database performance

### Query plans

##### To remove plan cache entries

and remove all clean buffers

```sql
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
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

##### Rebuild indexes and statistics

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

