- [Tools](#tools)
- [Commands](#commands)
    + [Authentication](#authentication)
    + [Basic](#basic)
- [Troubleshooting](#troubleshooting)
____

# Tools

- [Another Redis Desktop
  Manager](https://github.com/qishibo/AnotherRedisDesktopManager) - a Redis
  client with GUI

# Commands

### Authentication

```sh
AUTH your-strong-password
```

or

```sh
redis-cli -h test.com -a Passw0rd
```

### Basic

##### To list all keys

```sh
KEYS *
```

##### To flush all

```sh
FLUSHALL
```

##### To increment

```sh
INCR test_counter
```

##### To set

```sh
SET test_counter 2
```

##### To get

```sh
GET test_counter
```

##### To dump output of a command

```sh
redis-cli INCR test_counter > /tmp/output.txt
```

# Troubleshooting

##### Telnet

In case `redis-cli` is not available, one can use `telnet` to check connection
and issue basic commands. For example,

```sh
> telnet redis-service-name 6379
Trying 10.0.86.32...
Connected to redis-service-name.redis.svc.cluster.local.
Escape character is '^]'.
AUTH your-strong-password
+OK
KEYS *
*0
```

To exit the session, use <kbd>ctrl</kbd><kbd>]</kbd> and execute `quit`.
