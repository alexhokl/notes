
____
##### To mount a USB drive on linux

```sh
lsblk
sudo mount /dev/sdc1 /home/current-user/usb
```

##### To umount a USB drive on linux

```sh
sudo umount /home/current-user/usb
```

##### To mount a NTFS Windows drive on linux

```sh
lsblk
sudo mount -t ntfs-3g /dev/sdc1 /home/current-user/hdd
```

##### To mount a NFS drive

```sh
sudo mount -t nfs 192.168.300.300:/home/current-user/directory $HOME/remote-directory
```

