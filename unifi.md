- [Links](#links)
- [Recipes](#recipes)
  * [USG](#usg)
  * [To adopt a pending-adopt/un-provisioned device](#to-adopt-a-pending-adoptun-provisioned-device)
  * [To SSH into an adopted (or a provisioned) device](#to-ssh-into-an-adopted-or-a-provisioned-device)
  * [To check information of a device](#to-check-information-of-a-device)
  * [To change IP of controller in an adopted device](#to-change-ip-of-controller-in-an-adopted-device)
  * [To fix adoption loop of a device](#to-fix-adoption-loop-of-a-device)
____
## Links

- [UniFi - Troubleshooting Device Adoption
  Failures](https://help.ubnt.com/hc/en-us/articles/204950304-UniFi-Troubleshooting-Device-Adoption-Failuresb)

## Recipes

Assuming the following IP addresses are used.

- USG on `192.168.200.1`
- Unifi Controller on `192.168.200.2`
- Unifi device on `192.168.200.3`

### USG

By default, the USG will take over `192.168.1.1`. To use another subnet, see
instructions of [Change the USG LAN IP Before Adoption](https://help.ubnt.com/hc/en-us/articles/236281367-UniFi-USG-How-to-Adopt-a-USG-into-an-Existing-Network#4).

### To adopt a pending-adopt/un-provisioned device

```sh
ssh ubnt@192.168.200.3
set-inform http://192.168.200.2:8080/inform
```

Note that the SSH password is `ubnt`.

### To SSH into an adopted (or a provisioned) device

```sh
ssh admin@192.168.200.3
```

Note that the password has been set upon initialization of Unifi Controller.

### To check information of a device

```sh
ssh admin@192.168.200.3
info
```

### To change IP of controller in an adopted device

```sh
ssh admin@192.168.200.3
set-inform http://192.168.200.2:8080/inform
```

### To fix adoption loop of a device

1. Log onto Unifi Controller.
2. In device section, remove the device in question. If it could not be removed
   as the device is busy, try to un-plug the device and remove the device in
   the UI of controller again.
3. Hardware reset the device by inserting a pin into the device until the blue
   light turns off.
4. Wait for the device to boot up. Once the device has constant white light on,
   the device is ready to be adopted.
5. To adopt the device, one can do it via UI of controller or SSH into the
   device using account `ubnt` and execute
   `set-inform http://192.168.200.2:8080/inform`
