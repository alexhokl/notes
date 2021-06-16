- [Tools](#tools)
- [Commands](#commands)
    + [Authentication](#authentication)
    + [Basic](#basic)
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

### Basic

##### To list all keys

```sh
KEYS *
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
