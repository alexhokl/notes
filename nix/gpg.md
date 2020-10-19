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
gpg --export-secret-keys -a your-key-id
```

`-a` to ascii-armored the key

##### To export public key

```sh
gpg --export -a your-key-id
```

##### To import GPG key(s) from a file

```sh
gpg --import filename.asc
```

##### To import GPG key(s) from another machine via SSH

```sh
ssh user_name@server_name gpg --export-secret-key your-key-id | gpg --import
```

##### To import a public key from key server

```sh
gpg --keyserver hkps://pgp.mit.edu --recv-keys your-key-id
```

or, from default set of servers

```sh
gpg --recv your-key-id
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
gpg --edit-key your-key-id
```

##### To change password of a key

```sh
gpg --edit-key your-key-id passwd
```

Note that master key and its subkeys shares the same passphrase (password).

##### To upload a (public) key to key server

```sh
gpg --keyserver pgp.mit.edu --send-key your-key-id
```

##### To delete a public key

```sh
gpg --delete-keys your-key-id
```

##### To delete a secret key

```sh
gpg --delete-secret-keys your-key-id
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

Subkeys can be generated on a per-Yubikey-basis or the same set of subkeys be
applied to all Yubikeys. Usually a Yubikey is paired with a machine to minimise
the effort in managing the keygrips.

Once a set of new subkeys are generated, the public key and secret key should be
exported. The subkeys can then be transferred to a Yubikey (see [Transfer
keys](https://github.com/drduh/YubiKey-Guide#transfer-keys)).

To transfer the set of subkeys to another YubiKey, the keygrips on the machine
has to be removed first.

```sh
CONFIG_DIR=$(gpgconf --list-dirs homedir)
KEYID=your-master-key-id
KEYGRIPS="$(gpg --with-keygrip --list-secret-keys $KEYID | grep keygrip | awk '{print $3}')"
for k in $KEYGRIPS; do
  rm "$CONFIG_DIR/private-keys-v1.d/$k.key" 2> /dev/null
done
gpg --card-status
```

Once all Yubikeys has been filled with the new set of subkeys, the exported
public key can be uploaded onto all sites that using this key. Since the public
contains information on the subkeys, update is required on those sites.
The exported secret key can then be copied to an encrypted storage for long term
offline storage. The secret key on the machine can be removed by

```sh
KEYID=your-master-key-id
gpg --delete-secret-and-public-keys $KEYID
```

To ensure the key can be used on the machine, import the newly exported public
key again. To enable the use of the new set of subkeys on other machines, remove
the existing key and delete all keygrips as show above and import the newly
exported public key.

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
