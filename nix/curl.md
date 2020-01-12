
____

###### To download a file from web and rename it

```sh
curl https://xyz.com/instructions.pdf -o guide.pdf
```

###### To download a file from web with a forward URL and rename it

```sh
curl -L https://xyz.com/install -o installer.deb
```

###### Basic Authentication

```sh
curl --user your-username:your-password http://localhost/testing
```

###### Bearer token

```sh
curl -H "Authorization: Bearer $TOKEN" http://localhost/testing
```

###### Use header

```sh
curl -H "Content-Type: application/json" http://localhost/testing
```

###### Posting with JSON payload

```sh
curl -X POST -H "Content-Type: application/json" -d '{ "property1": "value1" }' http://localhost/testing
```

###### To specify HTTP multipart POST data

```sh
curl -X POST -F "parameter1=value1" -F "parameter2=value2" http://localhost/testing
```

###### To include cookies

```sh
curl -b "Cookie1=Value1;Cookie2=Value2" http://localhost/testing
```

or from a file

```sh
curl -b cookies.txt http://localhost/testing
```

###### To write issued cookies to a file

```sh
curl -c issued_cookies.txt http://localhost/testing
```

###### Slient mode

```sh
curl -s http://localhost/testing
```

###### Slient mode but showing errors

```sh
curl -sS http://localhost/testing
```

###### To fail silently

```sh
curl -f http://localhost/testing
```

###### Follow redirect URL

```sh
curl -L http://localhost/testing
```

###### Write output to a file named as the remote file

```sh
curl -O http://localhost/testing.txt
```

###### To request compressed response

```sh
curl --compressed http://localhost/testing
```

###### Allow connections to SSL sites without certs (insecure)

```sh
curl -k https://localhost/testing
```

Note that this disables certificate path validation.

###### To specify root/CA certificate to establish TLS connection

```sh
curl --cacert root.crt https://localhost:8443/testing
```

###### To include protocol headers in the output

```sh
curl -i http://localhost/testing
```

###### To show document information only

```sh
curl -I http://localhost/testing
```

###### To return HTTP status code only

```sh
curl -s -o /dev/null -I -w "%{http_code}" https://github.com
```

###### Verbose mode

```sh
curl -v http://localhost/testing
```

