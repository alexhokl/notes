- [Kafka](#kafka)
____

### Kafka

#### Tips

- Number of `zookeeper` instances mus be in odd number usually 5 instances can
    already serve a large cluster and, thus, 3 instances is likely enough for
    most scenarios.
- SSD hard disk may not be required as Kafka mostly doing sequential reads.
- Schema registry helps the consumers to figure out which schema to use for
    de-serialization. 
  - There is a good chance `protobuf` support in schema registry will be available
      by the end of 2019. (as of mid-2019, it only supports `arvo`)

#### Links

- [Documentation](https://kafka.apache.org/documentation/)
- [Ecosystem](https://cwiki.apache.org/confluence/display/KAFKA/Ecosystem)
- [Clients](https://cwiki.apache.org/confluence/display/KAFKA/Clients)
- [Shopify/sarama](https://github.com/Shopify/sarama) a Go library for Apache Kafka 0.8, and up
- [confluent-kafka-go](https://github.com/confluentinc/confluent-kafka-go) Confluent's Apache Kafka Golang client
- [wurstmeister/kafka-docker](https://github.com/wurstmeister/kafka-docker) Dockerfile for Apache Kafka
- [ches/docker-kafka](https://github.com/ches/docker-kafka) Apache Kafka on Docker
- [spotify/kafka](https://hub.docker.com/r/spotify/kafka/) A simple docker image with both Kafka and Zookeeper
- [Zookeeper](https://hub.docker.com/_/zookeeper/)
- [saumitras/kafka-twitter-docker](https://github.com/saumitras/kafka-twitter-docker/blob/master/docker-compose.yml) An example on using Zookeeper and Kafka in Docker containers
- [Understanding Kafka with Legos](https://www.youtube.com/watch?v=Q5wOegcVa8E)
- [Introduction to Apache Kafka by James Ward](https://www.youtube.com/watch?v=UEg40Te8pnE)
- [Protocol Buffer](https://developers.google.com/protocol-buffers/docs/gotutorial)
