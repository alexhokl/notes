## Node Exporter

Metric | Description
--- | ---
node_memory_MemTotal_bytes | the total amount of physical RAM (not including SWAP space)
node_memory_MemFree_bytes | the amount of physical RAM, in kilobytes, left unused by the system
node_memory_MemAvailable_bytes | An estimate of how much memory is available for starting new applications, without swapping. Calculated from MemFree, SReclaimable, the size of the file LRU lists, and the low watermarks in each zone. The estimate takes into account that the system needs some page cache to function well, and that not all reclaimable slab will be reclaimable, due to items being in use. The impact of those factors will vary from system to system.

### Examples

Statistic | Formula
--- | ---
% Memory available |  node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes
% Memory available |  ((node_memory_MemFree_bytes + node_memory_Buffers_bytes + node_memory_Cached_bytes) / node_memory_MemTotal_bytes) * 100
% CPU utilization | 1 - avg without (mode,cpu) (rate(node_cpu_seconds_total{mode="idle"}[5m]))
% CPU utilization | (1 - avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="idle"}[5m])))  * 100
% CPU Idle | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="idle"}[5m])))  * 100
% CPU I/O wait | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="iowait"}[5m])))  * 100
% CPU System usage | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="system"}[5m])))  * 100
% CPU User usage | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode="user"}[5m])))  * 100
% CPU Other usages | (avg by (environment,instance) (irate(node_cpu_seconds_total{job="node-exporter",mode=~"softirq|nice|irq|steal"}[5m])))  * 100
1-minute load | sum by (instance) (node_load1{job="node-exporter"})
5-minute load | sum by (instance) (node_load5{job="node-exporter"})
15-minute load | sum by (instance) (node_load15{job="node-exporter"})
Data transmitted | rate(node_network_transmit_bytes_total{device!="lo"}[5m])
Data received | rate(node_network_receive_bytes_total{device!="lo"}[5m])
Node total disk size | node_filesystem_size_bytes{job="node-exporter" ,fstype=~"ext4|xfs"}
Node available disk size | node_filesystem_avail_bytes{job="node-exporter",fstype=~"ext4|xfs"}
Node disk read speed (Mb/s) | (irate(node_disk_read_bytes_total{job="node-exporter"}[1m]))/1024/1024
Node disk write speed (Mb/s) | (irate(node_disk_written_bytes_total{job="node-exporter"}[1m]))/1024/1024
Node Inode available % | (1 -node_filesystem_files_free{job="node-exporter",fstype=~"ext4|xfs"} / node_filesystem_files{job="node-exporter",fstype=~"ext4|xfs"}) * 100