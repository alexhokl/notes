- [Links](#links)
- [Terminal](#terminal)
- [Shortcuts](#shortcuts)
- [Scripting](#scripting)
  * [command substitution](#command-substitution)
  * [process substitution](#process-substitution)
  * [string](#string)
  * [list and range](#list-and-range)
  * [for](#for)
  * [if](#if)
  * [function](#function)
  * [options](#options)
  * [variables](#variables)
- [Recipes](#recipes)
  * [Versions](#versions)
  * [Users](#users)
  * [Disks](#disks)
  * [Hardware](#hardware)
  * [Directories](#directories)
  * [Power](#power)
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

## Links

- [List of Linux bash commands](https://github.com/trinib/Linux-Bash-Commands)

## Terminal

| Combination                             | Functionality                                                             |
| ---                                     | ---                                                                       |
| <kbd>ctrl</kbd><kbd>a</kbd>             | to jump to the beginning of a line                                        |
| <kbd>ctrl</kbd><kbd>e</kbd>             | to jump to the end of a line                                              |
| <kbd>ctrl</kbd><kbd>w</kbd>             | to cut a word before the cursor                                           |
| <kbd>ctrl</kbd><kbd>k</kbd>             | to cut to the end of a line                                               |
| <kbd>ctrl</kbd><kbd>u</kbd>             | to cut to the beginning of a line                                         |
| <kbd>ctrl</kbd><kbd>y</kbd>             | to paste already cut text                                                 |
| <kbd>alt</kbd><kbd>b</kbd>              | to skip one word backward                                                 |
| <kbd>alt</kbd><kbd>f</kbd>              | to advance one work forward                                               |
| <kbd>alt</kbd><kbd>d</kbd>              | to delete until the end of the current word include the current character |
| <kbd>ctrl</kbd><kbd>x</kbd><kbd>e</kbd> | to edit the current command in default editor                             |
| <kbd>alt</kbd><kbd>.</kbd>              | to paste the last argument of the last command                            |
| <kbd>alt</kbd><kbd>2</kbd>              | to copy the 2nd argument of the last command                              |
| <kbd>ctrl</kbd><kbd>/</kbd>             | to undo                                                                   |
| <kbd>ctrl</kbd><kbd>_</kbd>             | to redo                                                                   |
| `reset`                                 | to reset the current shell                                                |
| `fc`                                    | to edit the last command in the default editor                            |
| <kbd>ctrl</kbd><kbd>r</kbd>             | to search commands in history

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

To repeat the last parameter of the last command (space delimited)

```sh
git clone https://github.com/cli/cli githubcli
cd !$
```

## Scripting

### command substitution

```sh
$EDITOR `rg -l some_word`
```

This opens all the files found by `rg` in the default editor.

This is similar to `$()`, which is bash-specific, but it is also different where
command substitution cannot be nested (which means substitution within
substitution).

### process substitution

One of the use cases is to avoid generate temporary files storing output of
a command.

```sh
delta <(cat a.txt) <(cat b.txt)
```

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
- `[[ "${str1,,}" != "${str2,,}" ]]` checks if `str1` equals `str2` in
  a case-insensitive way
- `[ -n "$str" ]` checks if `str` is not empty
- `[ -z "$str" ]` checks if `str` is empty
- `[ $int1 -eq $int2 ]` checks if `int1` equals `int2`
- `elif` else-if
- `[ -d some-directory ]` checks if directory `some-directory` exists
- `[ -f some-file ]` checks if file `some-file` exists
- `[ -c some-file ]` checks if file `some-file` has contents
- `[ -L some-link ]` checks if a symbolic link exists
- `[ ! -f some-file ]` checks if file `some-file` not exists
- `[ -f *suffix ]` checks if file with suffix `suffix` exists
- `[ -z "${MY_VAR:-}" ]` checks if variable `MY_VAR` exists

### function

- `$2` refers to second argument of a function
- `for arg in "$@"; do echo "$arg"; done` echo out all arguments

### options

##### set -x

- enables a mode of the shell where executed commands are printed to the
  terminal.
- example usage
  - `[[ -n $DEBUG ]] && set -x`
- `set +x` disables this functionality

##### set -euo pipefail

- `-e` causes a bash script to exit immediately when a command fails
  - append `|| true` to a command if immediate exit is not expected
- `set -o pipefail` ensure exit in first of the piped command
- `-u` causes the bash shell to treat unset variables as an error and exit
  immediately

### variables

##### To make indirect reference to another variable

```sh
sites=$(eval "echo \$${DEPLOYMENT_TYPE}_sites")
```

##### to modify PATH

```sh
echo ${PATH} > t1
vi t1
export PATH=$(cat t1)
```

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

##### To check status of an account

```sh
passwd -S your-username
```

Note that this can check if an account has been locked.

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

##### To check battery information

```sh
upower -i /org/freedesktop/UPower/devices/battery_BAT0
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

##### To convert a JPG file with a lower quality

```sh
convert source.jpg -q 80 destination.jpg
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

#### Links

- [Sloth](https://github.com/sveinbjornt/Sloth) on Mac

##### To kill a process running on a particular port

```sh
kill $(lsof -ti tcp:3000)
```

##### To list process occupied a file

```sh
fuser -v /path/to/file
```

##### To list process occupied a port

```sh
fuser -v -n tcp 3000
```

##### To kill all processes by name

```sh
killall your-program-name
```

##### To keep all processes running after exiting the current terminal

```sh
disown -a && exit
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
