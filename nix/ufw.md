- [To check status](#to-check-status)
- [To allow SSH traffic](#to-allow-ssh-traffic)
- [To enable](#to-enable)
- [To disable](#to-disable)
- [To check status with index numbers](#to-check-status-with-index-numbers)
- [To delete a rule](#to-delete-a-rule)
- [To allow a port range](#to-allow-a-port-range)
- [To allow a port from access from an IP range](#to-allow-a-port-from-access-from-an-ip-range)
- [To allow access to a port using an interface](#to-allow-access-to-a-port-using-an-interface)
- [To allow fast peer-to-peer access for Tailsacle](#to-allow-fast-peer-to-peer-access-for-tailsacle)
____

### To check status

```sh
sudo ufw status
```

### To allow SSH traffic

```sh
sudo ufw allow 22
```

### To enable

```sh
sudo ufw enable
```

### To disable

```sh
sudo ufw disable
```

### To check status with index numbers

```sh
sudo ufw status numbered
```

### To delete a rule

```sh
sudo ufw delete 987
```

### To allow a port range

```sh
sudo ufw allow 6000:6007/tcp
```

Note that protocol is required in this case.

### To allow a port from access from an IP range

```sh
sudo ufw allow from 192.168.1.0/24 to any port 22
```

### To allow access to a port using an interface

```sh
sudo ufw allow in on tailscale0 to any port 22
```

### To allow fast peer-to-peer access for Tailsacle

```sh
sudo ufw allow 41641/udp
```
