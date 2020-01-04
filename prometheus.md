## Links

- [Reveal Your Deepest Kubernetes Metrics - Bob Cotton, Freshtracks.io](https://www.youtube.com/watch?v=1oJXMdVi0mM)

## Types of metrics

- `cAdvisor` - container metrics such as CPU, memory, memory and disk of a
  cluster exposed by kubetlet
- `node_exporter` - node metrics

## Abstractions of Metrics

### Four Golden Signals

This is originated from [Google SRE Handbook](https://landing.google.com/sre/books/).

- Latency — The time it takes to service a request
- Traffic — A measure of how much demand is being placed on your system
- Errors — The rate of requests that fail
- Saturation — How “full” your service is.

### USE Method

This focuses on resources.

- Resource: all physical server functional components (CPUs, disks, buses, ...)
- Utilization: the average time that the resource was busy servicing work
- Saturation: the degree to which the resource has extra work which it cannot
  service, often queued
- Errors: the count of error events

### RED Method

This focuses on services.

- Rate: The number of requests per second.
- Errors: The number of those requests that are failing.
- Duration: The amount of time those requests take.

## Node Exporter

- [Available metrics (via unit test of node-exporter)](https://github.com/prometheus/node_exporter/blob/master/collector/fixtures/e2e-output.txt)

Metric | Description
--- | ---
node_memory_MemTotal_bytes | the total amount of physical RAM (not including SWAP space)
node_memory_MemFree_bytes | the amount of physical RAM, in kilobytes, left unused by the system
node_memory_MemAvailable_bytes | An estimate of how much memory is available for starting new applications, without swapping. Calculated from MemFree, SReclaimable, the size of the file LRU lists, and the low watermarks in each zone. The estimate takes into account that the system needs some page cache to function well, and that not all reclaimable slab will be reclaimable, due to items being in use. The impact of those factors will vary from system to system.
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

Statistic | Formula
--- | ---
% Memory available |  node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes
% Memory available |  ((node_memory_MemFree_bytes + node_memory_Buffers_bytes + node_memory_Cached_bytes) / node_memory_MemTotal_bytes) * 100
Total number of CPUs in a cluster | count(node_cpu_seconds_total{mode="system"}) by (node)
Average number of CPUs in a node | count(node_cpu_seconds_total{mode="system"}) by (instance)
% CPU utilization | 1 - avg without (mode,cpu) (rate(node_cpu_seconds_total{mode="idle"}[5m]))
% CPU utilization | (1 - avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="idle"}[5m])))  * 100
% CPU Idle | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="idle"}[5m])))  * 100
% CPU I/O wait | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="iowait"}[5m])))  * 100
% CPU System usage | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="system"}[5m])))  * 100
% CPU User usage | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="user"}[5m])))  * 100
% CPU Other usages | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode=~"softirq\|nice\|irq\|steal"}[5m])))  * 100
1-minute load | sum by (instance) (node_load1{job="node-exporter"})
5-minute load | sum by (instance) (node_load5{job="node-exporter"})
15-minute load | sum by (instance) (node_load15{job="node-exporter"})
CPU Saturation using 1-minute load | sum(node_load1) by (instance) / count(node_cpu_seconds_total{mode="system"}) by (instance) * 100
CPU Saturation using 5-minute load | sum(node_load5) by (instance) / count(node_cpu_seconds_total{mode="system"}) by (instance) * 100
CPU Saturation using 15-minute load | sum(node_load15) by (instance) / count(node_cpu_seconds_total{mode="system"}) by (instance) * 100
Data transmitted | rate(node_network_transmit_bytes_total{device!="lo"}[5m])
Data received | rate(node_network_receive_bytes_total{device!="lo"}[5m])
Node total disk size (Gb) | sum (node_filesystem_size_bytes{job="node-exporter",fstype=~"ext4\|xfs", mountpoint="/"}) by (mountpoint, instance) /1024/1024/1024
Node available disk size (Gb) | sum (node_filesystem_avail_bytes{job="node-exporter",fstype=~"ext4\|xfs", mountpoint="/"}) by (mountpoint, instance) /1024/1024/1024
Node disk read speed (Mb/s) | (irate(node_disk_read_bytes_total{job="node-exporter"}[1m]))/1024/1024
Node disk write speed (Mb/s) | (irate(node_disk_written_bytes_total{job="node-exporter"}[1m]))/1024/1024
Node Inode available % | (1 -node_filesystem_files_free{job="node-exporter",fstype=\~"ext4\|xfs"} / node_filesystem_files{job="node-exporter",fstype=\~"ext4\|xfs"}) * 100
