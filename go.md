# Go

### Links

- [Dave Cheney](https://dave.cheney.net/)
- [Testing GO HTTP API](http://dennissuratna.com/testing-in-go/)
- [A Recap of Request Handling in Go](http://www.alexedwards.net/blog/a-recap-of-request-handling)
- [Important interfaces that every Go developer should know](https://www.rzaluska.com/blog/important-go-interfaces/)
- [Grumpy: Go running Python!](https://opensource.googleblog.com/2017/01/grumpy-go-running-python.html)

### Libraries

- [DATA-DOG/go-sqlmock](https://github.com/DATA-DOG/go-sqlmock)
- [uber-go/zap](https://github.com/uber-go/zap) Blazing fast, structured, leveled logging in Go
- [go-chi/chi](https://github.com/go-chi/chi) lightweight, idiomatic and composable router for building Go HTTP services
- [spf13/viper](https://github.com/spf13/viper) for application configurations
- [urfave/cli](https://github.com/urfave/cli) for building command line applications
- [gorilla/websocket](https://github.com/gorilla/websocket)
- [leanovate/gopter](https://github.com/leanovate/gopter) property testing
- [Shopify/sarama](https://github.com/Shopify/sarama) a Go library for Apache Kafka 0.8, and up

### Tricks

- Use `.Equals` instead of `==` to compare Time objects.

### Commands

List of all `GOOS` and `GOARCH` can be found in [`syslist.go`](https://github.com/golang/go/blob/master/src/go/build/syslist.go)


###### To build Windows executable on Mac

``` sh
GOOS=windows GOARCH=amd64 go build -o list.exe list.go
```

###### To build with ldflags

Assuming there is string global variable `version`defined in package `cmd`

```sh
go build -ldflags "-X github.com/alexhokl/rds-backup/cmd.version=$(git
rev-parse --short HEAD)"
```

###### To check if any errors that is not handled

```sh
errcheck
```

###### To format the code

```sh
go fmt -d main.go
```

###### To test a project

```sh
go test ./...
```

###### To list all the tests in a project

```sh
go test -test.list .
```
