### To list the existing ports for display and available resolutions

```sh
xrandr
```

### To list all the monitors

```sh
xrandr --listmonitors
```

### To extend to another display (rather than mirroring)

```sh
xrandr --output DP-1 --mode 3840x2160 --right-of eDP-1
```

### To reset virtual desktops after unplugging

```sh
xrandr --auto
```

### To explicitly turn off a monitor

```sh
xrandr --output DP-1 --off
```

### To mirror displays

Assuming the parent display is `eDP-1`,

```sh
xrandr --output DP-1 --same-as eDP-1
```
