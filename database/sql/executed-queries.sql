SELECT        SQLTEXT.text, STATS.last_execution_time
FROM          sys.dm_exec_query_stats STATS
CROSS APPLY   sys.dm_exec_sql_text(STATS.sql_handle) AS SQLTEXT
ORDER BY      STATS.last_execution_time DESC