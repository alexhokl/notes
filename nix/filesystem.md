- [Concepts](#concepts)
  * [Layers of file system](#layers-of-file-system)
- [Commands](#commands)
  * [Disks](#disks)
  * [Directories](#directories)
  * [Encrypted drive](#encrypted-drive)
____

## Concepts

### Layers of file system

![file system](./images/file_system.webp)

Source: [Command Line
Magic](https://mastodon.social/@climagic/110248394464668802)

## Commands

### Disks

##### To check free space and file system types

```sh
df -Th
```

##### To change file system of a partition (and format it)

```sh
sudo mkfs.ext4 /dev/sda2
```

or to change to fat32 system,

```sh
sudo mkfs.vfat /dev/sda2
```

##### To label a partition

```sh
sudo e2label /dev/sda2 A_LABEL
```

##### To list all partitions

```sh
sudo fdisk -l
```

##### To change partitions of a disk

```sh
sudo fdisk /dev/sdX
```

##### to check disk usage in the current directory

```sh
du -sh
```

##### to check disk usage of directories of the current path

```sh
du --max-depth=1 -h
```

or,

```sh
du -d 1 -h
```

##### To mount one of disks of RAID 1 array

Assume `mdadm` has been installed.

List block devices by using `lsblk`.

If there is the volume is not managed by LVM (that is, no `lvm` appeared under
`raid1`),

```sh
sudo mount -o ro,noload /dev/md1 /mnt/your-mount-point/
```

If it is managed by LVM, use `sudo lvdisplay` to allocate the volume label and
execute the following (assuming `/dev/vg1/lv1`).

```sh
sudo mount -o ro,noload /dev/vg1/lv1 /mnt/your-mount-point/
```

Note: In case the volume to be mounted does not appeared as type `raid1` or
`lvm`, it is likely the mounted as something like `/dev/md1`. We need to stop it
first by `sudo mdadm --stop /dev/md1` and then re-assemble the array by
`sudo mdadm --assemble --run --readonly --force /dev/md0 /dev/sda3`.

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

