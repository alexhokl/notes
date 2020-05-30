- [Key generation](#key-generation)
- [File transfer](#file-transfer)
- [Configuration](#configuration)
- [Tunneling](#tunneling)
____

### Key generation

###### To generate a cert for accessing a remote server via SSH

where app-test.aws.com is the server to access. For Mac OSX, installation of ssh-copy-id may be required)

```sh
ssh-keygen -t rsa -b 4096 -f app-test -v
ssh-copy-id -i app-test.pub app@app-test.aws.com
mv app-test app-test.pem
chmod 400 app-test.pem
ssh -i app-test.pem app@app-test.aws.com
```

### File transfer

###### To pull a file from remote server

```sh
scp -i cert-to-server.pem app@app-test.aws.com:/server/path/file.txt local.txt
```

###### To pull files recursively from remote server

```sh
scp -i cert-to-server.pem -r app@app-test.aws.com:/server/path/ ./destination-path
```

### Configuration

###### To disable password loging

Edit `/etc/ssh/sshd_config` and create or change the following entries with `no` va lues

```
ChallengeResponseAuthentication no
PasswordAuthentication no
```

and reload sshd

```sh
sudo systemctl reload ssh
```

### Tunneling

to map port 5601 from a remote machine to port 8080 of a local machine

```sh
ssh -L 8080:127.0.0.1:5601 username@remote-machine
```

to map port 5601 from a remote machine to port 8080 of a local machine and
without executing any commands

```sh
ssh -LN 8080:127.0.0.1:5601 username@remote-machine
```

to map port 5601 from a local machine to port 8080 of a remote machine

```sh
ssh -R 8080:127.0.0.1:5601 username@remote-machine
```
