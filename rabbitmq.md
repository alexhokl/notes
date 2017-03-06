This document could be tailored towards the use of RabbitMQ using .NET client.

#### Queue Characteristics

- infinite buffer
- many-to-many relationship between producer and consumer

#### Protocol (AMQP-0-9-1)

- which AWS SQS does not implement
- an HTTP-like thing
- it does not have an API
- a wire-level protocol
- platform and protocol neutral
- no multicast
- Window Azure Service Bus implemented this protocol
- guaranteed transport
- SOAP, WS-Security, WS-Transactions, WS-MetaData Exchange could be build on top of this
- modes
    - fire and forget
    - pub/sub
    - file transfer

#### .NET client (EasyNetQ on top of official client)

- class name of message object determines the queue to be used
- API
  - declaring a queue is idempotent, it will only be created if it does not exist already
- message content is a byte array
- it needs 50MB free space by default
- consumers on the same queue receive messages in round-robin manner

