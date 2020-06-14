- [Terminal](#terminal)
- [Shortcuts](#shortcuts)
- [Scripting](#scripting)
  * [string](#string)
  * [list and range](#list-and-range)
  * [for](#for)
  * [if](#if)
  * [function](#function)
- [Recipes](#recipes)
  * [Versions](#versions)
  * [Users](#users)
  * [Disks](#disks)
  * [Hardware](#hardware)
  * [Directories](#directories)
  * [Power](#power)
  * [Network](#network)
  * [Wifi](#wifi)
  * [Encrypted drive](#encrypted-drive)
  * [Locales](#locales)
  * [Printing](#printing)
  * [Images](#images)
  * [Videos](#videos)
  * [Timezones](#timezones)
  * [Packages](#packages)
  * [Processes](#processes)
____

## Terminal

| Combination | Functionality |
| --- | --- |
| ctrl+a | to jump to the beginning of a line |
| ctrl+e | to jump to the end of a line |
| ctrl+w | to cut a word before the cursor |
| ctrl+k | to cut to the end of a line |
| ctrl+u | to cut to the beginning of a line |
| ctrl+y | to paste already cut text |
| alt+b  | to skip one word backward |
| alt+f  | to advance one work forward |
| alt+d  | to delete until the end of the current word include the current character |
| ctrl+x+e | to edit the current command in default editor |
| alt+.  | to paste the last argument of the last command |
| alt+2  | to copy the 2nd argument of the last command |
| ctrl+_ | to redo |
| `reset` | to reset the current shell |
| `fc` | to edit the last command in the default editor |
| ctrl+r | to search commands in history

## Shortcuts

##### To show the current process ID

```sh
echo $$
```

##### To repeat the last command

```sh
!!
```

##### To repeat the last command with sudo

```sh
sudo !!
```

## Scripting

### string

##### replace string in a variable

```sh
${f/\.txt/\.pdf}
```

### list and range

##### expanding list or range

```sh
mkdir -p folder/{sub1,sub2}/temp
mkdir -p folder/{1..100}/temp
mkdir -p folder/{a..z}/temp
```

### for

##### To loop through some of the files in current folder (where it is harder to use `find`)

```sh
for f in ./production.*; do echo $f; done
```

##### To loop through a bash array

```sh
colours=(red green blue)
for c in ${colours[*]}; do echo $c; done
```

##### To indirect reference an array in a loop

```sh
fruits_red=(grapefruit)
fruits_green=(kiwi)
fruits_blue=(blueberries)
colours=(red green blue)
for c in ${colours[*]}; do
    eval fruits=('"${fruits_'${c}'[@]}"')
    for f in ${fruits[*]}; do
        echo $c - $f
    done
done
```

### if

- `[ <condition> ]` is an old test where it works on all *-nix environment
- `[[ <condition> ]]` is a new test where it works only on modern Linux
    environment
- `==` EQUAL operator (in new test only)
- `&&` AND operator
- `||` OR operator; for example `[ <condition1> ] || [ <condition2> ]`
- `[ $# -lt 2 ]` checks if number of arguments is less than 2
- `[ "$str1" = "$str2" ]` checks if `str1` equals `str2`
- `[ "$str1" != "$str2" ]` checks if `str1` not equals `str2`
- `[[ "$str1" == *"end" ]]` checks if `str1` ends with `end`
- `[ -n "$str" ]` checks if `str` is not empty
- `[ -z "$str" ]` checks if `str` is empty
- `[ $int1 -eq $int2 ]` checks if `int1` equals `int2`
- `elif` else-if
- `[ -d some-directory ]` checks if directory `some-directory` exists
- `[ -f some-file ]` checks if file `some-file` exists
- `[ -L some-link ]` checks if a symbolic link exists
- `[ ! -f some-file ]` checks if file `some-file` not exists
- `[ -f *suffix ]` checks if file with suffix `suffix` exists

### function

- `$2` refers to second argument of a function
- `for arg in "$@"; do echo "$arg"; done` echo out all arguments

## Recipes 

### Versions

##### To check the distribution of linux

```sh
cat /etc/*release
```

##### To check linux kernel version

```sh
uname -a
```

### Users

##### To show the user groups the current user belongs to

```sh
groups
```

##### To add user to a group

```sh
usermod -a -G your-group your-username
```

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

##### To list all partitions

```sh
sudo fdisk -l
```

##### To change partitions of a disk

```sh
sudo fdisk /dev/sdX
```

##### To create a bootable USB from an ISO

```sh
sudo dd bs=4M if=~/Downloads/ubuntu-18.04.4-desktop-amd64.iso of=/dev/sda conv=fdatasync
```

##### To write random bits into a USB (or any mounts)

```sh
sudo dd if=/dev/urandom of=/dev/sda bs=4M status=progress
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

### Hardware

##### To list all PCI devices

```sh
lspci -vnn
```

### Directories

##### To create a temporary directory

```sh
mktemp
```

or to save the directory path to a variable as well,

```sh
TEMP_DIR=$(mktemp)
```

### Power

##### To disable suspend and hibernation

```sh
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

To enable suspend and hibernation

```sh
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

### Network

##### nslookup

To check the IP addresses of a domain

```sh
nslookup github.com
```

### Wifi

##### wpa_passphrase

To generate configuration for login

```sh
wpa_passphrase your-ssid your-strong-password
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

##### To change CRLF (Windows) line-endings to LF (Unix)

On Mac,

```sh
find ./ -type f -exec perl -pi -e 's/\r\n|\n|\r/\n/g' {} \;
```

Or on linux,

```sh
find . -type f -exec grep -qIP '\r\n' {} ';' -exec perl -pi -e 's/\r\n/\n/g' {} '+'
```

##### To reload Nginx in a container

```sh
nginx -s reload
```

### Locales

##### To show all installed locales and its metadata

```sh
locale
```

##### To show just locale

```sh
locale -a
```

### Printing

##### To show CUPS status information

```sh
lpstat -a
```

### Images

##### To convert a PNG file to an ICO file

```sh
convert -background transparent image.png -define icon:auto-resize=16,32,48,64,256 favicon.ico
```

##### To convert a AVI file to MPEG-4 file

```sh
ffmpeg -i video.avi -b 100k video.mp4
```

##### To convert an image to webp format

```sh
cwebp -q 80 source.image.png -o destination.webp
```

### Videos

##### To record screen in a GIF

```sh
byzanz-record -d 20 -x 0 -y 0 -w 1920 -h 2160 ~/Pictures/screencast.gif
```

##### To record screen with mouse cursor in a GIF

```sh
byzanz-record -d 20 -x 0 -y 0 -w 1920 -h 2160 -c ~/Pictures/screencast.gif
```

##### To record screen with mouse cursor in a WebM

```sh
byzanz-record -d 20 -x 0 -y 0 -w 1920 -h 2160 ~/Pictures/screencast.webm
```

### Timezones

##### To set timezone

```sh
sudo unlink /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
```

### Packages

##### To reconfigure an installed package

```sh
sudo dpkg-reconfigure locale
```

to configure locale.

### Processes

##### To kill a process running on a particular port

```sh
kill $(lsof -ti tcp:3000)
```

##### To kill all processes by name

```sh
killall your-program-name
```

##### To keep all processes running after exiting the current terminal

```sh
disown -a && exit
```

##### To make indirect reference to another variable

```sh
sites=$(eval "echo \$${DEPLOYMENT_TYPE}_sites")
```

##### To check available memory

```sh
free -h
```

##### current running processes memory usage

```sh
top
```

##### To list most of the current network ports (or sockets)

```sh
sudo netstat -tupln
```

##### to modify PATH

```sh
echo ${PATH} > t1
vi t1
export PATH=$(cat t1)
```

