# SSL

### .csr (Certificate Signing Request)

Some applications can generate these for submission to certificate-authorities. The actual format is PKCS10 which is defined in [RFC 2986](https://tools.ietf.org/html/rfc2986). It includes some/all of the key details of the requested certificate such as subject, organization, state, whatnot, as well as the public key of the certificate to get signed. These get signed by the CA and a certificate is returned. The returned certificate is the public certificate (which includes the public key but not the private key), which itself can be in a couple of formats.

### .pem (Privacy Enhanced Mail)

Defined in [RFC 1421](https://tools.ietf.org/html/rfc1421), [RFC 1422](https://tools.ietf.org/html/rfc1422), [RFC 1423](https://tools.ietf.org/html/rfc1423), [RFC 1424](https://tools.ietf.org/html/rfc1424), this is a container format that may include just the public certificate (such as with Apache installs, and CA certificate files `/etc/ssl/certs`), or may include an entire certificate chain including public key, private key, and root certificates. Confusingly, it may also encode a CSR (e.g. as used here) as the PKCS10 format can be translated into PEM. It is a base64 translation of the x509 ASN.1 keys.

# .key

This is a PEM formatted file containing just the private-key of a specific certificate and is merely a conventional name and not a standardized one. In Apache installs, this frequently resides in `/etc/ssl/private`. The rights on these files are very important, and some programs will refuse to load these certificates if they are set wrong.

# .pkcs12 .pfx .p12

Originally defined by RSA in the Public-Key Cryptography Standards, the "12" variant was enhanced by Microsoft. This is a passworded container format that contains both public and private certificate pairs. Unlike .pem files, this container is fully encrypted. Openssl can turn this into a .pem file with both public and private keys: `openssl pkcs12 -in file-to-convert.p12 -out converted-file.pem -nodes`

# .der

A way to encode ASN.1 syntax in binary, a .pem file is just a Base64 encoded .der file. OpenSSL can convert these to .pem (`openssl x509 -inform der -in to-convert.der -out converted.pem`). Windows sees these as Certificate files. By default, Windows will export certificates as .DER formatted files with a different extension.

# .cert .cer .crt

A .pem (or rarely .der) formatted file with a different extension, one that is recognized by Windows Explorer as a certificate, which .pem is not.

# .p7b

Defined in [RFC 2315](https://tools.ietf.org/html/rfc2315), this is a format used by windows for certificate interchange. Java understands these natively. Unlike .pem style certificates, this format has a defined way to include certification-path certificates.

### .crl (Certificate revocation list)

Certificate Authorities produce these as a way to de-authorize certificates before expiration. You can sometimes download them from CA websites.
