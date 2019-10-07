###### To list IP addresses

```sh
ip addr show
```

or, `ip a` or `ip addr`.

###### To get IP from a host name

```sh
getent hosts alexhokl.com
```

###### To add an IP address to an interface

```sh
sudo ip addr add 192.168.123.123 dev eth1
```

Note that this does not override DHCP server and the IP might be lost once
after the interface is turned off.

###### To remove an IP address from an interface

```sh
sudo ip addr del 192.168.123.123/24 dev eth1
```

###### To enable a network interface

```sh
sudo ip link set eth1 up
```

###### To disable a network interface

```sh
sudo ip link set eth1 down
```

###### To check route table

```sh
ip route show
```

or,

```sh
route
```

###### To add a temporary static route

```sh
sudo ip route add 10.10.20.0/24 via 192.168.123.123 dev eth1
```

###### To remove a static route temporarily

```sh
sudo ip route del 10.10.20.0/24
```

##### To direct all traffic to an interface

```sh
route add default dev ppp0
```

and, to remove such a rule

```sh
route del default dev ppp0
```
