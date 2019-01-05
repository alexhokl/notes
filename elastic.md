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
    image: docker.elastic.co/elasticsearch/elasticsearch:6.5.1
    environment:
      - discovery.type=single-node
    ports:
      - "9200:9200"
  kibana:
    image: docker.elastic.co/kibana/kibana:6.5.1
    environment:
      - "elasticsearch.url=http://elasticsearch:9200"
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
  logstash:
    image: docker.elastic.co/logstash/logstash:6.5.1
    volumes:
      - ./logstash.yml:/usr/share/logstash/config/logstash.yml
      - ./pipeline:/usr/share/logstash/pipeline
      - ./blogs.csv:/usr/share/logstash/blogs.csv
    environment:
      - "xpack.monitoring.elasticsearch.url=http://elasticsearch:9200"
    ports:
      - "5000:5000"
    depends_on:
      - elasticsearch
  filebeats:
    image: docker.elastic.co/beats/filebeat:6.5.1
    volumes:
      - ./Engineer1/datasets/filebeat.yml:/usr/share/filebeat/filebeat.yml
      - ./Engineer1/datasets:/var/datasets
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

- cluster is a concept rather than a physical thing
- index
  - mapping
    - name of fields
    - data types of fields
    - defines how the field show be indexed and stored by Lucene
  - namespace
- an index would be automatically created if none exists
- One and only one index per document
- bool Query
  - `must`
  - `must_not`
  - `should`
    - optionally appear in matching documents, and matches contribute to `_score`
    - it affects sorting order
  - `filter`
    - must appear in matching documents but it will have no effect on
      `_score`
    - execution is generally faster as no score calculation is required
- field of data type `keyword` will not be processed by Lucene analysers
  - that is, the whole field is treated as a single token
- default stop words filter is not enabled
- character filter -> tokeniser -> token filter
- each node stores cluster state but only master node can modify it
- master node handles
  - creation or deletion of indices
  - addition or removal of nodes
  - allocation of shards to nodes
- master nodes are super lightweight comparing to data nodes
- data node
  - hold shards that contains documents
  - execute data related operations
  - all nodes are data nodes by default
- coordinating node
  - each node is implicitly a coordinating node
  - forwards a request to other relevant nodes and combines those results into
      a single result
- Elasticsearch never allocates more than one copy of the same shard to the
    same node
- Elasticsearch would return incomplete results if the shards cannot return
    results in time

#### Directories

- `bin`
- `config`
  - environment variable `ES_PATH_CONF` can be set to set a path for
      configuration
- `data` - the location of the data files of each index and shard allocated
    on the node
- `lib` - JAR files
- `logs`
- `modules`
- `plugins`

#### Configuration files

- `/usr/share/elasticsearch/config/elasticsearch.yml`
  - `cluster.name`
  - `network.host`
    - controls whether to expose the service to public traffic or not
  - `discovery.zen.minimum_master_nodes`
    - determines the number of votes to win the master node election
    - an important configuration to change when the number of nodes changes in
        a cluster
    - the cluster would not be available until the number of nodes is greater
        than or equal to this configuration
    - the cluster would not be available until the number of master-eligible
        nodes more than or equal to this configuration
  - `discovery.zen.ping.unicast.hosts`
    - list of static hosts as seed nodes
      - comma-separated list
      - DNS names are resolved on each round of ping
      - the default is set to `127.0.0.1`
  - `xpack.security.enable`
    - the default is `false`
  - `node.master`
    - `true` if the node can be a master node
  - `node.data`
    - `true` if the node can be a data node
  - `node.ingest`
    - `true` if the node can be an ingest node
  - `path.repo`
    - to set the path to repository of index snapshots
  - `path.data`
    - to set the path to data directory
  - `path.logs`
    - to set the path to logs directory
- `/usr/share/elasticsearch/config/jvm.options`
  - `-Xms` initial heap size
    - set to 1GB by default
    - or set via environment variable `ES_JAVA_OPTS`
  - `-Xmx` maximum heap size
    - set to 1GB by default
    - or set via environment variable `ES_JAVA_OPTS`

#### API

###### `PUT my_index/_doc/111`

to add/update a document with id `111`

```json
{
  "field1": "value1",
  "field2": "value2"
}
```

###### `POST my_index/_doc/`

to add a document with a generated id

```json
{
  "field1": "value1",
  "field2": "value2"
}
```

the generated id it stored as metadata field `_id`

###### `GET my_index/_doc/111`

to get a document with index `111`

###### `DELETE my_index/_doc/111`

to delete a document with index `111`

###### `DELETE my_index`

to delete index `my_index`

###### `GET my_index/_search`

to get all documents in the specified index

```json
{
  "query": {
    "match_all": {}
  }
}
```

to get 5 documents in the specified index

```json
{
  "size": 5,
  "query": {
    "match_all": {}
  }
}
```

to get documents in a date range

```json
{
  "query": {
    "range": {
      "publish_date": {
        "gte": "2017-05-01",
        "lte": "2017-05-31"
      }
    }
  }
}
```

to get documents with "elastic" in `title`

```json
{
  "query": {
    "match": {
      "title": "elastic"
    }
  }
}
```

to get documents with "elastic" or "slack" in `title`

```json
{
  "query": {
    "match": {
      "title": "elastic stack"
    }
  }
}
```

to get documents with "elastic" and "slack" in `title`

```json
{
  "query": {
    "match": {
      "title": {
        "query": "elastic stack",
        "operator": "and"
      }
    }
  }
}
```

to get documents with phrase "search analytics" in `content`

```json
{
  "query": {
    "match_phrase": {
      "content": "search analytics"
    }
  }
}
```

to get documents with phrase "search <something> analytics in `content`

```json
{
  "query": {
    "match_phrase": {
      "content": {
        "query": "search analytics",
        "slop": 1
      }
    }
  }
}
```

to get documents with at least 2 words from "performance", "optimizations" or
    "improvements" in `content`

```json
{
  "query": {
    "match": {
      "content": {
        "query": "performance optimizations improvements",
        "minimum_should_match": 2
      }
    }
  }
}
```

to get documents with at least 2 words from "performance", "optimizations" or
    "improvements" in `content` but no "released", "releases" and "release" in
    `title` and rank results higher if it contains word "elasticsearch" in
    `title`

```json
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "content": {
              "query": "performance optimizations improvements",
              "minimum_should_match": 2
            }
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "title": "release releases released"
          }
        }
      ],
      "should": [
        {
          "match": {
            "title": "elasticsearch"
          }
        }
      ]
    }
  }
}
```

to get documents with "open source" in field `content` and `title`

```json
{
  "query": {
    "multi_match": {
      "query": "open source",
      "fields": [
        "content",
        "title"
      ]
    }
  }
}
```

to get documents with "open source" in field `content` and `title` and double
the weight in `title`

```json
{
  "query": {
    "multi_match": {
      "query": "open source",
      "fields": [
        "content",
        "title^2"
      ]
    }
  }
}
```

to get documents with phrase "open source" in field `content` and `title`

```json
{
  "query": {
    "multi_match": {
      "query": "open source",
      "fields": [
        "content",
        "title"
      ],
      "type": "phrase"
    },
  }
}
```

to get documents with words "open source" in `title` and only show `title` in
results instead of the whole document

```json
{
  "_source": "title",
  "query": {
    "match": {
      "title": "open source"
    }
  }
}
```

to get documents with words "oven sauce" in `title` but allow 2 different
characters in the search words

```json
{
  "query": {
    "match": {
      "title": {
        "query" : "oven sauce",
        "fuzziness": 2
      }
    }
  }
}
```

to get documents with words "oven sauce" in `title` but allow some different
characters in the search words

```json
{
  "query": {
    "match": {
      "title": {
        "query" : "oven sauce",
        "fuzziness": "auto"
      }
    }
  }
}
```

to get documents with words "open source" in `title` and sort by author name
and then by descending `publish_date`

```json
{
  "query": {
    "match": {
      "title": "open source"
    }
  },
  "sort": [
    {
      "author.keyword": {
        "order": "asc"
      }
    },
    {
      "publish_date": {
        "order": "desc"
      }
    }
  ]
}
```

to get document with words "open source" in `title` and returning results of
page 4 in page with 3 results per page

```json
{
  "size": 3,
  "from": 9,
  "query": {
    "match": {
      "title": "open source"
    }
  }
}
```

to get documents with words "open source" in `content` and highlight such
words in `title` and `content`

```json
{
  "query": {
    "match": {
      "content": "open source"
    }
  },
  "highlight": {
    "fields": [
      "title",
      "content"
    ],
    "require_field_match": false,
    "pre_tags": ["<mark>"],
    "post_tags": ["</mark>"]
  }
}
```

to get document with words "open source" in `content` and filtered by category
"Engineering"

```json
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "content": "open source"
          }
        }
      ],
      "filter": {
        "match": {
          "category.keyword": "Engineering"
        }
      }
    }
  }
}
```

to get documents from `my_index` and sort by id

```json
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "_doc": {
        "order": "asc"
      }
    }
  ]
}
```

###### `GET log_*/_search`

to get distinct count of `originalUrl` in all indices prefixed with `log_`

```json
{
  "size": 0,
  "aggs": {
    "my_url_value_count": {
      "cardinality": {
        "field": "originalUrl.keyword"
      }
    }
  }
}
```

to get the maximum of `response_time` in all indices prefixed with `log_`

```json
{
  "size": 0,
  "aggs": {
    "my_max_response_time": {
      "max": {
        "field": "response_time"
      }
    }
  }
}
```

to get the number of requests per `status_code` in all indices prefixed with
`log_` and not showing terms less than 10 and sorted by `status_code`

```json
{
  "size": 0,
  "aggs": {
    "status_code_buckets": {
      "terms": {
        "field": "status_code",
        "order": {
          "_key": "asc"
        },
        "size": 10
      }
    }
  }
}
```

to get the count of requests each for week (where `@timestamp` is date field)

```json
{
  "size": 0,
  "aggs": {
    "logs_by_week": {
      "date_histogram": {
        "field": "@timestamp",
        "interval": "week"
      }
    }
  }
}
```

to get the number of requests per `status_code` in all indices prefixed with
`log_` and not showing terms less than 10 and sorted by `status_code`

```json
{
  "size": 0,
  "aggs": {
    "status_code_buckets": {
      "terms": {
        "field": "status_code",
        "order": {
          "_key": "asc"
        },
        "size": 10
      }
    }
  }
}
```

to get the count of requests for each week (where `@timestamp` is date field)
and for each `status_code`

```json
{
  "size": 0,
  "aggs": {
    "logs_by_week": {
      "date_histogram": {
        "field": "@timestamp",
        "interval": "week"
      },
      "aggs": {
        "status_code_buckets": {
          "terms": {
            "field": "status_code"
          }
        }
      }
    }
  }
}
```

to get the number of requests per `status_code` in all indices prefixed with
`log_` and show the error bound of each term

```json
{
  "size": 0,
  "aggs": {
    "status_code_buckets": {
      "terms": {
        "field": "status_code",
        "show_term_doc_count_error": true
      }
    }
  }
}
```

###### `GET my_index/_search?scroll=3m`

to get all documents from `my_index` and set paging timeout to 3 minutes

```json
{
  "size": 500,
  "query": {
    "match_all": {}
  }
}
```

###### `GET _search/scroll`

to get the next page of scroll results

```json
{
  "scroll": "3m",
  "scroll_id": "12321321321312"
}
```

###### `GET my_index/_mapping`

to check the mappings

###### `PUT my_index`

to create a custom mapping

```json
{
  "mappings": {
    "_doc": {
      "properties": {
        "publish_date": {
          "type": "date"
        },
        "author": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
        },
        "category": {
          "type": "keyword"
        },
        "content": {
          "type": "text"
        },
        "locales": {
          "type": "keyword"
        },
        "title": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
        },
        "url": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
        }
      }
    }
  }
}
```

###### `PUT my_index`

to set the number of shards and replicas of an index (note that replica of
2 represents 3 copies of the same data)

```json
{
  "settings": {
    "number_of_shards": 4,
    "number_of_replicas": 2
  }
}
```

###### `GET _analyze`

to process text with default analyzer (which is `standard`)

```json
{
  "text": [
    "My favourite movie is Star Wars!"
  ]
}
```

to process text with a simple analyzer

```json
{
  "analyzer": "simple",
  "text": "My favourite movie is Start Wars!"
}
```

to process text with standard tokeniser and lower-case and snowball filters

```json
{
  "tokenizer": "standard",
  "filter": [ "lowercase", "snowball" ],
  "text": "This release includes mainly bug fixes"
}
```

###### `GET my_index/_analyze`

to process text with analyzer in `my_index`

###### `PUT my_custom_analyzer_index`

to add/update custom analyzer and/or filters (mappings can also be set at this
point)

```json
{
  "settings": {
    "analysis": {
      "char_filter": {
        "cpp_it": {
          "type": "mapping",
          "mappings": ["c++ => cpp", "C++ => cpp", "IT => _IT_"]
        }
      },
      "filter": {
        "my_stop": {
          "type": "stop",
          "stopwords": ["can", "we", "our", "you", "your", "all"]
        }
      },
      "analyzer": {
        "my_analyzer": {
          "tokenizer": "standard",
          "char_filter": ["cpp_it"],
          "filter": ["lowercase", "stop", "my_stop"]
        }
      }
    }
  }
}
```

###### `POST _reindex`

to copy data from `blogs` to `blogs_analyzed`

```json
{
  "source": {"index": "blogs"},
  "dest":   {"index": "blogs_analyzed"}
}
```

###### `POST _aliases`

to add an alias (note that property `index` can be a wildcard)

```json
{
  "actions": [
    {
      "add": {
        "index": "my_index",
        "alias": "my_alias"
      }
    }
  ]
}
```

to remove an alias

```json
{
  "actions": [
    {
      "remove": {
        "index": "my_index",
        "alias": "my_alias"
      }
    }
  ]
}
```

###### `PUT _template/my_index_template`

to add an index template to cover all indices prefixed with `my_index` and
use same field mappings

```json
{
  "index_patterns": "my_index*",
  "settings": {
    "number_of_shards": 5,
    "number_of_replicas": 1
  },
  "mappings": {
    ...
  }
}
```

###### `POST my_index/_doc/bulk`

to update document with id `2` and add a document with id `3`

```json
{"update": {"_id": 2}}
{"doc": {"title": "The Corrected title"}}
{"index": {"_id": 3}}
{"title":"Something New", "content": "something new"}}
```

###### `GET my_index/_doc/_mget`

to get documents with id `1` and `2`

```json
{
  "docs": [
    {"_id":1},
    {"_id":2}
  ]
}
```

###### `GET _cluster/state`

to check the state of a cluster and the information shown is pretty complete

###### `GET /`

to show basic cluster information

###### `GET _cluster/health`

to show the health information and `status` is one of the properties to look
for

###### `GET _cluster/health?level=indices`

to show index-level health information

###### `GET _cluster/health/my_index?level=shards`

to show shard-level health information of index `my_index`

###### `GET _cluster/allocation/explain`

to show the explanation of problem with the primary shard of shard `2` of
`my_index`

```json
{
  "index": "my_index",
  "shard": 2,
  "primary": true
}
```
###### `GET _cat/nodes?v`

to list basic information of nodes in the cluster

###### `GET /_cat/indices?v`

to list basic information of all indices in the cluster

###### `GET /_cat/shards?v`

to list basic information of all shards in the cluster

###### `GET /_cat/shards/my_index?v`

to list basic information of all shards of `my_index`

###### `GET /_cat`

to show all available endpoints with information available in command line-like
    table

###### `PUT _snapshot/my_local_repo`

to register the path of an index snapshot repository

```json
{
  "type": "fs",
  "settings": {
    "location": "/shared_folder/my_repo"
  }
}
```

###### `PUT _snapshot/my_local_repo/my_index_snapshot_1`

to take a snapshot named `my_index_snapshot_1` of `my_index`, including the
cluster state

```json
{
  "indices": "my_index",
  "ignore_unavailable": true,
  "include_global_state": true
}
```

###### `GET _snapshot/my_local_repo/_all`

to show all snapshots created in `my_local_repo`

###### `POST _snapshot/my_local_repo/my_index_snapshot_1/_restore`

to restore `my_index` from `my_index_snapshot_1` in `my_local_repo`

```json
{
  "indices": "my_index",
  "ignore_unavailable": true,
  "include_global_state": false
}
```

#### Security

- Security does not available with basic license
- to start trail `POST _xpack/license/start_trial?acknowledge=true` (or use
    Kibana interface)
- make sure `xpack.security.enabled` is set to `true`
- use `./bin/elasticsearch-setup-passwords interactive` to setup passwords
  - the default password is `password`
  - add to `./config/kibana.yml` for the password setup on elasticsearch (that
      is, this is on Kibana server)
    - `elasticsearch.username: "kibana"`
    - `elasticsearch.password: "password"`
- passwords can be changed via Kibana
- a role can be setup to allow access to certain indices
- a user can be associated with mutliple roles

### Kibana

##### Characteristics and features

- Machine learning
  - has anomaly detection feature and forecasting feature
    - setting threshold to send alerts could be too hard so Machine learning
        could be useful
  - analysis can be done on a laptop and it is expressed as a job in Kibana
- APM
  - stack traces can be viewed as an APM transaction
  - SQL queries can be viewed in a per request basis

##### Management

- "Index Management" shows the current indices in Elastic cluster
- "Index Patterns" allows grouping of multiple indices for other uses in Kibana

##### Visualize

###### Table

To look for the top 5 hits of a web site from its logs, select table
visualization. Select "split rows" in bucket and choose aggregation by "Terms".
Select a URL field, select a descending order and size of 5. Click on "play"
button and make sure the date range on top right hand corner is in a correct
range. If the visualization looks good, click on save and give it a name.

###### Histogram

To get a histogram of response size from its long, select vertical bar
visualization. Select "x-axis" for bucket and "Histogram" for aggregation.
Select response size field and click on "play" button.

##### Dashboard

Dashboard shows multiple visualizations in a single view.

##### Dev Tools

It gives access to

- console
  - `ctrl+enter` to execute a query
- query profiler

### Logstash

- kubenetes compatible
- Beat modules can be developed to collect SQL queries
- it is more about normalising data, filtering data and may be adding more
    information to the data
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

- it does not perform any preprocessing and this means, if such processing is
    required, we need ingest nodes on Elasticsearch cluster

### Data types

- Static data which grows slowly relatively
- Time-series data

### Deployment

- It is better to deploy an Elastic stack in each data centre or cluster
- one licence per node
- Elastic cloud Enterprise is for deployment on clusters
