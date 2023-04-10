- [Commands](#commands)
- [Recipes](#recipes)
____

### Commands

```sh
openssl <command>
```

| Command | Description |
| --- | --- |
| genrsa | Generation of RSA Private Key |
| req | PKCS#10 X.509 Certificate Signing Request (CSR) Management |
| x509 | X.509 Certificate Data Management |
| pkcs12 | PKCS#12 Data Management |
| passwd | computes the hash of a password |

### Recipes

##### To generate a SSL cert for HAProxy

```sh
openssl genrsa -out selfsigned.key
openssl req -new -config gen.conf -key selfsigned.key -out csr.pem
openssl x509 -req -days 9999 -in csr.pem -signkey selfsigned.key -out cert.pem
rm csr.pem
cp cert.pem https_cert.pem
cat selfsigned.key >> https_cert.pem
rm cert.pem selfsigned.key
```

##### To generate a SSL cert

```sh
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout selfsigned.key -out selfsigned.crt
```

or, to include a password

```sh
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout selfsigned.key -out selfsigned.crt -passin pass:YourSecurePassword
```

or, to include a configuration file to avoid command line prompts

```sh
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout selfsigned.key -out selfsigned.crt -passin pass:YourSecurePassword -config gen.conf
```

or, to include configurations as command line parameters

```sh
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout selfsigned.key -out selfsigned.crt -passin pass:YourSecurePassword -subj "/C=US/ST=NY/L=NewYork/O=Testing/CN=localhost"
```

Note that `-nodes` stands for "no DES" where the user will not be asked for
a password to encrypt the private key.

##### To generate key pair using elliptic curve P-256

```sh
openssl ecparam -name prime256v1 -genkey -out k.prv
openssl ec -in k.prv -pubout -out k.pub
```

Note that this is equivalent to using [smallstep
CLI](https://github.com/alexhokl/notes/blob/master/step.md#to-generate-key-pair-using-elliptic-curve).

##### To extract public key from a certficiate

```sh
openssl x509 -pubkey -noout -in selfsigned.crt | tee selfsigned.pub
```

##### To convert CRT TO PEM

```sh
openssl x509 -in selfsigned.crt -out selfsigned.pem -outform PEM
```

##### To generate pfx (or .p12) from a private key and its corresponding certificate

```sh
openssl pkcs12 -export -out selfsigned.pfx -inkey selfsigned.key -in selfsigned.crt
```

or, if password is required for the key

```sh
openssl pkcs12 -export -out selfsigned.pfx -inkey selfsigned.key -in selfsigned.crt -passout pass:YourSecurePassword
```

##### To extract private key from pfx

```sh
openssl pkcs12 -in selfsigned.pfx -nocerts -out selfsigned.key
```

Note that you will be asked the password for `pfx` and a new password for the
extracted keys.

##### To extract certifcate from pfx

```sh
openssl pkcs12 -in selfsigned.pfx -clcerts -nokeys -out selfsigned.crt
```

##### To convert to a PKCS#8 encoded private RSA key from PKCS#1 encoded private RSA key

```sh
openssl pkcs8 -inform PEM -topk8 -passin file:local.password -passout file:local.password \
  -in local.key -out local.key.pem
```

Assuming password file `local.password` has been prepared like the following.

```
strongP@ssw0rd
strongP@ssw0rd
```

##### To generate a password conform to Apache

```sh
openssl passwd -apr1 >> htpasswd
```
