### Links

- [Docker @ Elastic](https://www.docker.elastic.co/)
- [Install Elasticsearch with Docker](https://www.elastic.co/guide/en/elasticsearch/reference/6.4/docker.html#docker)
- [Official examples](https://github.com/elastic/examples/)

### Hello World ELK setup

files

```console
├── docker-compose.yaml
├── logstash.yml
└── pipeline
    └── logstash.conf
```

`docker-compose.yaml`

```yaml
version: '3'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:6.5.0
    environment:
      - discovery.type=single-node
    ports:
      - "9200:9200"
      - "9300:9300"
  kibana:
    image: docker.elastic.co/kibana/kibana:6.5.0
    environment:
      - "elasticsearch.url=http://elasticsearch:9200"
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
  logstash:
    image: docker.elastic.co/logstash/logstash:6.5.0
    volumes:
      - ./logstash.yml:/usr/share/logstash/config/logstash.yml
      - ./pipeline:/usr/share/logstash/pipeline
    environment:
      - "xpack.monitoring.elasticsearch.url=http://elasticsearch:9200"
    ports:
      - "5000:5000"
    depends_on:
      - elasticsearch
```

`logstash.yml`

```yaml
http.host: 0.0.0.0
path.config: /usr/share/logstash/pipeline
xpack.monitoring.elasticsearch.url: http://elasticsearch:9200
```

`logstash.conf`

```conf
input {
  tcp {
    port => 5000
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
  }
}
```

To put data into Elasticsearch via Logstash

```sh
nc localhost 5000 < SomeTextFile.txt
```

Create an index via Kibana and one should find the log lines in `Discover`
section.

### Clients

- [Nest](https://www.elastic.co/guide/en/elasticsearch/client/net-api/1.x/nest.html)

### Characteristics

- distributed search (scaled by adding more nodes and nodes can have different
    roles)

### Popular users

- Ebay
- Github

### Elasticsearch

- default JVM heap size is 1GB (`jvm.options`)
- cluster is a concept rather than a physical thing
- discovery module is available on most public cloud to go through the
    seecurity groups to fill `discovery.zen.unicast.hosts`.
- `network.host` controls exposing to public traffic or not
- index
  - mapping
    - name of fields
    - data types of fields
    - how the field show be indexed and stored by Lucene
  - namespace
- an index would be automatically created if none exists
- One and only one index per document
- directories
  - `bin`
  - `config`
    - `ES_PATH_CONF` to set a path for configuration
  - `data` - the location of the data files of each index and shard allocated
      on the node
    - `path.data` to set the path and this can be an array
  - `lib` - JAR files
  - `logs`
    - `path.logs` to set the path
  - `modules`
  - `plugins`
- bool Query
  - `must`
  - `must_not`
  - `should`
    - should optionally appear in matching documents, and matches contribute to the `_score`
    - it affects sorting order
  - `filter`
    - must appear in matching documents but it will have no effect on
      `_score`
    - execution is generally faster as no score calculation is required
- data type `keyword` will not have its field put into a Lucene analyser
  - that is the whole field is treated as a single token

#### API

`GET my_custom_index/_mapping` to check the mappings

`GET _analyze`

```json
{
 "analyzer": "simple",
 "text": "My favorite movie is Star Wars!"
}
```

### Kibana

- capability to aggregate keywords and count
- Meachine learning has annonaly detection feature and forecasting feature
  - setting threshold to send alerts could be too hard so Machine learning could be useful
- Machine learning analysis can be done on a laptop and it is a expressed as job in Kibana
- stacktrace can be viewed in APM module as APM transaction
- SQL queries can be viewed in a per request basis in APM module

### Logstash

- kubenetes compatible
- Beat modules can be developed to collect SQL queries
- it is more about normalise data, filter data and may be adding more information to the data
- Golang logs are supported while there is no support for .NET languages yet
- Postgresql integration is available but not MSSQL
- APM has to be installed on the application server to collect metrics
- Combination of system and application metrics is possible 
- Slower in general and more resource consuming
- Multiple `.conf` files can be used

##### Examples

###### JDBC

```conf
input {
    jdbc {
        # SqlServer jdbc connection string to our database, employeedb
        #  "jdbc:sqlserver://HostName\instanceName;database=DBName;user=UserName;password=Password"
        jdbc_connection_string => "jdbc:sqlserver://localhost\SQLExpress;database=employeedb;user=sa;password=test@123"
        # The user we want to execute our statement as
        jdbc_user => nil
        # The path to our downloaded jdbc driver
        jdbc_driver_library => "C:/Program Files/sqljdbc_6.0/enu/jre8/sqljdbc42.jar"
        # The name of the driver class for SqlServer
        jdbc_driver_class => "com.microsoft.sqlserver.jdbc.SQLServerDriver"
        # Query for testing purpose
        statement => "SELECT * from employee"
    }
}
```

See also [Integrating Elasticsearch with MS SQL, Logstash, and Kibana](https://stackabuse.com/integrating-elasticsearch-with-ms-sql-logstash-and-kibana/)

### Beats

- it does not perform any preprocessing and this means if such processing is
    required, we need ingest nodes on Elasticsearch cluster

### Data types

- Static data which grows slowly relatively
- Time-series data

### Deployment

- It is better to deploy an Elastic stack in each data centre or cluster
- one licence per node
- Elastic cloud Enterprise is for deployment on clusters
