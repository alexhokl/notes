- [To disable WiFi](#to-disable-wifi)
- [To enable WiFi](#to-enable-wifi)
- [To list WiFi SSIDs](#to-list-wifi-ssids)
- [To add a WiFi connection](#to-add-a-wifi-connection)
- [To establish a connection](#to-establish-a-connection)
____
### To disable WiFi

```sh
nmcli radio wifi off
```
### To enable WiFi


```sh
nmcli radio wifi on
```

### To list WiFi SSIDs

```sh
nmcli dev wifi
```

### To add a WiFi connection

```sh
nmcli dev wifi connect "Your SSID"
```

or with password

```sh
nmcli dev wifi connect "Your SSID" -a
```

### To establish a connection

```sh
nmcli c connect "Your Connection Name"
```
