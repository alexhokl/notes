- [Examples](#examples)

____

# Examples

##### To find a process running on a protocol

```sh
lsof -i tcp
```

##### To find a process running on a port

```sh
lsof -i :3000
```

##### To find a process running on a port and a protocol

```sh
lsof -i tcp:3000
```

##### To list processes running in the specified directory

```sh
lsof /path/to/directory
```

