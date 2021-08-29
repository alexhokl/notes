- [Commands](#commands)
  * [Key management](#key-management)
  * [Operations](#operations)
  * [Configuration](#configuration)
- [Yubikey](#yubikey)
    + [Links](#links)
    + [Master key](#master-key)
    + [Key management](#key-management-1)
    + [Install existing keys to new a Yubikey](#install-existing-keys-to-new-a-yubikey)
____

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

### Master key

Master key should be kept offline at all times and only accessed to revoke or
issue new subkeys.

Note that, once GPG keys are moved to a YubiKey, it cannot be moved again.

### Key management

Subkeys are generated on a per-Yubikey-basis.  Usually a Yubikey is paired with
a machine to minimise the effort in managing the keygrips. Thus, if there are
3 Yubikeys to be setup, 3 set of subkeys (9 keys; signing, encryption and
authentication for each set) will be generated.

Once a set of new subkeys are
[generated](https://github.com/drduh/YubiKey-Guide#sub-keys), the [master
key](./gpg.md#to-export-private-key) and [subkeys](./gpg.md#to-export-sub-keys)
should be exported. The subkeys can then be transferred to a Yubikey (see
[Transfer keys](https://github.com/drduh/YubiKey-Guide#transfer-keys)).

To transfer the set of subkeys to another YubiKey, the keygrips on the machine
has to be removed first.

```sh
CONFIG_DIR=$(gpgconf --list-dirs homedir)
KEYID=your-master-key-id
gpg --with-keygrip --list-secret-keys $KEYID | grep Keygrip | awk '{print $3}' | xargs -n 1 -I % rm "$CONFIG_DIR/private-keys-v1.d/%.key" 2> /dev/null
gpg --card-status
```

Once all Yubikeys has been filled with the new set of subkeys, the exported
public key can be uploaded onto all sites (such as `pgp.mit.edu` or
`github.com`) that using this key. Since the public contains information on the
subkeys, update is required on those sites. The public key uploaded can also be
imported by other machines so that the new subkeys can be used. The exported
secret key can then be copied to an encrypted storage for long term offline
storage. The secret key on the machine can be removed by

```sh
KEYID=your-master-key-id
gpg --delete-secret-and-public-keys $KEYID
```

To ensure the key can be used on the machine, import the newly exported public
key again. To enable the use of the new set of subkeys on other machines, remove
the existing key and delete all keygrips as show above and import the newly
exported public key.

##### Tricks

- In case an inserted Yubikey cannot be found, try open another terminal.

### Install existing keys to new a Yubikey

Assuming keys are stored in an encrypted USB drive as `/dev/sda1` and name
of master key file is `mastersub.key`.

Follow [Configure
Smartcard](https://github.com/drduh/YubiKey-Guide#configure-smartcard) to
prepare the new YubiKey.

```sh
sudo cryptsetup luksOpen /dev/sda1 secret
sudo mount /dev/mapper/secret /mnt/encrypted-usb
gpg --import /mnt/encrypted-usb/mastersub.key
```

Follow [Transfer keys](https://github.com/drduh/YubiKey-Guide#transfer-keys) to
transfer the imported keys to the new Yubikey.
