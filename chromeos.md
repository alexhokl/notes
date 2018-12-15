### Links

- [Auto Update Policy](https://support.google.com/chrome/a/answer/6220366?hl=en)
- [Chrome Releases](https://chromereleases.googleblog.com/)

### Shortcut keys

##### To take a full screenshot

`Shift` + multiscreen key

##### To take a partial screenshot

`Shift` + `Ctrl` + multiscreen key

### Networking

##### To configure PPTP VPN

1. Open "Settings"
2. Search for "Google Play Store"
3. Click on "Manage Android Preferences"
4. Click on "PPTP VPN" and enter the required information to setup

See "PPTP VPN support" in [Set up virtual private networks (VPNs)](https://support.google.com/chromebook/answer/1282338?hl=en)

### Linux-related topics

##### crosh Colour scheme

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

##### crouton

- shared directories are defined in `/etc/crouton/shares`
  - Syntax is as `HOSTDIR CHROOTDIR [OPTIONS]`

##### crostini

- [crostini 101](https://www.reddit.com/r/Crostini/comments/89q1cu/crostini_101/)
- [Running Custom Containers Under Chrome OS](https://chromium.googlesource.com/chromiumos/docs/+/master/containers_and_vms.md)
- To have Linux OS on, change to use Dev Channel. To do this, head to "About
    Chrome OS" page and select "Detailed build information", then click on
    "Change Channel" and select Dev Channel.
  - Note that switching on flag `Experimental Crostini` in `chrome://flags` may
      be required

###### Components

- the virtual machine is `crosvm` which implements `kvm` and it is in Rust
- VM managers `concierge` and `cicerone`
- `concierge` kickstarts a VM and setup its network and peripherals. It is running in privileged mode
- `cicerone` takes over the communication to VM and it is very stripped down version of `concierge` and it is not running in privileged mode. A started VM is not considered as trusted anymore by ChromeOS
- `termina` is the VM root image and it is used to boot a container via `lxd`
- `maitred` is the PID 1 process which behaves like `systemd`
- `lxd` is a container type and has advantages over docker in terms of a bigger container
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

###### Docker

In `crosh` shell,

```sh
vmc stop termina
vmc start termina
lxc profile unset default security.syscalls.blacklist
lxc profile apply penguin default
lxc restart penguin
```

Open a `Terminal` window and execute,

```sh
sudo dockerd
```

Open another `Terminal` window to use Docker as normal.

Reference: [Reddit: 70.0.3524.2 rolling out to Dev](https://www.reddit.com/r/Crostini/comments/99jdeh/70035242_rolling_out_to_dev/e4revli/)

### Chrome Browser

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


