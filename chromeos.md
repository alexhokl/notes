- [Links](#links)
- [Shortcut keys](#shortcut-keys)
- [SSH](#ssh)
- [Networking](#networking)
- [Linux-related topics](#linux-related-topics)
  * [crosh Colour scheme](#crosh-colour-scheme)
  * [crosh](#crosh)
  * [crouton](#crouton)
  * [crostini](#crostini)
    + [Timezone](#timezone)
    + [Components](#components)
    + [pinentry](#pinentry)
- [Chrome Browser](#chrome-browser)
  * [Bookmarks](#bookmarks)
  * [Recipies](#recipies)
____

# Links

- [Auto Update Policy](https://support.google.com/chrome/a/answer/6220366?hl=en)
- [Chrome Releases](https://chromereleases.googleblog.com/)
- [Matrix of chrome versions and machines](https://cros-updates-serving.appspot.com/)
- [Pixelbook keyboard shortcuts](https://support.google.com/pixelbook/answer/7503852?hl=en)
- [ChromeOS Containers do not respect "ARC VPN integration"](https://bugs.chromium.org/p/chromium/issues/detail?id=834585)
- [Blog on ChromeOS by Keith I Myers](https://kmyers.me/knowledge/chromeos/)

# Shortcut keys

| keys | function |
| --- | --- |
| <kbd>ctrl</kbd><kbd>alt</kbd><kbd>shift</kbd><kbd>?</kbd> | to show all shortcut keys |
| <kbd>shift</kbd> + multiscreen key (<kbd>F5</kbd>) | to take a full screenshot |
| <kbd>ctrl</kbd><kbd>shift</kbd> + multiscreen key (<kbd>F5</kbd>) | to take a partial screenshot |
| <kbd>search</kbd>+<kbd>l</kbd> | lock screen |
| <kbd>alt</kbd><kbd>=</kbd> | toggle between maximised window and normal size window |
| <kbd>alt</kbd><kbd>[</kbd> | dock the current window to left |
| <kbd>alt</kbd><kbd>]</kbd> | dock the current window to right |
| <kbd>ctrl</kbd><kbd>alt</kbd><kbd>.</kbd> | switch user |

# SSH

Install [Secure Shell
App](https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo?hl=en)
and [Smart Card
Connector](https://chrome.google.com/webstore/detail/smart-card-connector/khpfeaanjngmcnplbdlpegiifgpfgdco?hl=en).

To use YubiKey, in "SSH relay server options", enter `--ssh-agent=gsc`.

# Networking

##### To configure PPTP VPN

1. Open "Settings"
2. Search for "Google Play Store"
3. Click on "Manage Android Preferences"
4. Click on "PPTP VPN" and enter the required information to setup

See "PPTP VPN support" in [Set up virtual private networks (VPNs)](https://support.google.com/chromebook/answer/1282338?hl=en)

# Linux-related topics

## crosh Colour scheme

```
[
  "#073642",
  "#dc322f",
  "#859900",
  "#b58900",
  "#268bd2",
  "#d33682",
  "#2aa198",
  "#eee8d5",
  "#002b36",
  "#cb4b16",
  "#586e75",
  "#657b83",
  "#839496",
  "#6c71c4",
  "#93a1a1",
  "#fdf6e3"
]
```

and background colour in `#002b36`

## crosh

#### Current battery status

```sh
battery_test 0
```

#### Batter info

```sh
battery_firmware info
```

#### listing virtual machines

```sh
vmc list
```

#### log onto container inside a VM (termina)

```sh
vmc container termina penguin
```


#### starting a VM (termina) and log onto it (not container)

```sh
vmc start termina
```

#### listing containers in VM

```sh
lxc list
```

#### create a container snapshot in VM

```sh
lxc snapshot penguin backup1
```

#### show information of a container in VM

```sh
lxc info penguin
```

#### restore a container snapshot in VM

```sh
lxc restore penguin backup1
```

#### create a new container from an existing one in VM

```sh
lxc copy penguin penguin_new
```

#### log onto another container in a VM

```sh
lxc exec penguin_new -- /bin/bash
```

#### create a new container from image in a VM

```sh
lxc launch images:archlinux archtest
```

## crouton

- shared directories are defined in `/etc/crouton/shares`
  - Syntax is as `HOSTDIR CHROOTDIR [OPTIONS]`

## crostini

- [Running Custom Containers Under Chrome OS](https://chromium.googlesource.com/chromiumos/docs/+/master/containers_and_vms.md)
- [Crostini: A Linux Desktop on ChromeOS](https://www.youtube.com/watch?v=_k6zdvM9rUA)
- `penguin.linux.test` is the DNS name of the container

### Timezone

##### To set timezone

```sh
sudo dpkg-reconfigure tzdata
```

Unfortunately, the trick of `lxc profile set default environment.TZ Asia/Hong_Kong`
    does not work yet.

### Components

- the virtual machine is `crosvm` which implements `kvm` and it is in Rust
- VM managers `concierge` and `cicerone`
- `concierge` kickstarts a VM and setup its network and peripherals. It is
    running in privileged mode
- `cicerone` takes over the communication to VM and it is very stripped down
    version of `concierge` and it is not running in privileged mode. A started
    VM is not considered as trusted anymore by Chrome OS
- `termina` is the VM root image and it is used to boot a container via `lxd`
- `maitred` is the PID 1 process which behaves like `systemd`
- `lxd` is a container type and has advantages over docker in terms of a bigger
    container
- gtk and QT drivers are modified to fit `virtio-wayland` on ChromeOS
- `sommelier` is a Wayland composer running inside guest container
  - each container would have its own instance of `sommelier` and, thus, the
      instances are nested
  - there is a master instance of `sommelier` where it is responsible to create
      new instances for new containers and to communicate between `sommelier`
      in container to `virtio-wayland` on host
- no X11 server is running due to security concerns
  - XWayland is running on each container instead but it is not a 100% X11
      replacement
- `garcon` as launcher integration and it talks to `cicerone` and talks to the
    actual application

See also [NYLUG Presents: David Reveman/Zach Reizner -on- Crostini: Linux applications on Chrome OS](https://www.youtube.com/watch?v=WwrXqDERFm8)

### pinentry

Crostini (Debian) default to use `pinentry-cruses` and it may not work well with
`gpg-agent` remotely. The workaround it to use `pinentry-qt`.

```sh
sudo apt install -y pinentry-qt
sudo update-alternatives --install /usr/bin/pinentry pinentry "$(which pinentry-qt)" 10
sudo update-alternatives --install /usr/bin/pinentry-x11 pinentry-x11 "$(which pinentry-qt)" 10
```

# Chrome Browser

## Bookmarks

On Mac, bookmarks are stored in

```sh
$HOME/Library/Application Support/Google/Chrome/Default/Bookmarks
```

Dumping of URLs can be made by

```sh
cat $HOME/Library/Application Support/Google/Chrome/Default/Bookmarks |\
  jq '.roots.bookmark_bar.children[] | select(.name=="To Read") | .children[] | { title:.name, url:.url}'
```

assuming the bookmarks are in folder `To Read` in `Bookmarks Bar`

## Recipies

##### To Enable blackboxing

- Open "Network" tab in developer console
- Ensure column `Initiator` is visible
- Hover over the initiator of the request in question
- Right click on the script file that you want to blackbox (hide) and click on
    "Blackbox script"
  - Blackboxing can also be applied in call stack

##### Live expression

- Open "Console" tab in develop console
- Click on the eye-like icon and enter the expression


##### Storing DOM element as a variable

Since Chrome 71, right click on the element tag (after clicking on "Inspect")
and select "Store as global variable. Take note of the temporary variable name
and that variable is available in the console.

##### Monitoring events on an element

```js
monitorEvents($0);
```


