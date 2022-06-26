- [Commands](#commands)
____
### Commands

#### Filtering

##### since

```sh
journalctl --since "2015-01-10 17:15:00"
```

```sh
journalctl --since "2015-01-10" --until "2015-01-11 03:00"
```

```sh
journalctl --since yesterday
```

```sh
journalctl --since 09:00 --until "1 hour ago"
```

##### list boots

```sh
journalctl --list-boots
```

##### current boot

```sh
journalctl -b
```

##### last boot

```sh
journalctl -b -1
```

##### particular boot

```sh
journalctl -b caf0524a1d394ce0bdbcff75b94444fe
```

##### service

```sh
journalctl -u nginx.service --since today
```

#### Formatting

##### UTC

```sh
journalctl --utc
```

##### pager

```sh
journalctl --no-pager
```

##### json

```sh
journalctl -b -u nginx -o json
```

```sh
journalctl -b -u nginx -o json-pretty
```

##### tail

```sh
journalctl -n 20
```

##### follow

```sh
journalctl -f
```
