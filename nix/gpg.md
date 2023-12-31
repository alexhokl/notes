- [Key servers](#key-servers)
- [Commands](#commands)
  * [Key management](#key-management)
  * [Operations](#operations)
  * [Configuration](#configuration)
- [Yubikey](#yubikey)
    + [Links](#links)
    + [PINs](#pins)
    + [Master key](#master-key)
    + [Key management](#key-management-1)
    + [GPG Agent Forwarding](#gpg-agent-forwarding)
____

# Key servers

- [keys.openpgp.org](https://keys.openpgp.org/)
- [pgp.mit.edu](https://pgp.mit.edu/)

# Commands

## Key management

##### To list all public keys

```sh
gpg -k
```

##### To list all private keys

```sh
gpg -K
```

##### To list all key IDs

```sh
gpg -K --keyid-format LONG | grep sec | awk '{ print $2 }' | awk -F '/' '{ print $2 }'
```

##### To export private key

```sh
gpg --export-secret-keys -a $KEYID
```

`-a` to ascii-armored the key


##### To export sub keys

```sh
gpg --export-secret-subkeys -a $KEYID
```

##### To export public key

```sh
gpg --export -a $KEYID
```

##### To import GPG key(s) from a file

```sh
gpg --import filename.asc
```

##### To import GPG key(s) from another machine via SSH

```sh
ssh user_name@server_name gpg --export-secret-key $KEYID | gpg --import
```

##### To import a public key from key server

```sh
gpg --keyserver hkps://pgp.mit.edu --recv-keys $KEYID
```

or, from default set of servers

```sh
gpg --recv $KEYID
```

or, using email address

```sh
gpg --keyserver hkps://keys.openpgp.org --locate-keys user@example.com
```

##### To upload a (public) key to key server

```sh
gpg --keyserver pgp.mit.edu --send-key $KEYID
```

##### To generate a key

```sh
gpg --gen-key
```

and select "RSA and RSA", select 4096 as keysize, select "key does not expire",
    and enter email address for this key

or, to generate a full featured key

```sh
gpg --full-generate-key
```

##### To edit a key

```sh
gpg --edit-key $KEYID
```

##### To change password of a key

```sh
gpg --edit-key $KEYID passwd
```

Note that master key and its subkeys shares the same passphrase (password).

##### To delete a public key

```sh
gpg --delete-keys $KEYID
```

##### To delete a secret key

```sh
gpg --delete-secret-keys $KEYID
```

##### To list properties of a key

```sh
gpg -a --export $KEYID | gpg --list-packets
```

## Operations

##### To sign a file

```sh
gpg -s something.txt
```

and a signature will be generated as file `something.txt.gpg`

##### To verify a signature

```sh
gpg --verify something.txt.gpg
```

or, if the content and signature are detached,

```sh
gpg --verify signature.asc content.txt
```

##### To encrypt with symmetric cipher and passphrase

```sh
gpg -c something.txt
```

##### To encrypt with one of the store public keys

```sh
gpg -e something.txt
```

Enter the email address of the recipients upon being asked for `uid`

or, with specified recipient

```sh
gpg -r user@test.com -e something.txt
```

##### To decrypt

```sh
gpg -o something.txt --decrypt something.txt.gpg
```

## Configuration

##### To find the configuration directory

```sh
gpgconf --list-dirs homedir
```

and it should return something like `$HOME/.gnupg`.

# Yubikey

### Links

- [drduh/Yubikey-Guide](https://github.com/drduh/YubiKey-Guide)
- [Compatible devices / Troubleshooting Issues with
  GPG](https://support.yubico.com/hc/en-us/articles/360013714479-Troubleshooting-Issues-with-GPG)

### PINs

The GPG interface is separate from other modules on a Yubikey such as the PIV
interface. The GPG interface has its own PIN, Admin PIN, and Reset Code.

Unblocking PIN, changing reset code, changing admin PIN should be available with
the following steps.

```sh
> gpg --card-edit
> admin
> passwd
```

Reference: [Change PIN in
drduh/Yubikey-Guide](https://github.com/drduh/YubiKey-Guide?tab=readme-ov-file#change-pin)

### Master key

Master key should be kept offline at all times and only accessed to revoke or
issue new subkeys.

Note that, once GPG keys are moved to a YubiKey, it cannot be moved again.

### Key management

Subkeys are generated on a per-Yubikey-basis.  Usually a Yubikey is paired with
a machine to minimise the effort in managing the keygrips. Thus, if there are
3 Yubikeys to be setup, 3 set of subkeys (9 keys; signing, encryption and
authentication for each set) will be generated.

To add subkeys, we can start by editing an existing master key (with its
existing subkeys) after importing it from a offline storage.

```sh
gpg --expert --edit-key $KEYID
```

Once all sets of new [subkeys](https://github.com/drduh/YubiKey-Guide#sub-keys)
are generated, the [master key](./gpg.md#to-export-private-key),
[subkeys](./gpg.md#to-export-sub-keys) and public key should be exported.

```sh
gpg --export-secret-keys -a $KEYID | sudo tee /mnt/encrypted-storage/key-$KEYID/mastersub.key
gpg --export -a $KEYID > key-$KEYID.pub
```

The master key and subkeys should be stored offline. Since the private key of
subkeys are still on machine, the subkeys can then be transferred to Yubikey(s)
(see [Transfer keys](https://github.com/drduh/YubiKey-Guide#transfer-keys)).

To transfer the set of subkeys to another YubiKey, the keygrips on the machine
has to be removed first (and only the key grips that has been transferred
though).

Note that the following script remove all the keygrips.

```sh
CONFIG_DIR=$(gpgconf --list-dirs homedir)
gpg --with-keygrip --list-secret-keys $KEYID \
  | grep Keygrip \
  | awk '{print $3}' \
  | xargs -n 1 -I % rm "$CONFIG_DIR/private-keys-v1.d/%.key" 2> /dev/null
```

The secret key on the machine can be removed by

```sh
gpg --delete-secret-and-public-keys $KEYID
```

The exported public key can be uploaded onto a key server (Note that network
connection of `pgp.mit.edu` can be pretty bad and upload via a browser can be
used instead). Once upload has been completed, [import the public from key
server](./gpg.md#to-upload-a-public-key-to-key-server) again and test if the
Yubikey can be used properly. Once the tests looks good, the public key can be
further uploaded onto sites such as `github.com`. Since the public contains
information on the subkeys, update is required on those sites. To setup other
machines, remove  the existing key and delete all keygrips and import the new
public key from the key server.

SSH public keys can be obtained when a Yubikey is inserted and the following
command is ran.

```sh
ssh-add -L
```

The public keys can then be uploaded to various services and remote server
machines.

##### On a machine where Yubikey cannot be used

A set of subkeys will need to be generated for this machine. The procedures are
the same a generating subkeys for a Yubikey. The trick is to import the secret
subkeys exported in above steps, change the passphrase, and remove all
non-relevant subkeys (that is, keeping only one set of subkeys).

##### Tricks

- In case an inserted Yubikey cannot be found, try open another terminal.

### GPG Agent Forwarding

Reference: [drduh/YubiKey-Guide - Remote Machines (GPG Agent
Forwarding)](https://github.com/drduh/YubiKey-Guide#remote-machines-gpg-agent-forwarding)

To find the socket on local machine

```sh
gpgconf --list-dirs agent-extra-socket
```

To find the socket on remote machine

```sh
gpgconf --list-dirs agent-socket
```

To copy public keys to the remote machine

```sh
scp ~/.gnupg/pubring.kbx remote:~/.gnupg/
```
