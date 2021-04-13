##### Proportion of different wait types

```kusto
AzureDiagnostics
| where Category == "QueryStoreWaitStatistics"
| project Resource = extract(".+/DATABASES/(.+)", 1, ResourceId).tolower(), TimeGenerated, total_query_wait_time_ms_d, wait_category_s
| summarize total_wait_time = sum(total_query_wait_time_ms_d) / 1000
    by wait_category_s, bin(TimeGenerated, 30m)
| top 1000 by total_wait_time desc
| evaluate pivot(wait_category_s, sum(total_wait_time))
| render columnchart 
```

##### CPU consumption

```kusto
AzureDiagnostics
| where ResourceType == "MANAGEDINSTANCES"
| summarize max_cpu = max(todouble(avg_cpu_percent_s)) by LogicalServerName_s, bin(TimeGenerated, 30m)
| render timechart
```

##### Workload continuously hitting CPU limits 

Intelligent insights report detecting the workload behaviour as continuously
hitting CPU limits. Please note that SQLInsights log needs to be enabled for
each database monitored. 

```kusto
let alert_run_interval = 24h;
let insights_string = "hitting its CPU limits";
AzureDiagnostics
| where Category == "SQLInsights" and status_s == "Active"
| where TimeGenerated > ago(alert_run_interval)
| where rootCauseAnalysis_s contains insights_string
| distinct _ResourceId
```

##### CPU utilization threshold above 95% on managed instances 

Display all managed instances with CPU threshold being over 95% of threshold. 

```kusto
let cpu_percentage_threshold = 95;
let time_threshold = ago(72h);
AzureDiagnostics
| where Category == "ResourceUsageStats" and TimeGenerated > time_threshold
| summarize avg_cpu = max(todouble(avg_cpu_percent_s)) by _ResourceId
| where avg_cpu > cpu_percentage_threshold
```

##### CPU Consumption in 5 minutes intervals

```kusto
AzureDiagnostics
| where ResourceType == "MANAGEDINSTANCES" 
| where ResourceId contains "MANAGEDINSTANCES"
| summarize cpu = max(todouble(avg_cpu_percent_s)) by bin(TimeGenerated, 5m) 
| render timechart
```

##### Impacts and root causes

```kusto
AzureDiagnostics
| where LogicalServerName_s contains "your-database-mi-name"
| where databaseName_s contains "your-database"
| where impact_s contains "ExcessiveWaitingSeconds" 
| project TimeGenerated , LogicalServerName_s , databaseName_s , impact_s , detections_s , rootCauseAnalysis_s, status_s 
```

##### Count of request with CPU wait time greater than 10ms 

```kusto
let maxwait = 10;
let StartTime = ago(30d);
let EndTime = ago(-1d);
AzureDiagnostics
| where Category=="QueryStoreWaitStatistics"
| where ResourceType == "MANAGEDINSTANCES/DATABASES"
| where ResourceId contains "/DATABASES/"
| where wait_category_s == "CPU" 
| where TimeGenerated between(StartTime..EndTime)
| where total_query_wait_time_ms_d > maxwait
| summarize sum(total_query_wait_time_ms_d) by bin(TimeGenerated, 1h)  
| render barchart
```

##### Count of request with NetworkIO wait time greater than 10ms 

```kusto
let maxwait = 10;
let StartTime = ago(30d);
let EndTime = ago(-1d);
AzureDiagnostics
| where Category=="QueryStoreWaitStatistics"
| where ResourceType == "MANAGEDINSTANCES/DATABASES"
| where ResourceId contains "/DATABASES/"
| where wait_category_s == "NETWORKIO" 
| where TimeGenerated between(StartTime..EndTime)
| where total_query_wait_time_ms_d > maxwait
| summarize sum(total_query_wait_time_ms_d) by bin(TimeGenerated, 1h)  
| render barchart
```

##### Database errors

```kusto
AzureDiagnostics
| where ResourceId contains "your-database"
| where (Category == "Errors" and error_number_d !in (9104, 22803)) or (Category == "Blocks") or (Category == "Timeouts" and query_hash_s !in ("", "0", "-1")) or (Category == "Deadlocks")
| project Message, databaseName_s, error_number_d, Severity
```

or, in a bar chart,

```kusto
AzureDiagnostics
| where ResourceId contains "your-database"
| where (Category == "Errors" and error_number_d !in (9104, 22803)) or (Category == "Blocks") or (Category == "Timeouts" and query_hash_s !in ("", "0", "-1")) or (Category == "Deadlocks")
| summarize count() by Category, bin(TimeGenerated, 30m)
| render barchart
```

##### CPU usage of managed instance in 5-minute interval

```kusto
AzureDiagnostics
| where ResourceType == "MANAGEDINSTANCES"
| summarize max_cpu = max(todouble(avg_cpu_percent_s)) by LogicalServerName_s, bin(TimeGenerated, 5m)
| render timechart
```

##### IO reads of managed instance in 5-minute interval

```kusto
AzureDiagnostics
| where ResourceType == "MANAGEDINSTANCES"
| summarize max_io = max(todouble(io_bytes_read_s)) by LogicalServerName_s, bin(TimeGenerated, 5m)
| render timechart
```

##### IO writes of managed instance in 5-minute interval

```kusto
AzureDiagnostics
| where ResourceType == "MANAGEDINSTANCES"
| summarize max_writes = max(todouble(io_bytes_written_s)) by LogicalServerName_s, bin(TimeGenerated, 5m)
| render timechart
```

##### Query store wait time statistics

This relates to `sys.query_store_wait_stats`.

```kusto
AzureDiagnostics
| where Category=="QueryStoreWaitStatistics"
| limit 10
```

##### Query store

This relates to `sys.query_store_runtime_stats`.

```kusto
AzureDiagnostics
| where Category=="QueryStoreRuntimeStatistics"
| limit 10
```

##### To show CPU usage of top 10 queries

```kusto
let x = (10);
let StartTime = ago(7d);
let EndTime = ago(-1d); 
AzureDiagnostics
| where Category=="QueryStoreRuntimeStatistics"
| where ResourceType == "MANAGEDINSTANCES/DATABASES"
//| where ResourceId contains"adventureworksPTO"
| where TimeGenerated between(StartTime..EndTime)
| extend avgcpu = cpu_time_d / count_executions_d
| distinct query_id_d, TimeGenerated , Category , ResourceType , query_hash_s, query_plan_hash_s, plan_id_d
, cpu_time_d , avgcpu, count_executions_d, duration_d 
//| distinct query_id_d, Category
| order by avgcpu desc 
| top x by avgcpu desc nulls last //top 10 by duration
//| summarize any(query_id_d), any(avgcpu) by bin(TimeGenerated, 15s)
| summarize max(query_id_d), avgduration = avg(duration_d) by bin(TimeGenerated, 1d)
| render barchart  
```
