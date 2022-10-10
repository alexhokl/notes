
____

##### Posting with JSON payload

```sh
xh post http://localhost/testing property1=value1 property2:=100
```

which is equivalent to

```sh
curl -X POST -H "Content-Type: application/json" -d '{ "property1": "value1", "property2":100 }' http://localhost/testing
```

##### To post with form data

```sh
xh post --auth $CLIENT_ID:$CLIENT_SECRET -b -f https://localhost/connect/token grant_type=client_credentials scope=api
```

where `-b` is to print response body only and `-f` is to serialise data as form
data instead of JSON.

##### To pass a bear token

```sh
xh -A bearer -a $TOKEN http://localhost/testing
```

##### Use header

```sh
xh http://localhost/testing Content-Type:application/json
```

which is equivalent to

```sh
curl -H "Content-Type: application/json" http://localhost/testing
```

##### To show only headers in the output

```sh
xh -h http://localhost/testing
```

which is similar to

```sh
curl -i http://localhost/testing
```

##### To show only response body in the output

```sh
xh -b http://localhost/testing
```

##### Dry run

```sh
xh --offline post http://localhost/testing property1=value1 property2:=100
```
