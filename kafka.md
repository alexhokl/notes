- [Tips](#tips)
- [Links](#links)
  * [Kafka](#kafka)
  * [Confluent](#confluent)
  * [Clients](#clients)
  * [Others](#others)
- [Command line](#command-line)
  * [Kafkacat](#kafkacat)
  * [kafka-console-producer, kafka-console-consumer](#kafka-console-producer-kafka-console-consumer)
____

## Tips

- Number of `zookeeper` instances mus be in odd number usually 5 instances can
    already serve a large cluster and, thus, 3 instances is likely enough for
    most scenarios.
- SSD hard disk may not be required as Kafka mostly doing sequential reads.
- Schema registry helps the consumers to figure out which schema to use for
    de-serialization. 
  - There is a good chance `protobuf` support in schema registry will be available
      by the end of 2019. (as of mid-2019, it only supports `arvo`)

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
- [confluent-kafka-go](https://github.com/confluentinc/confluent-kafka-go) Confluent's Apache Kafka Golang client

### Others

- [wurstmeister/kafka-docker](https://github.com/wurstmeister/kafka-docker) Dockerfile for Apache Kafka
- [Understanding Kafka with Legos](https://www.youtube.com/watch?v=Q5wOegcVa8E)
- [Introduction to Apache Kafka by James Ward](https://www.youtube.com/watch?v=UEg40Te8pnE)
- [Protocol Buffer](https://developers.google.com/protocol-buffers/docs/gotutorial)
- [Kafka Listeners
  Explained](https://rmoff.net/2018/08/02/kafka-listeners-explained/)
- [edenhill/kafkacat](https://github.com/edenhill/kafkacat)
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
