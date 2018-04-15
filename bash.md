see [GOTO 2013 • Power Use of UNIX • Dan North](https://www.youtube.com/watch?v=7uwW20odwEk)

###### to show the current process ID

```sh
echo $$
```

###### to list directories with tailing slash

```sh
ls -F
```

###### to list directories in reverse chronological order

```sh
ls -tl
```

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

###### count the number of lines in a file

```sh
wc -l ./package.json
```

###### To find files with a wording and a particular extension

```sh
grep search-term -r --include \*.{html,js} app/directory
```

###### To search for hidden files

```sh
grep search-term --exclude-dir=.. -r .*
```

###### find BOM characters in files

```sh
grep -rl $'\xEF\xBB\xBF' .
```

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

###### find unique file prefixes (if the files are named like Day1.00202.jpg, Day2.02311.jpg, ...)

```sh
ls | cut -d. -f1 | uniq
```

###### create directories with unique file prefixes (if the files are named like Day1.00202.jpg, Day2.02311.jpg, ...)

```sh
mkdir $(ls | cut -d. -f1 | uniq)
```

###### move prefixed files into its prefixed directories

```sh
for f in *(.); do d=${f%%.*}; mv $f $d/.; done
```

###### to check disk usage in the current directory

```sh
du -sh
```

###### to check disk usage of directories of the current path

```sh
du --max-depth=1 -h
```

###### current running processes memory usage

```sh
top
```

###### To list IP addresses

```sh
ip addr show
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

###### to copy output to clipboard

```sh
git status | pbcopy
```

###### to find text in clipboard

```sh
pbpaste | grep git
```

###### To download a file from web and rename it

```sh
curl https://xyz.com/instructions.pdf -o guide.pdf
```

###### To download a file from web with a forward URL and rename it

```sh
curl -L https://xyz.com/install -o installer.deb
```

###### To kill a process running on a particular port

```sh
kill $(lsof -ti tcp:3000)
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

###### To uninstall homebrew

```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

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

###### To update installed APT packages

```sh
sudo apt-get update
sudo apt-get -u upgrade
```

###### To list all GPG keys

```sh
gpg2 -K
```

###### To export all GPG keys to a file

```sh
gpg2 --export-secret-keys -a > filename.asc
```

###### To import GPG key(s) from a file

```sh
gpg2 --import filename.asc
```

###### To import GPG key(s) from another machine via SSH

```sh
ssh user_name@server_name gpg2 --export-secret-key KEY_ID | gpg2 --import
```

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
