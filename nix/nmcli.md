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
