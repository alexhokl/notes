- [Links](#links)
- [Log Analytic Workspace](#log-analytic-workspace)
  * [Examples](#examples)
- [Alerts](#alerts)
____
## Links

- [Notes on Azure CLI](./azure-cli.md)

## Log Analytic Workspace

- [How to query logs from Azure Monitor for containers](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-log-search) - Sources and fields of AKS logs
- [Joins in Azure Monitor log queries](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/joins)
- [SQL to Azure Monitor log query cheat sheet](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/sql-cheatsheet)

### Examples

##### AKS logs

```
let startTime = ago(7d);
ContainerLog
| where TimeGenerated > startTime
| where LogEntry contains "your search term"
| project TimeGenerated, LogEntrySource, LogEntry, ContainerID
| join kind= inner (
  KubePodInventory
  | where TimeGenerated > startTime
  | where ControllerName contains "web-deployment"
  | summarize by ContainerID, ControllerName, ServiceName, Namespace
) on $left.ContainerID == $right.ContainerID
| project TimeGenerated, LogEntry, ControllerName, ServiceName, Namespace
| order by TimeGenerated desc;
```

##### Kuberentes events

```
KubeEvents
| where TimeGenerated > ago(7d)
| where not(isempty(Namespace))
| where Reason == "Unhealthy"
| where Name contains "api"
| where Namespace = "your-namespace"
| where Message contains "Liveness"
| top 200 by TimeGenerated desc
| project TimeGenerated, Name, Message, Count
```

##### Response time

```
let start=datetime("2020-08-13T06:38:00.000Z");
let end=datetime("2020-08-14T06:38:00.000Z");
let timeGrain=5m;
let dataset=requests
| where timestamp > start and timestamp < end
| where client_Type != "Browser"
| where operation_Name contains "PUT";
dataset
| summarize count_=sum(itemCount), avg(duration), percentiles(duration, 50, 95, 99) by operation_Name
| union(dataset
| summarize count_=sum(itemCount), avg(duration), percentiles(duration, 50, 95, 99)
| extend operation_Name="Overall")
| order by percentile_duration_95 desc
```

## Alerts

- [Common alert schema definitions](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-common-schema-definitions)
- [How to integrate the common alert schema with Logic Apps](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-common-schema-integrations)
