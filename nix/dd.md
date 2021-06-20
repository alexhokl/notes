##### To create a bootable USB from an ISO

```sh
sudo dd bs=4M if=~/Downloads/ubuntu-18.04.4-desktop-amd64.iso of=/dev/sda conv=fdatasync
```

##### To write random bits into a USB (or any mounts)

```sh
sudo dd if=/dev/urandom of=/dev/sda bs=4M status=progress
```

