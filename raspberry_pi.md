### Projects

- [On/Off Project - Switch a light on/off using your smart phone](http://projects.privateeyepi.com/home/on-off-project)

### Libraries

- [EMBD](http://embd.kidoman.io/)

### Prepare Respbian on a SD card

#### On Linux

```sh
curl -f https://downloads.raspberrypi.org/raspbian_lite_latest -o raspbian.zip
unzip raspbian.zip
lsblk
sudo umount /dev/sdX1
sudo umount /dev/sdX2
sudo dd bs=4M if=2017-11-29-raspbian-stretch-lite.img of=/dev/sdX conv=fsync
```

#### On Mac

```sh
curl -L https://downloads.raspberrypi.org/raspbian_lite_latest -o raspbian.zip
unzip raspbian.zip
diskutil list
diskutil unmount /dev/diskX
sudo dd bs=1m if=2017-11-29-raspbian-stretch-lite.img of=/dev/rdiskX conv=sync
```

#### Initial setup

Change to the directory with Raspbian SD card mounted and execute the following script.

```sh
cat > wpa_supplicant.conf << 'EOT'
country=GB
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="my-ssid"
  psk="my-password"
}
EOT
cat >> config.txt << 'EOT'
# To lower GPU usage (assuming headless)
gpu_mem=16
EOT
touch ssh
```

### Installing Docker (see [detail](http://blog.alexellis.io/getting-started-with-docker-on-raspberry-pi/))

```sh
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
```
