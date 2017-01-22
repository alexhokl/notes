see [GOTO 2013 • Power Use of UNIX • Dan North](https://www.youtube.com/watch?v=7uwW20odwEk)

to show the current process ID
```sh
echo $$
```

to list directories with tailing slash
```sh
ls -F
```

to list directories in reverse chronological order
```sh
ls -tl
```

to find files and directories with name
```sh
find . -name .git
```

to find directories with name
```sh
find . -name .git -type d
```

to find symlinks with name
```sh
find . -name .git -type l
```

to find files with the specified extension
```sh
find . -name '*.sass'
```

count the number of lines in a file
```sh
wc -l ./package.json
```

replace words in a file
```sh
sed 's/IncorrectSpelling/CorrectSpelling/g' ./package.json
```

find unique file prefixes (if the files are named like Day1.00202.jpg, Day2.02311.jpg, ...)
```sh
ls | cut -d. -f1 | uniq
```

create directories with unique file prefixes (if the files are named like Day1.00202.jpg, Day2.02311.jpg, ...)
```sh
mkdir $(ls | cut -d. -f1 | uniq)
```

move prefixed files into its prefixed directories
```sh
for f in *(.); do d=${f%%.*}; mv $f $d/.; done
```

to check disk usage in the current directory
```sh
du -sh
```

to check disk usage of directories of the current path
```sh
du --max-depth=1 -h
```

current running processes memory usage
```sh
top
```

to modify PATH
```sh
echo ${PATH} > t1
vi t1
export PATH=$(cat t1)
```

to copy output to clipboard
```sh
git status | pbcopy
```

to find text in clipboard
```sh
pbpaste | grep git
```

To download a file from web and rename it
```sh
curl https://xyz.com/instructions.pdf -o guide.pdf
```

To kill a process running on a particular port
```sh
kill $(lsof -ti tcp:3000)
```

To umount an USB drive and dump ISO image to it (on Mac)
```sh
diskutil list
diskutil unmountDisk /dev/disk2
sudo dd if=/path/to/abc.iso of=/dev/disk2 bs=1m
diskutil eject /dev/disk2
```

To uninstall homebrew
```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

to generate cert/keys for TLS access
```sh
openssl genrsa -out key.pem
openssl req -new -config gen.conf -key key.pem -out csr.pem
openssl x509 -req -days 9999 -in csr.pem -signkey key.pem -out cert.pem
rm csr.pem
cp cert.pem https_cert.pem
cat key.pem >> https_cert.pem
rm cert.pem key.pem
```

