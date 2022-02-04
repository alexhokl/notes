- [To start console](#to-start-console)
- [To pair a device](#to-pair-a-device)
- [To connect to bluetooth device](#to-connect-to-bluetooth-device)
- [To turn (power) on bluetooth](#to-turn-power-on-bluetooth)
- [To list paired devices](#to-list-paired-devices)
- [To connect to a paired device](#to-connect-to-a-paired-device)
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

### To turn (power) on bluetooth

```sh
sudo bluetoothctl power on
```

### To list paired devices

```sh
bluetoothctl devices
```

### To connect to a paired device

```sh
bluetoothctl connect EC:66:D1:11:42:FC
```
