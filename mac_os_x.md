
____

##### Creating installation media

```sh
sudo /Applications/Install\ macOS\ High\ Sierra.app/Contents/Resources/createinstallmedia --volume /Volumes/Name --applicationpath /Applications/Install\ macOS\ High\ Sierra.app
```

To boot up from an external drive, press `options` key upon starting a machine. See also [How to create a bootable installer for macOS](https://support.apple.com/en-hk/HT201372).

In case the machine shows `No bootable device`, try to clean the BIOS (NVRAM) by holding keys `cmd` + `alt` + `P` + `R`. See [How to Reset NVRAM on your Mac](https://support.apple.com/en-hk/HT204063) for more information.

##### iTerm2

[Cheatsheet](https://gist.github.com/helger/3070258)

##### To umount an USB drive and dump ISO image to it (on Mac)

```sh
diskutil list
diskutil unmountDisk /dev/disk2
sudo dd if=/path/to/abc.iso of=/dev/disk2 bs=1m
diskutil eject /dev/disk2
```

##### To uninstall homebrew

```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

