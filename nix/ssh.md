- [Key generation](#key-generation)
- [Key management](#key-management)
- [File transfer](#file-transfer)
- [Configuration](#configuration)
- [Tunneling](#tunneling)
- [Agent forwarding](#agent-forwarding)
____

### Key generation

###### To generate a cert for accessing a remote server via SSH

Assuming `app-test.aws.com` is the remote server to be accessed.

```sh
SSH_KEY_NAME=app-test
ssh-keygen -t ed25519 -C $SSH_KEY_NAME -f $HOME/.ssh/$SSH_KEY_NAME
ssh-copy-id -i $SSH_KEY_NAME.pub app@app-test.aws.com
ssh -i $HOME/.ssh/$SSH_KEY_NAME app@app-test.aws.com
```

For Mac OSX, installation of `ssh-copy-id` may be required.

If `ssh-copy-id` is not available or password authentication is disabled on the
remote server, one can always copy the content of the public key generated and
append it to `$HOME/.ssh/authorized_keys` on the remote server. On public cloud,
usually there is a web UI to add these public SSH keys.

### Key management

##### To list public keys in the currently inserted Yubikeys

```sh
ssh-add -L
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

### Agent forwarding

#### SSH agent

```sh
ssh -A remote-machine
```

or, adding the following to `$HOME/.ssh/config`

```apacheconf
ForwardAgent yes
```

#### GPG agent

On the remote server, add the following line to `/etc/ssh/sshd_config`.

```apacheconf
StreamLocalBindUnlink yes
```

Check the handle of the agent on remote server by

```sh
gpgconf --list-dirs agent-socket
```

The output would be something like

```sh
/run/user/1000/gnupg/S.gpg-agent
```

On the client, check the extra agent by

```sh
gpgconf --list-dirs agent-extra-socket
```

The output would be something like

```sh
/run/user/1000/gnupg/S.gpg-agent.extra
```

On the client, add the following lines to `$HOME/.ssh/config`

```apacheconf
RemoteForward /run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent.extra
StreamLocalBindUnlink yes
```

If the forwarding is success, a line similar to the following should be shown.

```
gpg-connect-agent: connection to agent is in restricted mode
```

Note that one should copy its public keyring from the client to the remote
server or pull from a PKI.

```sh
scp ~/.gnupg/pubring.kbx remote:~/.gnupg/
```
