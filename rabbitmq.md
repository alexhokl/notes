
____

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
- Message acknowledgments are turned on by default. But if it is turned off, messages are removed from message queue once it is consumed and it does not matter whether the consumer fails to process the message or not.
- An ack(nowledgement) is sent back from the consumer to tell RabbitMQ that a particular message has been received, processed and that RabbitMQ is free to delete it.
- If a consumer dies (its channel is closed, connection is closed, or TCP connection is lost) without sending an ack, RabbitMQ will understand that a message wasn't processed fully and will re-queue it. If there are other consumers online at the same time, it will then quickly redeliver it to another consumer. That way you can be sure that no message is lost, even if the workers occasionally die.
- There aren't any message timeouts; RabbitMQ will redeliver the message when the consumer dies. It's fine even if processing a message takes a very, very long time.
- Command `rabbitmqctl` to print the `messages_unacknowledged` field to check if there are excessive unacknowledged messages. `sudo rabbitmqctl list_queues name messages_ready messages_unacknowledged`
- When RabbitMQ quits or crashes it will forget the queues and messages unless you tell it not to. Two things are required to make sure that messages aren't lost: we need to mark both the queue and messages as durable. This can be done by declaring queue as durable and marking messages as persistent.
- RabbitMQ doesn't allow you to redefine an existing queue with different parameters and will return an error to any program that tries to do that.
- The message persistance guarantees are not strong as there is a very short window of message received a message and saving it to disk. Publisher confirms should be used if strong guarantee is required.
-
