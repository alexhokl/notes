- [Concepts](#concepts)
  * [Layers of file system](#layers-of-file-system)
- [Commands](#commands)
  * [Directories](#directories)
  * [Encrypted drive](#encrypted-drive)
____

## Concepts

### Layers of file system

![file system](./images/file_system.webp)

Source: [Command Line
Magic](https://mastodon.social/@climagic/110248394464668802)

## Commands

### Directories

##### To create a temporary directory

```sh
mktemp
```

or to save the directory path to a variable as well,

```sh
TEMP_DIR=$(mktemp)
```

### Encrypted drive

##### To mount an encrypted drive

```sh
sudo mkdir /mnt/encrypted-storage
sudo cryptsetup luksOpen /dev/sda1 secret
sudo mount /dev/mapper/secret /mnt/encrypted-storage
```

or

```sh
lsblk
sudo cryptsetup luksOpen /dev/sda3 old_hdd
sudo vgdisplay --short
sudo lvs -o lv_name,lv_size -S vg_name=debian-iMac-vg
sudo lvchange -ay debian-iMac-vg/root
mkdir old-hdd
sudo mount /dev/debian-iMac-vg/root ~/old-hdd
```

##### To unmount an encrypted drive

```sh
sudo umount /mnt/encrypted-storage/
sudo cryptsetup luksClose secret
```

or

```sh
sudo umount /dev/debian-iMac-vg/root
sudo lvchange -an debian-iMac-vg/root
sudo cryptsetup luksClose encrypted_device
```

##### To create an encrypted partition

```sh
sudo dd if=/dev/urandom of=/dev/sda bs=4M status=progress
sudo fdisk /dev/sda # erase and create a partition
sudo cryptsetup luksFormat /dev/sda
sudo cryptsetup luksOpen /dev/sda1 secret
sudo mkfs.ext2 /dev/mapper/secret -L your-label
```

Note that file system could be other than `ext2`.
`secret` is a mapping name.

