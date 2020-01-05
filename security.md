- [OAuth 2.0](#oauth-20)
    + [Links](#links)
- [OpenID](#openid)
- [JWT](#jwt)
    + [Abstract](#abstract)
    + [Introduction](#introduction)
    + [Terminology](#terminology)
    + [JSON Web Token (JWT) Overview](#json-web-token-jwt-overview)
    + [JWT Claims](#jwt-claims)
    + [Unsecured JWTs](#unsecured-jwts)
  * [JWS](#jws)
    + [JWS Compact Serialization](#jws-compact-serialization)
    + [JWS JSON Serialization](#jws-json-serialization)
- [Public Key Infrastructure (PKI)](#public-key-infrastructure-pki)
  * [Certificate](#certificate)
  * [PKI](#pki)
    + [Web PKI](#web-pki)
    + [Internal PKI](#internal-pki)
  * [Trust & Trustworthiness](#trust--trustworthiness)
- [TLS](#tls)
    + [.csr (Certificate Signing Request)](#csr-certificate-signing-request)
    + [.pem (Privacy Enhanced Mail)](#pem-privacy-enhanced-mail)
    + [.key](#key)
    + [.pkcs12 .pfx .p12](#pkcs12-pfx-p12)
    + [.der](#der)
    + [.cert .cer .crt](#cert-cer-crt)
    + [.p7b](#p7b)
    + [.crl (Certificate revocation list)](#crl-certificate-revocation-list)
____

# OAuth 2.0

### Links

- [RFC-6749 - OAuth 2.0 spec](https://tools.ietf.org/html/rfc6749)
- [How To Control User Identity Within
  Microservices](http://nordicapis.com/how-to-control-user-identity-within-microservices/)
- [A Guide To OAuth 2.0
  Grants](https://alexbilbie.com/guide-to-oauth-2-grants/)
- [Libraries](https://oauth.net/code/)
- [GOTO 2018 • Introduction to OAuth 2.0 and OpenID Connect • Philippe De
  Ryck](https://www.youtube.com/watch?v=GyCL8AJUhww)
- [Why the Resource Owner Password Credentials Grant Type is not Authentication
  nor Suitable for Modern Applications](https://www.scottbrady91.com/OAuth/Why-the-Resource-Owner-Password-Credentials-Grant-Type-is-not-Authentication-nor-Suitable-for-Modern-Applications)
- [Everything you should know about certificates and PKI but are too afraid to
  ask](https://smallstep.com/blog/everything-pki/)

# OpenID

- the ID tokens issued are supposed to be used by client and should not be
  consumed by APIs

# JWT

### Abstract

- The claims in a JWT
   are encoded as a JSON object that is used as the payload of a JSON
   Web Signature (JWS) structure or as the plaintext of a JSON Web
   Encryption (JWE) structure, enabling the claims to be digitally
   signed or integrity protected with a Message Authentication Code
   (MAC) and/or encrypted.

### Introduction

- JWTs are always
   represented using the JWS Compact Serialization or the JWE Compact
   Serialization.

### Terminology

- JSON Web Token (JWT) - A string representing a set of claims as a JSON object
  that is encoded in a JWS or JWE, enabling the claims to be digitally signed
  or MACed and/or encrypted.
- NumericDate - A JSON numeric value representing the number of seconds from
  1970-01-01T00:00:00Z UTC until the specified UTC date/time, ignoring leap
  seconds

### JSON Web Token (JWT) Overview

- The contents of the JOSE Header describe the cryptographic operations
   applied to the JWT Claims Set.
- If the JOSE Header is for a JWS, the
   JWT is represented as a JWS and the claims are digitally signed or
   MACed, with the JWT Claims Set being the JWS Payload.
- If the JOSE
   Header is for a JWE, the JWT is represented as a JWE and the claims
   are encrypted, with the JWT Claims Set being the plaintext encrypted
   by the JWE.
- A JWT is represented as a sequence of URL-safe parts separated by
   period ('.') characters.  Each part contains a base64url-encoded
   value.  The number of parts in the JWT is dependent upon the
   representation of the resulting JWS using the JWS Compact
   Serialization or JWE using the JWE Compact Serialization.

#### Example on JWS MACed using the HMAC SHA-256

Combination of the following 3 components

- base64 encoded UTF-8 JOSE headers
- base64 encoded JWT claim set
- base64 encoded HMAC SHA-256 signature (or value) of (ASCII(BASE64URL(UTF8(JWS
  Protected Header)) || '.' || BASE64URL(JWS Payload)))

### JWT Claims

- The Claim Names within a JWT Claims Set
   MUST be unique
- all claims that are not understood
   by implementations MUST be ignored.
- There are three classes of JWT Claim Names: Registered Claim Names,
   Public Claim Names, and Private Claim Names.
- See [registered claim names](https://tools.ietf.org/html/rfc7519#section-4.1)
  for a set of commonly used names

### Unsecured JWTs

- just leave the signature part empty

## JWS

- headers are union of the following two
  - JWS protected header
  - JWS unprotected header
- two types of serialisation
  - JWS Compact Serialization (probably the most common one)
  - JWS JSON Serialization
- header `crit` is an array and it specifies that the implementation must be
  able to understood and process this headers listed in the array

### JWS Compact Serialization

- no JWS unprotected header

### JWS JSON Serialization

- combination of the following components
  - `protected` - with the value BASE64URL(UTF8(JWS Protected Header))
  - `header` - with the value JWS Unprotected Header
  - `payload` - with the value BASE64URL(JWS Payload)
  - `signature` - with the value BASE64URL(JWS Signature)

# Public Key Infrastructure (PKI)

## Certificate

A data structure that contains

- a public key and
- a name

The data structure is then signed. The signature binds the public key to the
name. The entity that signs a certificate is called the issuer (or certificate
authority (CA)) and the entity named in the certificate is called the subject.

X.509 v3 certificates is the most common form of certificates. Usually, it is
the PKIX variant described in [RFC 5280](https://tools.ietf.org/html/rfc5280)
and further refined by the CA/Browser Forum’s Baseline Requirements. This is
the kind of certificates that browsers understand and use for HTTPS (HTTP over
TLS). There are other certificate formats.  Notably, SSH and PGP both have
their own. 

If you’ve ever looked at an X.509 certificate and wondered why something
designed for the web encodes a locality, state, and country here’s your answer:
X.509 wasn’t designed for the web. It was designed in the 80s to build a phone
book.

There are a bunch of encoding rules for ASN.1, but there’s only one that’s
commonly used for X.509 certificates and other crypto stuff: distinguished
encoding rules (DER). You don’t have to worry much about encoding and decoding
DER but you definitely will need to figure out whether a particular certificate
is a plain DER-encoded X.509 certificate or something fancier. There are two
potential dimensions of fanciness: we might be looking at something more than
raw DER, and we might be looking at something more than just a certificate. DER
is straight binary, and binary data is hard to copy-paste and otherwise shunt
around the web. So most certificates are packaged up in PEM files (a base64
encoded payload sandwiched between a header and a footer). PEM-encoded
certificates will usually carry a .pem, .crt, or .cer extension. A raw
certificate encoded using DER will usually carry a .der extension. Again,
there’s not much consistency here, so your mileage may vary.

One of the common envelope formats is part of a suite of standards is called
PKCS (Public Key Cryptography Standards). When some things ask for “a
certificate”, what they really want a certificate in one of envelope formats.
[PKCS#7](https://tools.ietf.org/html/rfc2315) can contain one or more
certificates (which can encode a full certificate chain). PKCS#7 is commonly
used by Java. Common extensions are `.p7b` and `.p7c`. The other common
envelope format is [PKCS#12](https://tools.ietf.org/html/rfc7292) which can
contain a certificate chain (like PKCS#7) along with an (encrypted) private
key. PKCS#12 is commonly used by Microsoft products. Common extensions are
`.pfx` and `.p12`. Again, the PKCS#7 and PKCS#12 envelopes also use ASN.1. That
means both can be encoded as raw DER or BER or PEM (although it is using DER
most of the time).

If you’re lucky [RFC 7468](https://tools.ietf.org/html/rfc7468) will give good
guidance to figure out what your PEM payload is. Elliptic curve keys are
usually labeled as such, though there doesn’t seem to be any standardization.
Other keys are simply “PRIVATE KEY” by PEM. This usually indicates a PKCS#8
payload, an envelope for private keys that includes key type and other
metadata.

It’s also quite common to see private keys encrypted using a password (a shared
secret or symmetric key). Those will look something like this (`Proc-Type` and
`DEK-Info` are part of PEM and indicate that this PEM payload is encrypted
using AES-256-CBC):

```console
-----BEGIN EC PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-256-CBC,b3fd6578bf18d12a76c98bda947c4ac9

qdV5u+wrywkbO0Ai8VUuwZO1cqhwsNaDQwTiYUwohvot7Vw851rW/43poPhH07So
sdLFVCKPd9v6F9n2dkdWCeeFlI4hfx+EwzXLuaRWg6aoYOj7ucJdkofyRyd4pEt+
Mj60xqLkaRtphh9HWKgaHsdBki68LQbObLOz4c6SyxI=
-----END EC PRIVATE KEY-----
```

PKCS#8 objects can also be encrypted, in which case the header label should be
“ENCRYPTED PRIVATE KEY” per RFC 7468. You won’t have `Proc-Type` and `Dek-Info`
headers in this case as this information is encoded in the payload instead.

Public keys will usually have a `.pub` or `.pem` extension. Private keys may
carry a `.prv`, `.key`, or `.pem` extension.

## PKI

PGP uses certificates, but doesn’t use CAs. Instead it uses a web-of-trust
model. 

### Web PKI

It is mostly defined by [RFC 5280](https://tools.ietf.org/html/rfc5280) and
refined by the [CA/Browser Forum](https://cabforum.org/).

### Internal PKI

It is needed as Web PKI is not designed to support internal use cases.  With
Web PKI, you have little or no control over important details like certificate
lifetime, revocation mechanisms, renewal processes, key types, and algorithms.
The CA/Browser Forum Baseline Requirements actually prohibit Web PKI CAs from
binding internal IPs (e.g., stuff in `10.0.0.0/8`) or internal DNS names that
are not fully-qualified and resolvable in public global DNS (e.g., you cannot
bind a kubernetes cluster DNS name like `foo.ns.svc.cluster.local`). If you
want to bind this sort of name in a certificate, issue lots of certificates, or
control certificate details, you’ll need your own internal PKI.

## Trust & Trustworthiness

Relying parties, such as a browser, are pre-configured with a list of trusted
root certificates (or trust anchors) in a trust store.

Root certificates in trust stores are self-signed. The issuer and the subject
are the same. The signature on a self-signed certificate provides assurance
that the subject/issuer knows the relevant private key. A self-signed
certificate should only be trusted insofar as the process by which it made its
way into the trust store is trusted. On macOS the trust store is managed by the
keychain. On many Linux distributions it’s simply some file(s) in `/etc` or
elsewhere on disk. If your users can modify these files you better trust all
your users. Operating system trust stores typically ship with the OS. Firefox
ships with its own trust store (distributed using TLS from mozilla.org
— bootstrapping off of Web PKI using some other trust store). Programming
languages and other non-browser stuff like curl typically use the OS trust
store by default. Cloudflare’s `cfssl` project maintains a github repository
that includes the trusted certificates from various trust stores to assist with
certificate bundling.

There are 100+ certificate authorities trusted in the descriptive sense
— browsers and other stuff trust certificates issued by these CAs by default.
But that does not mean they are trustworthy in the moral sense. On the
contrary, there are documented cases of Web PKI certificate authorities
providing governments with fraudulent certificates in order to snoop on traffic
and impersonate websites. Some of these “trusted” CAs operate out of
authoritarian jurisdictions like China. The 2011 DigiNotar attack demonstrated
the problem here: as part of the attack a certificate was fraudulently issued
for google.com. This certificate was trusted by major web browsers and
operating systems despite the fact that Google had no relationship with
DigiNotar. DigiNotar root certificates were ultimately removed from the major
trust stores, but a lot of damage had almost certainly already been done. More
recently, Sennheiser got called out for installing a self-signed root
certificate in trust stores with their HeadSetup app, then embedding the
corresponding private key in the app’s configuration. Anyone can extract this
private key and use it to issue a certificate for any domain. Any computer that
has the Sennheiser certificate in its trust store would trust these fraudulent
certificates. This completely undermines TLS. Oops.

Certificate Transparency (CT) ([RFC 6962](https://tools.ietf.org/html/rfc6962))
mandates that CAs submit every certificate they issue to an impartial observer
that maintains a public certificate log to detect fraudulently issued
certificates. A lot of certificate policy must be enforced by RPs, and RPs can
rarely be bothered. If RPs do not check CAA records and do not require proof of
CT submission this stuff does not do much good.

In any case, if you run your own internal PKI you should maintain a separate
trust store for internal stuff. That is, instead of adding your root
certificate(s) to the existing system trust store, configure internal TLS
requests to use only your roots. If you want better federation internally
(e.g., you want to restrict which certificates your internal CAs can issue) you
might try CAA records and properly configured RPs. You might also want to check
out SPIFFE, an evolving standardization effort that addresses this problem and
a number of others related to internal PKI.

# TLS

TLS is successor of SSL (SSL 2.0 and SSL 3.0) and it has 4 versions.

- 1.0 (will be deprecated soon)
- 1.1 (will be deprecated soon)
- 1.2
- 1.3 

### .csr (Certificate Signing Request)

Some applications can generate these for submission to certificate-authorities.
The actual format is PKCS10 which is defined in [RFC
2986](https://tools.ietf.org/html/rfc2986). It includes some/all of the key
details of the requested certificate such as subject, organization, state,
whatnot, as well as the public key of the certificate to get signed. These get
signed by the CA and a certificate is returned. The returned certificate is the
public certificate (which includes the public key but not the private key),
which itself can be in a couple of formats.

### .pem (Privacy Enhanced Mail)

Defined in [RFC 1421](https://tools.ietf.org/html/rfc1421), [RFC
1422](https://tools.ietf.org/html/rfc1422), [RFC
1423](https://tools.ietf.org/html/rfc1423), [RFC
1424](https://tools.ietf.org/html/rfc1424), this is a container format that may
include just the public certificate (such as with Apache installs, and CA
certificate files `/etc/ssl/certs`), or may include an entire certificate chain
including public key, private key, and root certificates. Confusingly, it may
also encode a CSR (e.g. as used here) as the PKCS10 format can be translated
into PEM. It is a base64 translation of the x509 ASN.1 keys.

### .key

This is a PEM formatted file containing just the private-key of a specific
certificate and is merely a conventional name and not a standardized one. In
Apache installs, this frequently resides in `/etc/ssl/private`. The rights on
these files are very important, and some programs will refuse to load these
certificates if they are set wrong.

### .pkcs12 .pfx .p12

Originally defined by RSA in the Public-Key Cryptography Standards, the "12"
variant was enhanced by Microsoft. This is a passworded container format that
contains both public and private certificate pairs. Unlike .pem files, this
container is fully encrypted. Openssl can turn this into a .pem file with both
public and private keys: `openssl pkcs12 -in file-to-convert.p12 -out
converted-file.pem -nodes`

### .der

A way to encode ASN.1 syntax in binary, a .pem file is just a Base64 encoded
.der file. OpenSSL can convert these to .pem (`openssl x509 -inform der -in
to-convert.der -out converted.pem`). Windows sees these as Certificate files.
By default, Windows will export certificates as .DER formatted files with
a different extension.

### .cert .cer .crt

A .pem (or rarely .der) formatted file with a different extension, one that is
recognized by Windows Explorer as a certificate, which .pem is not.

### .p7b

Defined in [RFC 2315](https://tools.ietf.org/html/rfc2315), this is a format
used by windows for certificate interchange. Java understands these natively.
Unlike .pem style certificates, this format has a defined way to include
certification-path certificates.

### .crl (Certificate revocation list)

Certificate Authorities produce these as a way to de-authorize certificates
before expiration. You can sometimes download them from CA websites.
