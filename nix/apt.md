###### To update installed APT packages

```sh
sudo apt-get update
sudo apt-get -u upgrade
```

###### To list installed packages

```sh
apt list --installed 
```

##### To list available packages

```sh
apt list
```

Note that this represents a list after updates from different repositories.
That is, after `apt update`.

##### To fix any broken installations

```sh
apt install --fix-broken -y
```

##### To list keys used by APT

```sh
apt-key list
```

##### To add key to be used by APT from key server

```sh
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 3653E21064B19D134466702E43D5C49532CBA1A9
```

##### To remove a package

```sh
apt remove atom
```

