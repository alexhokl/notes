### Elastic

##### Popular users

- Ebay
- Github

##### Kibana

- capability to aggregate keywords and count
- Meachine learning has annonaly detection feature and forecasting feature
  - setting threshold to send alerts could be too hard so Machine learning could be useful
- Machine learning analysis can be done on a laptop and it is a expressed as job in Kibana
- stacktrace can be viewed in APM module as APM transaction
- SQL queries can be viewed in a per request basis in APM module

##### Logstash

- kubenetes compatible
- Beat modules can be developed to collect SQL queries
- it is more about normalise data, filter data and may be adding more information to the data
- Golang logs are supported while there is no support for .NET languages yet
- Postgresql integration is available but not MSSQL
- APM has to be installed on the application server to collect metrics
- Combination of system and application metrics is possible 

##### Deployment

- It is better to deploy an Elastic stack in each data centre or cluster
- one licence per node
- Elastic cloud Enterprise is for deployment on clusters 