- [Port check](#port-check)
- [SSH banner](#ssh-banner)
- [Listen to a port](#listen-to-a-port)
- [Listen to a port a pipe contents to a shell](#listen-to-a-port-a-pipe-contents-to-a-shell)
- [Send text to a port of a machine](#send-text-to-a-port-of-a-machine)
- [To send a file to a port of a machine](#to-send-a-file-to-a-port-of-a-machine)
____

## Port check

```sh
nc -zv test.com 80
```

where option `v` for verbose.

## SSH banner

```sh
echo "QUIT" | nc test.com 22
```

## Listen to a port

```sh
nc -l -p 8080
```

This listens to a local TCP port of `8080` and print whatever it gets from the
port.

We can also forard what it receives to a file.

```sh
nc -l -p 8080 > result.txt
```

## Listen to a port a pipe contents to a shell

```sh
nc -l -p 8080 -e /bin/bash
```

Commands can be sent to the shell via `nc` as well.

```sh
nc localhost 8080
```

## Send text to a port of a machine

```sh
nc localhost 8080
```

or to a remote machine

```sh
nc test.com 8080
```

## To send a file to a port of a machine

```sh
nc localhost 8080 < blogs.csv
```

