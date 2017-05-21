### Projects

- [On/Off Project - Switch a light on/off using your smart phone](http://projects.privateeyepi.com/home/on-off-project)

### Libraries

- [EMBD](http://embd.kidoman.io/)

### Initial setup (see [detail](http://blog.alexellis.io/getting-started-with-docker-on-raspberry-pi/))

to edit boot config and add line the following line to lower GPU usage (assuming headless)
```
gpu_mem=16
```
```sh
sudo nano /boot/config.txt
```

to install docker
```sh
curl -sSL get.docker.com | sh
```

to add user pi to user-group docker
```sh
sudo usermod -aG docker pi
```

to install docker-compose
```sh
sudo pip install docker-compose
```

to check available WiFi connections
```sh
sudo iwlist wlan0 scan
```

to edit config to add WiFi connection
```sh
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```

to add a connection to wpa_supplicant.conf
```
network={
    ssid="The_SSID"
    psk="The_wifi_password"
}
```

to restart WiFi connection after editing wpa_supplicant.conf
```sh
sudo ifdown wlan0
sudo ifup wlan0
```
