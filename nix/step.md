- [OAuth 2.0](#oauth-20)
  * [To get token response using Google OpenID](#to-get-token-response-using-google-openid)
  * [To get token response](#to-get-token-response)
  * [To inspect a JWT token](#to-inspect-a-jwt-token)
- [Certificates](#certificates)
  * [To check SSL certificate of a website](#to-check-ssl-certificate-of-a-website)
  * [To check expiration date of a SSL certificate](#to-check-expiration-date-of-a-ssl-certificate)
  * [To check domains of a certificate](#to-check-domains-of-a-certificate)
  * [To create a certificate signed by a CA (and a private key)](#to-create-a-certificate-signed-by-a-ca-and-a-private-key)
  * [To create a self-signed certificate](#to-create-a-self-signed-certificate)
- [Keys](#keys)
  * [To generate key pair using RSA](#to-generate-key-pair-using-rsa)
  * [To generate key pair using elliptic curve](#to-generate-key-pair-using-elliptic-curve)
- [Certificate Authority](#certificate-authority)
  * [To generate a certificate and a private key for a domain using Let's Encrypt](#to-generate-a-certificate-and-a-private-key-for-a-domain-using-lets-encrypt)
  * [To get root cert(s) from CA](#to-get-root-certs-from-ca)
  * [To generate a certificate and a private key from a local CA](#to-generate-a-certificate-and-a-private-key-from-a-local-ca)
____

## OAuth 2.0

### To get token response using Google OpenID

```sh
step oauth
```

To show the access token as a HTTP header

```sh
step oauth --header
```

### To get token response

```sh
step oauth --provider https://your-domain.com --client-id your-client --client-secret your-secret --scope api --listen :20000
```

The command will try to discover the endpoints by checking
https://your-domain.com/.well-known/openid-configuration and set `redirect_uri`
as http://127.0.0.1:20000

### To inspect a JWT token

```sh
echo $TOKEN | step crypto jwt inspect --insecure
```

assuming the token is wrapped by `$TOKEN`

## Certificates

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
step certificate inspect https://$DOMAIN --format json | jq -r '.extensions.subject_alt_name.dns_names[]'
```

### To create a certificate signed by a CA (and a private key)

```sh
step certificate create -csr test.smallstep.com test.csr test.key
```

### To create a self-signed certificate

```sh
step certificate create your-domain.com oauth.crt oauth.key --profile self-signed --subtle --kty=RSA --size=4096 --not-after 8760h
```

or, to create without a password

```sh
step certificate create your-domain.com oauth.crt oauth.key --profile self-signed --subtle --kty=RSA --size=4096 --no-password --insecure --not-after 8760h
```

## Keys

### To generate key pair using RSA

```sh
step crypto keypair k.pub k.prv --kty RSA --size 4096
```

### To generate key pair using elliptic curve

```sh
step crypto keypair k.pub k.prv --kty EC --curve P-256
```

## Certificate Authority

### To generate a certificate and a private key for a domain using Let's Encrypt

```sh
step ca certificate testing.dev testing.dev.crt testing.dev.key --acme https://acme-staging-v02.api.letsencrypt.org/directory --san testing.dev
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
