- [iTerm2](#iterm2)
- [homebrew](#homebrew)
____

### iTerm2

[Cheatsheet](https://gist.github.com/helger/3070258)

##### To umount an USB drive and dump ISO image to it (on Mac)

```sh
sh diskutil list diskutil unmountDisk /dev/disk2 sudo dd if=/path/to/abc.iso of=/dev/disk2 bs=1m diskutil eject /dev/disk2
```

### homebrew

##### To uninstall

```sh
sh ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

