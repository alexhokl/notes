  * [To start console](#to-start-console)
  * [To connect to bluetooth device](#to-connect-to-bluetooth-device)
- [`bt-device`](#bt-device)
  * [To list all paired bluetooth devices](#to-list-all-paired-bluetooth-devices)
____
### To start console

```sh
bluetoothctl
```

### To connect to bluetooth device

```sh
connect BB:BB:BB:BB:BB:BB
```

Note that the MAC address should be listed upon connecting to console.

## `bt-device`

### To list all paired bluetooth devices

```sh
bt-device -l
```
