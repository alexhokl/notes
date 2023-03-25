- [OAuth](#oauth)
- [Keys](#keys)
  * [To inspect a JWT token](#to-inspect-a-jwt-token)
  * [To verify (and inspect) a JWT token](#to-verify-and-inspect-a-jwt-token)
  * [To generate key pair using RSA](#to-generate-key-pair-using-rsa)
  * [To generate key pair using elliptic curve](#to-generate-key-pair-using-elliptic-curve)
- [Certificates](#certificates)
  * [To check SSL certificate of a website](#to-check-ssl-certificate-of-a-website)
  * [To check expiration date of a SSL certificate](#to-check-expiration-date-of-a-ssl-certificate)
  * [To check domains of a certificate](#to-check-domains-of-a-certificate)
  * [To create a certificate signed by a CA (and a private key)](#to-create-a-certificate-signed-by-a-ca-and-a-private-key)
  * [To create a self-signed certificate](#to-create-a-self-signed-certificate)
- [Certificate Authority](#certificate-authority)
  * [To generate a certificate and a private key for a domain using Let's Encrypt](#to-generate-a-certificate-and-a-private-key-for-a-domain-using-lets-encrypt)
  * [To get root cert(s) from CA](#to-get-root-certs-from-ca)
  * [To generate a certificate and a private key from a local CA](#to-generate-a-certificate-and-a-private-key-from-a-local-ca)
____

## OAuth

Reference: [step oauth](https://smallstep.com/docs/step-cli/reference/oauth)

Assuming OIDC discovery document is available at
`https://testing.com/.well-known/openid-configuration`

```sh
step oauth --client-id $CLIENT_ID --client-secret $CLIENT_SECRET \
  --provider https://testing.com --listen :9999 --scope=api
```

or

```sh
step oauth --client-id $CLIENT_ID --client-secret $CLIENT_SECRET \
  --provider https://testing.com/.well-known/openid-configuration --listen :9999 --scope=api
```

To get access token in form of a HTTP header

```sh
step oauth --header --client-id $CLIENT_ID --client-secret $CLIENT_SECRET \
  --provider https://testing.com --listen :9999 --scope=api
```

To get just the access token

```sh
step oauth --bear --client-id $CLIENT_ID --client-secret $CLIENT_SECRET \
  --provider https://testing.com --listen :9999 --scope=api
```

To get just the OIDC token

```sh
step oauth --oidc --bear --client-id $CLIENT_ID --client-secret $CLIENT_SECRET \
  --provider https://testing.com --listen :9999 --scope=api
```

## Keys

Reference: [step crypto](https://smallstep.com/docs/step-cli/reference/crypto)

### To inspect a JWT token

```sh
echo $TOKEN | step crypto jwt inspect --insecure
```

assuming the token is wrapped by `$TOKEN`

### To verify (and inspect) a JWT token

```sh
echo $TOKEN | step crypto jwt verify --key id4.crt --iss https://testing.com --aud api --alg RS256
```

### To generate key pair using RSA

```sh
step crypto keypair k.pub k.prv --kty RSA --size 4096
```

### To generate key pair using elliptic curve

```sh
step crypto keypair k.pub k.prv --kty EC --curve P-256
```

## Certificates

Reference: [step
certificate](https://smallstep.com/docs/step-cli/reference/certificate)

### To check SSL certificate of a website

```sh
step certificate inspect https://github.com
```

### To check expiration date of a SSL certificate

```sh
step certificate inspect https://github.com --format json | jq -r .validity.end
```

or

```sh
step certificate inspect cert.pem --format json | jq -r .validity.end
```

### To check domains of a certificate

```sh
step certificate inspect https://$DOMAIN --format json \
  | jq -r '.extensions.subject_alt_name.dns_names[]'
```

### To create a certificate signed by a CA (and a private key)

```sh
step certificate create -csr test.smallstep.com test.csr test.key
```

### To create a self-signed certificate

```sh
step certificate create your-domain.com oauth.crt oauth.key --profile self-signed \
  --subtle --kty=RSA --size=4096 --not-after 8760h
```

or, to create without a password

```sh
step certificate create your-domain.com oauth.crt oauth.key --profile self-signed \
  --subtle --kty=RSA --size=4096 --no-password --insecure --not-after 8760h
```

## Certificate Authority

Reference: [step ca](https://smallstep.com/docs/step-cli/reference/ca)

### To generate a certificate and a private key for a domain using Let's Encrypt

```sh
step ca certificate testing.dev testing.dev.crt testing.dev.key \
  --acme https://acme-staging-v02.api.letsencrypt.org/directory --san testing.dev
```

Note that staging server of Let's Encrypt is used.

### To get root cert(s) from CA

```sh
step ca root root.crt --fingerprint 4324324324 --ca-url https://127.0.0.1:4443
```

Assuming a CA server has been setup locally.

### To generate a certificate and a private key from a local CA

```sh
step ca certificate localhost server.crt server.key --ca-url https://127.0.0.1:4443
```
