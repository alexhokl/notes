- [Status](#status)
- [Links](#links)
- [IAM](#iam)
- [Log Analytic Workspace](#log-analytic-workspace)
  * [Examples](#examples)
- [Alerts](#alerts)
____

## Status

- [Azure status](https://status.azure.com/status)

## Links

- [Notes on Azure CLI](./azure-cli.md)

## IAM

- [Built-in
  roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)

## Log Analytic Workspace

- [How to query logs from Azure Monitor for containers](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-log-search) - Sources and fields of AKS logs
- [Joins in Azure Monitor log queries](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/joins)
- [SQL to Azure Monitor log query cheat sheet](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/sql-cheatsheet)

### Examples

##### Cluster names

```kusto
KubeNodeInventory
| summarize by ClusterName
```

##### Docker image and tags

```kusto
ContainerInventory
| summarize by Repository, Image, ImageTag
```

##### AKS logs

```kusto
let pods = KubePodInventory
| where ClusterName == "my-cluster"
| where ServiceName == "my-service"
| summarize by ContainerID, ControllerName, ServiceName, Namespace;
ContainerLog
| where LogEntry contains "your search term"
| project TimeGenerated, LogEntrySource, LogEntry, ContainerID
| join kind= inner pods on ContainerID
| project TimeGenerated, LogEntry, ControllerName, ServiceName, Namespace
| order by TimeGenerated desc;
```

##### Kuberentes events

```kusto
KubeEvents
| where TimeGenerated > ago(7d)
| where not(isempty(Namespace))
| where Reason == "Unhealthy"
| where Name contains "api"
| where Namespace == "your-namespace"
| where Message contains "Liveness"
| top 200 by TimeGenerated desc
| project TimeGenerated, Name, Message, Count
```

##### Restart stats

```kusto
KubePodInventory
| where ClusterName == "your-cluster"
| where Namespace == "your-namespace"
| where ServiceName == "your-service"
| order by TimeGenerated desc
| project TimeGenerated, PodRestartCount, PodStartTime, ServiceName, Namespace, ClusterName
```

##### Current PODs

```kusto
let pods = ContainerInventory
| summarize by ContainerID, Image, ImageTag;
KubePodInventory
| summarize by ContainerID, Name, PodStatus, Namespace, ClusterName
| order by ContainerID
| join kind= inner pods ContainerID
| project Name, PodStatus, Namespace, ClusterName, Image, ImageTag, ContainerID
```

##### Response time

```kusto
let dataset=requests
| where client_Type != "Browser"
| where operation_Name contains "PUT";
dataset
| summarize count_=sum(itemCount), avg(duration), percentiles(duration, 50, 95, 99) by operation_Name
| union(dataset
| summarize count_=sum(itemCount), avg(duration), percentiles(duration, 50, 95, 99)
| extend operation_Name="Overall")
| order by percentile_duration_95 desc
```

##### Response time comparison between two weeks

```kusto
let beforeFirstDay=startofweek(now() - 14d) + 1d;
let afterFirstDay=startofweek(now() - 7d) + 1d;
let before=requests
    | where timestamp between(beforeFirstDay..(7d - 1tick))
    | where client_Type != "Browser"
    | where operation_Name startswith "GET /api/" and operation_Name !endswith_cs "Z" and operation_Name != ""
    | summarize count_=sum(itemCount), avg(duration), percentiles(duration, 50, 95, 99) by operation_Name;
let after=requests
    | where timestamp between(afterFirstDay..(7d - 1tick))
    | where client_Type != "Browser"
    | where operation_Name startswith "GET /api/" and operation_Name !endswith_cs "Z" and operation_Name != ""
    | summarize count_=sum(itemCount), avg(duration), percentiles(duration, 50, 95, 99) by operation_Name;
after
| join kind=fullouter (before) on operation_Name
| where count_ >= 100 and count_1 >= 100 and percentile_duration_50 > 1000
| extend percentage_change_50=round((percentile_duration_50 - percentile_duration_501) / percentile_duration_501 * 100)
| extend percentage_change_95=round((percentile_duration_95 - percentile_duration_951) / percentile_duration_951 * 100)
| extend percentage_change_99=round((percentile_duration_99 - percentile_duration_991) / percentile_duration_991 * 100)
| extend percentage_change_count=round(todecimal(count_ - count_1) / count_1 * 100)
| project operation_Name, CountAfter=count_, CountBefore=count_1, percentage_change_count, round(percentile_duration_50), percentage_change_50, round(percentile_duration_95), percentage_change_95, round(percentile_duration_99), percentage_change_99
| order by percentile_duration_50 desc
```

## Alerts

- [Common alert schema definitions](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-common-schema-definitions)
- [How to integrate the common alert schema with Logic Apps](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-common-schema-integrations)
