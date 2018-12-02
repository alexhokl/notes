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

##### Monitoring events on an element

```js
monitorEvents($0);
```
