- [Links](#links)
- [Types of metrics](#types-of-metrics)
- [Abstractions of Metrics](#abstractions-of-metrics)
    + [Four Golden Signals](#four-golden-signals)
    + [USE Method](#use-method)
    + [RED Method](#red-method)
- [Metric sources](#metric-sources)
  * [Node Exporter](#node-exporter)
    + [Examples](#examples)
  * [cAdvisor](#cadvisor)
    + [Examples](#examples-1)
- [Other topics](#other-topics)
  * [PromQL](#promql)
    + [Tips](#tips)
  * [Alert Manager](#alert-manager)
  * [Grafana](#grafana)
  * [Kubernetes](#kubernetes)
  * [Tools](#tools)
    + [Installation](#installation)
    + [To check Prometheus file](#to-check-prometheus-file)
____
# Links

- [Reveal Your Deepest Kubernetes Metrics - Bob Cotton, Freshtracks.io](https://www.youtube.com/watch?v=1oJXMdVi0mM)

# Types of metrics

- `cAdvisor` - container metrics such as CPU, memory, memory and disk of a
  cluster exposed by kubetlet
- `node_exporter` - node metrics

# Abstractions of Metrics

### Four Golden Signals

This is originated from [Google SRE Handbook](https://landing.google.com/sre/books/).

- Latency — The time it takes to service a request
- Traffic — A measure of how much demand is being placed on your system
- Errors — The rate of requests that fail
- Saturation — How “full” your service is.

### USE Method

This focuses on resources.

- Resource: all physical server functional components (CPUs, disks, buses, ...)
- Utilisation: the average time that the resource was busy servicing work
- Saturation: the degree to which the resource has extra work which it cannot
  service, often queued
- Errors: the count of error events

### RED Method

This focuses on services.

- Rate: The number of requests per second.
- Errors: The number of those requests that are failing.
- Duration: The amount of time those requests take.

# Metric sources

## Node Exporter

- [Available metrics (via unit test of node-exporter)](https://github.com/prometheus/node_exporter/blob/master/collector/fixtures/e2e-output.txt)

Metric | Description
--- | ---
node_memory_MemTotal_bytes | the total amount of physical RAM (not including SWAP space)
node_memory_MemFree_bytes | the amount of physical RAM, in kilobytes, left unused by the system
node_memory_MemAvailable_bytes | An estimate of how much memory is available for starting new applications, without swapping. Calculated from MemFree, SReclaimable, the size of the file LRU lists, and the low watermarks in each zone. The estimate takes into account that the system needs some page cache to function well, and that not all reclaimable slab will be reclaimable, due to items being in use. The impact of those factors will vary from system to system.
node_vmstat_oom_kill | OOMKill count
node_cpu_seconds_total{mode="user"} | CPU time spent in userland
node_cpu_seconds_total{mode="system"} | CPU time spent in the kernel
node_cpu_seconds_total{mode="iowait"} | CPU time waiting for I/O
node_cpu_seconds_total{mode="idle"} | CPU time had nothing to do
node_cpu_seconds_total{mode="irq"} | CPU time servicing interrupts
node_cpu_seconds_total{mode="softirq"} | CPU time servicing soft interrupts
node_cpu_seconds_total{mode="guest"} | CPU time spent on running VMs (assuming the CPU in question itself is a host running VMs)
node_cpu_seconds_total{mode="steal"} | CPU time stole by other VMs (assuming the CPU in question itself is a VM)
node_load15 | 15-minute load average - number of processes to be processed in the last 15 minutes - it is best to divide this number by average number of CPUs available at the time

### Examples

Type | Statistic | PromQL
--- | --- | ---
- | Total number of CPUs in a cluster | count(node_cpu_seconds_total{mode="system"}) by (node)
- | Average number of CPUs in a node | count(node_cpu_seconds_total{mode="system"}) by (instance)
utilisation | CPU Core usage count | sum(rate(node_cpu_seconds_total{mode!="idle"}[5m])) BY (instance)
utilisation | CPU Core usage count without `iowait` | sum(rate(node_cpu_seconds_total{mode!="idle",mode!="iowait"}[5m])) BY (instance)
utilisation | % CPU utilisation | 1 - avg without (mode,cpu) (rate(node_cpu_seconds_total{mode="idle"}[5m]))
utilisation | % CPU utilisation | (1 - avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="idle"}[5m])))  * 100
utilisation | % CPU utilisation without `iowait` | (1 - avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="idle"}[5m])) - avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="iowait"}[5m]))) * 100
- | % CPU Idle | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="idle"}[5m])))  * 100
- | % CPU I/O wait | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="iowait"}[5m])))  * 100
- | % CPU System usage | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="system"}[5m])))  * 100
- | % CPU User usage | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="user"}[5m])))  * 100
- | % CPU Other usages | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode=~"softirq\|nice\|irq\|steal"}[5m])))  * 100
- | 1-minute load | sum by (instance) (node_load1{job="node-exporter"})
- | 5-minute load | sum by (instance) (node_load5{job="node-exporter"})
- | 15-minute load | sum by (instance) (node_load15{job="node-exporter"})
saturation | CPU Saturation using 1-minute load | sum(node_load1) by (instance) / count(node_cpu_seconds_total{mode="system"}) by (instance) * 100
saturation | CPU Saturation using 5-minute load | sum(node_load5) by (instance) / count(node_cpu_seconds_total{mode="system"}) by (instance) * 100
saturation | CPU Saturation using 15-minute load | sum(node_load15) by (instance) / count(node_cpu_seconds_total{mode="system"}) by (instance) * 100
- | % Memory available | sum by (instance) ((node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100)
- | % Memory available | sum by (instance) (((node_memory_MemFree_bytes + node_memory_Buffers_bytes + node_memory_Cached_bytes) / node_memory_MemTotal_bytes) * 100)
utilisation | % Memory utilisation | (1 - sum by (instance) (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
- | Data transmitted | rate(node_network_transmit_bytes_total{device!="lo"}[5m])
- | Data received | rate(node_network_receive_bytes_total{device!="lo"}[5m])
utilisation | Data Mb/s | (sum(rate(node_network_receive_bytes_total[5m])) by (instance) + sum(rate(node_network_transmit_bytes_total[5m])) by (instance)) / 1024 / 1024
saturation | Packet drop /s | sum(rate(node_network_receive_drop_total[5m])) by (instance) + sum(rate(node_network_transmit_drop_total[5m])) by (instance)
error | Network error rate | sum by (instance) (rate(node_network_receive_errs_total[5m])) + sum by (instance) (rate(node_network_transmit_errs_total[5m]))
- | Node total disk size (Gb) | sum (node_filesystem_size_bytes{job="node-exporter",fstype=~"ext4\|xfs", mountpoint="/"}) by (mountpoint, instance) /1024/1024/1024
- | Node available disk size (Gb) | sum (node_filesystem_avail_bytes{job="node-exporter",fstype=~"ext4\|xfs", mountpoint="/"}) by (mountpoint, instance) /1024/1024/1024
- | Node disk read speed (Mb/s) | (irate(node_disk_read_bytes_total{job="node-exporter"}[1m]))/1024/1024
- | Node disk write speed (Mb/s) | (irate(node_disk_written_bytes_total{job="node-exporter"}[1m]))/1024/1024
- | Node Inode available % | (1 -node_filesystem_files_free{job="node-exporter",fstype=\~"ext4\|xfs"} / node_filesystem_files{job="node-exporter",fstype=\~"ext4\|xfs"}) * 100

## cAdvisor

### Examples

Type | Statistic | PromQL
--- | --- | ---
utilisation | CPU Utilisation | sum(rate(container_cpu_usage_seconds_total[5m])) by (container_name)
saturation | CPU Saturation | sum(rate(container_cpu_cfs_throttled_seconds_total[5m])) by (container_name)
utilisation | Memory Utilisation | sum(container_memory_working_set_bytes{name!~"POD"}) by name
saturation | Memory Saturation | sum(container_memory_working_set_bytes) by (container_name) / sum(label_join(kube_pod_container_resource_limits_memory_bytes, "container_name", "", "container")) by (container_name)
utilisation | Data rate | sum(rate(container_network_receive_bytes_total[5m])) by (name) + sum(rate(container_network_transmit_bytes_total[5m])) by (name)
saturation | Packet drop /s | sum(rate(container_network_receive_packets_dropped_total[5m])) by (name) + sum(rate(container_network_transmit_packets_dropped_total[5m])) by (name)
error | Network error rate | sum by (name) (rate(container_network_receive_errors_total[5m])) + sum by (name) (rate(container_network_transmit_errors_total[5m]))
utilisation | Disk Utilisation | sum(rate(container_fs_writes_bytes_total[5m])) by (container_name,device) + sum(rate(container_fs_reads_bytes_total[5m])) by (container_name,device)

# Other topics

## PromQL

- [PromCon EU 2019: PromQL for Mere Mortals](https://www.youtube.com/watch?v=hTjHuoWxsks)
- [GitLab - Saturation
  Metrics](https://gitlab.com/gitlab-com/runbooks/blob/master/rules/service_saturation.yml)

### Tips

- always apply `rate` to counter metrics

## Alert Manager

- [PromCon EU 2019: Fun and Profit with Alertmanager](https://www.youtube.com/watch?v=VgsM8pOyN5s)
- [GitLab - Saturation
  Alerts](https://gitlab.com/gitlab-com/runbooks/blob/master/rules/general-service-alerts.yml)

## Grafana

- [PromCon EU 2019: Managing Grafana Dashboards with grafonnet and git](https://www.youtube.com/watch?v=kV3Ua6guynI)
- [GitLab - Capacity Planning Dashboard
  Alerts](https://gitlab.com/gitlab-com/runbooks/blob/master/dashboards/general/capacity-planning.jsonnet)

## Kubernetes

- if memory limits are implemented correctly, a node should never go into
  paging (or swap space). `node_exporter` metrics `node_vmstat_pgpgin` and
  `node_vmstat_pgpgin` can be used to indicate such activities.
- The “container” metrics that are exposed from `cAdvisor` are ultimately the
  metrics reported by the underlying Linux `cgroup` implementation.
- CPU limit and request are specified as fractions of a CPU or core (down to
  1/1000th) and those of memory is specified in bytes. If you set only limits,
  the request will be the same as the limit. Limits give you one knob to
  over-provision containers on a node as limits are not accounted for by the
  Kubernetes scheduler. That being said, if your container exceeds your limits
  the action depends on the resource; you will be throttled if you exceed the
  CPU limit, and killed if you exceed the memory limit.

## Tools

### Installation

```sh
go get github.com/prometheus/prometheus/cmd/...
```

### To check Prometheus file

```sh
promtool check rule your-rule-filename.yml
```