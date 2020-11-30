- [Use cases](#use-cases)
- [Advantages](#advantages)
- [Tips](#tips)
- [Links](#links)
  * [Kafka](#kafka)
  * [Confluent](#confluent)
  * [Clients](#clients)
  * [Videos](#videos)
  * [Others](#others)
- [Command line](#command-line)
  * [Kafkacat](#kafkacat)
  * [kafka-console-producer, kafka-console-consumer](#kafka-console-producer-kafka-console-consumer)
____

## Use cases

- modern (and scalable) ETL / CDC
- data pipelines
- big data ingest
- map-reduce using Kafka Streams

## Advantages

- transient data persistence
- immutable data
- ordered data
- replayable

## Tips

- Number of `zookeeper` instances must be in odd number usually `5` instances
  can already serve a large cluster and, thus, `3` instances is likely enough
  for most scenarios.
- SSD hard disk may not be required as Kafka mostly doing sequential reads.
- Schema registry helps the consumers to figure out which schema to use for
  de-serialization.

## Links

### Kafka

- [Documentation](https://kafka.apache.org/documentation/)
- [Ecosystem](https://cwiki.apache.org/confluence/display/KAFKA/Ecosystem)
- [Clients](https://cwiki.apache.org/confluence/display/KAFKA/Clients)

### Confluent

- [Confluent Platform Kafka Helm Chart](https://github.com/confluentinc/cp-helm-charts/tree/master/charts/cp-kafka)
- [Confluent Operator](https://docs.confluent.io/current/installation/operator/index.html#operator-about-intro)
- [development setup using docker-compose](https://docs.confluent.io/current/quickstart/ce-docker-quickstart.html)

### Clients

- [Shopify/sarama](https://github.com/Shopify/sarama) a Go library for Apache Kafka 0.8, and up
- [confluent-kafka-go](https://github.com/confluentinc/confluent-kafka-go)
  ([documentation](https://docs.confluent.io/clients-confluent-kafka-go/current/index.html))
  Confluent's Apache Kafka Golang client

### Videos

- [Introduction to Apache Kafka by James
  Ward](https://www.youtube.com/watch?v=UEg40Te8pnE)
- [Develop Apache Kafka applications with Strimzi and
  Minikube](https://www.youtube.com/watch?v=4bKSPrENDQQ)
- [A Deep Dive into Apache Kafka This is Event Streaming by Andrew Dunnings
  \& Katherine Stanley](https://www.youtube.com/watch?v=X40EozwK75s) - the last
  part about Streams is particularly useful
- [Kafka as a Platform: The Ecosystem from the Ground Up - Robin
  Moffatt](https://www.youtube.com/watch?v=qjTZ4UeJdoI) - the last part has
  a pretty good demo on KSQL

### Others

- [strimzi/strimzi-kafka-operator](https://github.com/strimzi/strimzi-kafka-operator)
- [Docker image bitnami/kafka](https://github.com/bitnami/bitnami-docker-kafka)
- [edenhill/kafkacat](https://github.com/edenhill/kafkacat)
- [wurstmeister/kafka-docker](https://github.com/wurstmeister/kafka-docker) Dockerfile for Apache Kafka
- [Protocol Buffer](https://developers.google.com/protocol-buffers/docs/gotutorial)
- [Kafka Listeners
  Explained](https://rmoff.net/2018/08/02/kafka-listeners-explained/)
- [Should You Put Several Event Types in the Same Kafka
  Topic?](https://www.confluent.io/blog/put-several-event-types-kafka-topic/)

## Command line

### Kafkacat

##### To list listeners and topics of brokers

```sh
kafkacat -b localhost:9092 -L
```

##### More examples

- [Examples](https://github.com/edenhill/kafkacat#examples)

### kafka-console-producer, kafka-console-consumer

##### To write messages in a terminal to topic `test`

```sh
docker run --rm --network=your-docker-network bitnami/kafka:2-debian-10 kafka-console-producer.sh --bootstrap-server kafka:9092 --topic test
```

##### To read all messages from topic `test`

```sh
docker run --rm --network=your-docker-network bitnami/kafka:2-debian-10 kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic test --from-beginning
```
