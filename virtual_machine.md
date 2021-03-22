##### To start virtualization interactive terminal

```sh
virsh
```

which is equivalent to

```sh
virsh --connect qemu:///user
```

Since, in most use cases, a virtual machine will requires root privileges and,
thus, be installed in system namespace. Thus, we can use

```sh
virsh --connect qemu:///system
```

To avoid using `--conect` option everytime, we setup
`~/.config/libvirt/libvirt.conf` by

```sh
mkdir -p ~/.config/libvirt && \
sudo cp -rv /etc/libvirt/libvirt.conf ~/.config/libvirt/ && \
sudo chown ${USER}:${USER} ~/.config/libvirt/libvirt.conf
```

Open `~/.config/libvirt/libvirt.conf` and set `uri_default` to `qemu:///system`.

##### To list all virtual machines (domains)

```sh
virsh list --all
```

##### To create a Windows 10 virtual machine (domain)

```sh
virt-install \
  --name=windows10 \
  --ram=8192 \
  --cpu=host \
  --vcpus=4 \
  --os-type=windows \
  --disk path=/var/lib/libvirt/images/windows10.qcow2,size=80 \
  --cdrom $HOME/Downloads/Win10_20H2_English_x64.iso \
  --cdrom $HOME/Downloads/virtio-win-0.1.185.iso \
  --network network=default \
  --graphics spice
```

[Instructions on downloading virtio
drivers](https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md)

##### To get information of host machine

```sh
virsh nodeinfo
```

##### To get information of a virtual machine (domain)

```sh
virsh dominfo windows10
```

##### To start a virtual machine (domain)

```sh
virsh start windows10
```

##### To gracefully shutdown a virtual machine (domain)

```sh
virsh shutdown windows10
```

##### To force shutdown a virtual machine (domain)

```sh
virsh destroy windows10
```

##### To restart a virtual machine (domain)

```sh
virsh reboot windows10
```

##### To suspend a virtual machine (domain)

```sh
virsh suspend windows10
```

##### To resume a suspended a virtual machine (domain)

```sh
virsh resume windows10
```

##### To set CPU of a virtual machine (domain)

```sh
virsh setvcpus windows10 --maximum 4 --config
virsh setvcpus windows10 --count 4 --config
```

##### To set memory of a virtual machine (domain)

```sh
virsh setmaxmem windows10 8G --config
virsh setmem windows10 8G --config
```

##### To list disks of a virtual machine (domain)

```sh
virsh domblklist windows10
```

##### To attach an ISO file to a virtual machine (domain)

```sh
virsh attach-disk windows10 ~/Downloads/virtio-win-0.1.185.iso hdc --type cdrom --config
```

##### To detach a disk from a virtual machine (domain)

```sh
virsh detach-disk windows10 $HOME/Downloads/virtio-win-0.1.185.iso --config
```

##### To list network interfaces of a virtual machine (domain)

```sh
virsh dombiflist windows10
```

##### To delete a virtual machine (domain)

```sh
virsh undefine windows10
sudo rm /var/lib/libvirt/images/windows10.qcow2
```
