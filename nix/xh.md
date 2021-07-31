
____
##### Posting with JSON payload

```sh
xh post http://localhost/testing property1=value1 property2:=100
```

which is equivalent to

```sh
curl -X POST -H "Content-Type: application/json" -d '{ "property1": "value1", "property2":100 }' http://localhost/testing
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
xh --headers http://localhost/testing
```

which is similar to

```sh
curl -i http://localhost/testing
```

##### Dry run

```sh
xh --offline post http://localhost/testing property1=value1 property2:=100
```
