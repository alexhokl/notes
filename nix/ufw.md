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

