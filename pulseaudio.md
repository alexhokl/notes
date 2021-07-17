##### To list all devices (and profiles)

```sh
pacmd list-cards
```

##### To retrieve the active profile

```sh
pacmd list-cards | grep "active profile"
```

##### To set profile

```sh
pactl set-card-profile 0 output:hdmi-stereo
```

To set the profile permanently, add the following line to
`/etc/pulse/default.pa`.

```sh
set-card-profile 0 output:hdmi-stereo
```
