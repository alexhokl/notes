- [Commands](#commands)
____

- This allows a linux machine to connect to a Windows machine using Remote
  Desktop (RDP)

## Commands

##### To connect with a RDP file

```sh
xfreerdp machine_name.rdp /p:$PASSWORD
```

##### To connect with full screen

```sh
xfreerdp machine_name.rdp /p:$PASSWORD /f
```

##### To connect with a specified screen size

```sh
xfreerdp machine_name.rdp /p:$PASSWORD /w:1920 /h:1080
```

##### To connect with directory mount

```sh
xfreerdp machine_name.rdp /p:$PASSWORD /drive:mount_name,/home/user/Downloads
```

where `mount_name` is the name appear on Windows and `/home/user/Downloads` is
the path on Linux.
