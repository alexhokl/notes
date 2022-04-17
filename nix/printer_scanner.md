- [Device](#device)
- [Scanning](#scanning)
- [Printing](#printing)
____

# Device

##### Default passwords

| Name              | Value   |
| ---               | ---     |
| System Manager ID | 7654321 |
| Password          | 7654321 |

# Scanning

##### To list scanners

```sh
scanimage -L
```

##### To scan an image

```sh
scanimage --format=png --output-file test.png --device "airscan:w0:device name above" --progress
```

# Printing
