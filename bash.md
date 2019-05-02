### Topics

- [Shell](#shell)
- [Non-commands](#non-commands)
- [Commands](#commands)
    + [ls](#ls)
    + [wc](#wc)
    + [find](#find)
    + [grep](#grep)
    + [sed and replacements](#sed-and-replacements)
    + [uniq](#uniq)
    + [sort](#sort)
    + [xargs](#xargs)
    + [awk](#awk)
    + [for and list](#for-and-list)
    + [head & tail](#head--tail)
    + [curl](#curl)
    + [openssl](#openssl)
    + [APT](#apt)
    + [GPG](#gpg)
    + [cut](#cut)
    + [SSH](#ssh)
    + [Versions](#versions)
    + [VPN](#vpn)
    + [ip](#ip)
    + [diff](#diff)
    + [Tar](#tar)
    + [Encrypted drive](#encrypted-drive)
    + [Recipes](#recipes)

### Shell

| Combination | Functionality |
| --- | --- |
| ctrl+a | to jump to the beginning of a line |
| ctrl+e | to jump to the end of a line |
| ctrl+w | to cut a word before the cursor |
| ctrl+k | to cut to the end of a line |
| ctrl+u | to cut to the beginning of a line |
| ctrl+y | to paste already cut text |
| alt+b  | to skip one word backward |
| alt+f  | to skip one work forward |
| alt+d  | to delete until the end of the current word include the current character |
| ctrl+x+e | to edit the current command in default editor |
| alt+.  | to paste the last argument of the last command |
| alt+2  | to copy the 2nd argument of the last command |
| ctrl+_ | to redo |
| `reset` | to reset the current shell |
| `fc` | to edit the last command in the default editor |
| ctrl+r | to search commands in history

### Non-commands

###### to show the current process ID

```sh
echo $$
```

###### to repeat the last command

```sh
!!
```

###### to repeat the last command with sudo

```sh
sudo !!
```

### Commands

##### ls

###### to list directories with tailing slash

```sh
ls -F
```

###### to list directories in reverse chronological order

```sh
ls -tl
```

##### wc

###### count the number of lines in a file

```sh
wc -l ./package.json
```

##### find

###### to find files and directories with name

```sh
find . -name .git
```

###### to find directories with name

```sh
find . -name .git -type d
```

###### to find symlinks with name

```sh
find . -name .git -type l
```

###### to find files with the specified extension

```sh
find . -name '*.sass'
```

##### grep

###### To find files with a wording and a particular extension

```sh
grep search-term -r --include \*.{html,js} app/directory
```

###### To search for hidden files

```sh
grep search-term --exclude-dir=.. -r .*
```

###### To search and ignore binary files

```sh
grep search-term -I *
```

###### To get all lines except lines with the specified word

grep -v search-term text.txt

###### find BOM characters in files

```sh
grep -rl $'\xEF\xBB\xBF' .
```

##### sed and replacements

###### remove BOM characters in files

```sh
for f in $(grep $'\xEF\xBB\xBF' --include=\*.cs --include=\*.config --include=\*.js -rl .); do
	sed 's/\xEF\xBB\xBF//' "$f" > "$f".updated
	mv "$f".updated "$f"
done
```

###### replace words in a file

```sh
sed -i -e 's/IncorrectSpelling/CorrectSpelling/g' ./package.json
```

###### add multiple lines from a file after a specific pattern

```sh
sed -i -e "/some-pattern/r file.txt" working.txt
```

###### replace words in a bash variable

```sh
${f/\.txt/\.pdf}
```

##### uniq

###### find unique file prefixes

if the files are named like Day1.00202.jpg, Day2.02311.jpg, ...

```sh
ls | cut -d. -f1 | uniq
```

###### create directories with unique file prefixes

if the files are named like Day1.00202.jpg, Day2.02311.jpg, ...

```sh
mkdir $(ls | cut -d. -f1 | uniq)
```

###### to get only duplicate lines

```sh
cat some.txt | uniq -d
```

###### to get only unique lines

```sh
cat some.txt | uniq -u
```

###### to ignore case

```sh
cat some.txt | uniq -i
```

###### to get count as well

```sh
cat some.txt | uniq -c
```

##### sort

###### to sort files

```sh
ls | sort
```

###### to sort files and ignore cases

```sh
ls | sort -f
```

###### to sort files in reverse order

```sh
ls | sort -r
```

##### xargs

```sh
find /path -type f -print | xargs rm
```

and it is equivalent to `rm $(find /path -type f)`


###### command substitution

```sh
find /path -type f -name '*~' -print0 | xargs -0 -I % cp -a % ~/backups
```

##### awk

###### to extract delimited text

```sh
awk -F':' '{ print $1 }' /etc/passwd
```

###### to extract certain lines in a file

```sh
awk '$9 == 500 {print $0} ' /var/log/httpd/access.log
```

###### to find multiple words in a file

```sh
awk '/tom|jerry|vivek/' /etc/passwd
```

###### to do arithmetic

```sh
awk '{total += $1} END {print total}' earnings.txt
```

##### for and list

###### move prefixed files into its prefixed directories

```sh
for f in *(.); do d=${f%%.*}; mv $f $d/.; done
```

###### To loop through some of the files in current folder (where it is harder to use `find`)

```sh
for f in ./production.*; do echo $f; done
```

###### To loop through a bash array

```sh
colours=(red green blue)
for c in ${colours[*]}; do echo $c; done
```

###### To indirect reference an array in a loop

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

###### To make multiple directories

```sh
mkdir -p folder/{sub1,sub2}/temp
```

```sh
mkdir -p folder/{1..100}/temp
```

##### head & tail

###### To show the first few lines of an output

```sh
cat file.txt | head -n 10
```

###### To show the last few lines of an output

```sh
cat file.txt | tail -n 10
```

##### curl

###### To download a file from web and rename it

```sh
curl https://xyz.com/instructions.pdf -o guide.pdf
```

###### To download a file from web with a forward URL and rename it

```sh
curl -L https://xyz.com/install -o installer.deb
```

##### openssl 

###### To generate cert/keys for TLS access

```sh
openssl genrsa -out key.pem
openssl req -new -config gen.conf -key key.pem -out csr.pem
openssl x509 -req -days 9999 -in csr.pem -signkey key.pem -out cert.pem
rm csr.pem
cp cert.pem https_cert.pem
cat key.pem >> https_cert.pem
rm cert.pem key.pem
```

###### To generate SSL certs for Nginx

```sh
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout selfsigned.key -out selfsigned.crt
```

##### APT

###### To update installed APT packages

```sh
sudo apt-get update
sudo apt-get -u upgrade
```

###### To list installed packages

```sh
apt list --installed 
```

##### GPG

###### To list all GPG keys

```sh
gpg -K
```

```sh
gpg --list-secret-keys --keyid-format LONG
```

###### To export all GPG keys to a file

```sh
gpg --export-secret-keys -a > filename.asc
```

###### To export public key

```sh
gpg --armor --export the-key-id
```

###### To import GPG key(s) from a file

```sh
gpg --import filename.asc
```

###### To import GPG key(s) from another machine via SSH

```sh
ssh user_name@server_name gpg --export-secret-key KEY_ID | gpg --import
```

###### To generate a key

```sh
gpg --gen-key
```

and select "RSA and RSA", select 4096 as keysize, select "key does not expire",
    and enter email address for this key

##### cut

###### To have some parts of a line delimited) by a character

to have part 2 and 4 from a line delimited by a space

```sh
cat file.txt | cut -d ' ' -f 2,4
```

to have all parts except part 2 and 4 from a line delimited by a space

```sh
cat file.txt | cut --complement -d ' ' -f 2,4
```

###### To have all parts of a line after a number of characters

to have all parts of a line except the first 4 characters

```sh
cat file.txt | cut --complement -b 1-4
```

##### SSH

###### To generate a cert for accessing a remote server via SSH

where app-test.aws.com is the server to access. For Mac OSX, installation of ssh-copy-id may be required)

```sh
ssh-keygen -t rsa -b 2048 -f app-test -v
ssh-copy-id -i app-test.pub app@app-test.aws.com
mv app-test app-test.pem
chmod 400 app-test.pem
ssh -i app-test.pem app@app-test.aws.com
```

###### To pull a file from remote server

```sh
scp -i cert-to-server.pem app@app-test.aws.com:/server/path/file.txt local.txt
```

###### To disable password loging

Edit `/etc/ssh/sshd_config` and create or change the following entries with `no` va lues 

```
ChallengeResponseAuthentication no
PasswordAuthentication no
```

and reload sshd

```sh
sudo systemctl reload ssh
```

###### Tunneling

to map port 5601 from a remote machine to port 8080 of a local machine

```sh
ssh -L 8080:127.0.0.1:5601 username@remote-machine
```

to map port 5601 from a local machine to port 8080 of a remote machine

```sh
ssh -R 8080:127.0.0.1:5601 username@remote-machine
```

##### Versions

###### To check the distribution of linux

```sh
cat /etc/*release
```

###### To check linux kernel version

```sh
uname -a
```

##### VPN

###### Start VPN (IPsec)

```sh
sudo ipsec up office
echo "c office" | sudo tee /var/run/xl2tpd/l2tp-control
sudo route add office.example.com gw 192.168.1.1
sudo route add default dev ppp0
```

###### Stop VPN (IPsec)

```sh
sudo route del default dev ppp0
sudo route del office.example.com gw 192.168.1.1
echo "d office" | sudo tee /var/run/xl2tpd/l2tp-control
sudo ipsec down office
```

##### ip

###### To list IP addresses

```sh
ip addr show
```

###### To get IP from a host name

```sh
getent hosts alexhokl.com
```

###### To add an IP address to an interface

```sh
sudo ip addr add 192.168.123.123 dev eth1
```

Note that this does not override DHCP server and the IP might be lost once
after the interface is turned off.

###### To remove an IP address from an interface

```sh
sudo ip addr del 192.168.123.123/24 dev eth1
```

###### To enable a network interface

```sh
sudo ip link set eth1 up
```

###### To disable a network interface

```sh
sudo ip link set eth1 down
```

###### To check route table

```sh
ip route show
```

###### To add a temporary static route

```sh
sudo ip route add 10.10.20.0/24 via 192.168.123.123 dev eth1
```

###### To remove a static route temporarily

```sh
sudo ip route del 10.10.20.0/24
```

##### diff

###### To find the differences between two directories

```sh
diff --brief -r dir1/ dir2/
```

##### Tar

###### To extract to a directory

```sh
tar xf compressed.xz -C some-directory/
```

##### Encrypted drive

###### To mount an encrypted drive

```sh
lsblk
sudo cryptsetup luksOpen /dev/sda3 old_hdd
sudo vgdisplay --short
sudo lvs -o lv_name,lv_size -S vg_name=debian-iMac-vg
sudo lvchange -ay debian-iMac-vg/root
mkdir old-hdd
sudo mount /dev/debian-iMac-vg/root ~/old-hdd
```

###### To unmount an encrypted drive

```sh
sudo umount /dev/debian-iMac-vg/root
sudo lvchange -an debian-iMac-vg/root
sudo cryptsetup luksClose encrypted_device
```

##### tr

- `echo "Production" | tr '[:upper:] [:lower:]'` to transform `Production` to
    lowercase

##### Scripting

###### if

- `[ <condition> ]` is an old test where it works on all *-nix environment
- `[[ <condition> ]]` is a new test where it works only on modern Linux
    environment
- `==` EQUAL operator (in new test only)
- `&&` AND operator
- `||` OR operator
- `[ $# -lt 2 ]` checks if number of arguments is less than 2
- `[ "$str1" = "$str2" ]` checks if `str1` equals `str2`
- `[ "$str1" != "$str2" ]` checks if `str1` not equals `str2`
- `[ -n "$str" ]` checks if `str` is not empty
- `[ -z "$str" ]` checks if `str` is empty
- `[ $int1 -eq $int2 ]` checks if `int1` equals `int2`
- `elif` else-if

###### function

- `$2` refers to second argument of a function
- `for arg in "$@"; do echo "$arg"; done` echo out all arguments

##### Recipes 

###### To upgrade Debian from `jessie` to `stretch`

```sh
sudo apt update
sudo apt upgrade
sudo apt-get autoremove
sudo cp /etc/apt/source.list /etc/apt/source.list-jessie
(replace jessie with stretch in /etc/apt/source.list)
sudo apt update
sudo apt upgrade
sudo dist-upgrade
sudo apt-get autoremove
reboot
```

###### To change CRLF (Windows) line-endings to LF (Unix)

On Mac,

```sh
find ./ -type f -exec perl -pi -e 's/\r\n|\n|\r/\n/g' {} \;
```

Or on linux,

```sh
find . -type f -exec grep -qIP '\r\n' {} ';' -exec perl -pi -e 's/\r\n/\n/g' {} '+'
```

###### To convert a PNG file to an ICO file

```sh
convert -background transparent image.png -define icon:auto-resize=16,32,48,64,256 favicon.ico
```

###### To convert a AVI file to MPEG-4 file

```sh
ffmpeg -i video.avi -b 100k video.mp4
```

###### To convert an image to webp format

```sh
cwebp -q 80 source.image.png -o destination.webp
```

###### To set timezone

```sh
sudo unlink /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
```

###### To check kernel debug messages

```sh
sudo dmesg -H
```

###### To reload Nginx in a container

```sh
nginx -s reload
```

###### To uninstall homebrew

```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

###### To kill a process running on a particular port

```sh
kill $(lsof -ti tcp:3000)
```

###### To keep all processes running after exiting the current terminal

```sh
disown -a && exit
```

###### To umount an USB drive and dump ISO image to it (on Mac)

```sh
diskutil list
diskutil unmountDisk /dev/disk2
sudo dd if=/path/to/abc.iso of=/dev/disk2 bs=1m
diskutil eject /dev/disk2
```

###### To mount a USB drive on linux

```sh
lsblk
sudo mount /dev/sdc1 /home/current-user/usb
```

###### To umount a USB drive on linux

```sh
sudo umount /home/current-user/usb
```

###### To mount a NTFS Windows drive on linux

```sh
lsblk
sudo mount -t ntfs-3g /dev/sdc1 /home/current-user/hdd
```

###### To change partitions of a disk

```sh
sudo fdisk /dev/sdX
```

###### To format a partition in ext4 format

```sh
sudo mkfs.ext4 /dev/sdXx
```

###### To make indirect reference to another variable

```sh
sites=$(eval "echo \$${DEPLOYMENT_TYPE}_sites")
```

###### to check disk usage in the current directory

```sh
du -sh
```

###### to check disk usage of directories of the current path

```sh
du --max-depth=1 -h
```

###### To check available memory

```sh
free -h
```

###### current running processes memory usage

```sh
top
```

###### To list most of the current network ports (or sockets)

```sh
sudo netstat -tupln
```

###### to modify PATH

```sh
echo ${PATH} > t1
vi t1
export PATH=$(cat t1)
```

