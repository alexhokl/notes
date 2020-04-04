  * [To start console](#to-start-console)
  * [To pair a device](#to-pair-a-device)
  * [To connect to bluetooth device](#to-connect-to-bluetooth-device)
- [`bt-device`](#bt-device)
  * [To list all paired bluetooth devices](#to-list-all-paired-bluetooth-devices)
____
### To start console

```sh
bluetoothctl
```

### To pair a device

Ensure the device to be paired is in a discoverable state.

```sh
scan on
connect BB:BB:BB:BB:BB:BB
scan off
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
