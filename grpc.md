- [gRPC](#grpc)
  * [Tools](#tools)
  * [Characteristics](#characteristics)
  * [Protocol Buffers](#protocol-buffers)
___

# gRPC

## Tools

- [Forest33/warthog](https://github.com/Forest33/warthog) a cross platform gRPC
  GUI client

## Characteristics

- it runs over HTTP/2
- it uses Protocol Buffers
- primarily designed for distributed systems as it has built-in support for load
  balancing, tracing, health checking, and authentication
- multiplexing allows a client to fire off multiple requests at once on the same
  connection and receive the responses back in any order
  * allows long-lived connections and avoiding the overhead of creating a new
    connection for each request
- it uses explicit error codes (not HTTP status codes)
- it has only very limited browser support via gRPC-Web
- types of APIs
  * Unary
    * a single request followed by a single response
  * Server-side streaming
  * Client-side streaming
  * Bidirectional streaming

## Protocol Buffers

- `protoc` generates client and server code interfaces
  * multiple programming languages are supported
- marshaled into a compact binary format
- futher compression (built-in) can be configured
