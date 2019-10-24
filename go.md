- [Go](#go)
    + [Links](#links)
    + [Libraries](#libraries)
    + [Tricks](#tricks)
    + [Commands](#commands)
    + [Modules](#modules)
____

# Go

### Links

- [Dave Cheney](https://dave.cheney.net/)
- [Testing GO HTTP API](http://dennissuratna.com/testing-in-go/)
- [A Recap of Request Handling in Go](http://www.alexedwards.net/blog/a-recap-of-request-handling)
- [Important interfaces that every Go developer should know](https://www.rzaluska.com/blog/important-go-interfaces/)
- [Grumpy: Go running Python!](https://opensource.googleblog.com/2017/01/grumpy-go-running-python.html)
- [Gopherize.me](https://gopherize.me/) 
- [Conference talks from Liz Rice](https://www.lizrice.com/talks)

### Libraries

- [DATA-DOG/go-sqlmock](https://github.com/DATA-DOG/go-sqlmock)
- [uber-go/zap](https://github.com/uber-go/zap) Blazing fast, structured, leveled logging in Go [example](https://github.com/uber-go/zap/blob/master/example_test.go), [FAQ](https://github.com/uber-go/zap/blob/master/FAQ.md)
- [go-chi/chi](https://github.com/go-chi/chi) lightweight, idiomatic and composable router for building Go HTTP services
- [spf13/viper](https://github.com/spf13/viper) for application configurations
- [urfave/cli](https://github.com/urfave/cli) for building command line applications
- [gorilla/websocket](https://github.com/gorilla/websocket)
- [leanovate/gopter](https://github.com/leanovate/gopter) property testing
- [Shopify/sarama](https://github.com/Shopify/sarama) a Go library for Apache Kafka 0.8, and up [example](https://github.com/Shopify/sarama/blob/master/examples/http_server/http_server.go)
- [sdcoffey/techan](https://github.com/sdcoffey/techan/) a Technical (Financial) Analysis Library for Golang
- [piquette/finance-go](https://github.com/piquette/finance-go) a Financial markets data library implemented in go
- [mattevans/pwned-passwords](https://github.com/mattevans/pwned-passwords) Go client library for checking values against compromised HIBP Pwned Passwords
- [twitchtv/twirp](https://github.com/twitchtv/twirp) A simple RPC framework with protobuf service definitions
- [src-d/enry](https://github.com/src-d/enry) A faster file programming language detector
- [xeals/signal-back](https://github.com/xeals/signal-back) Decrypt Signal encrypted backups outside the app
- [schachmat/wego](https://github.com/schachmat/wego) weather app for the terminal
- [bryanl/manifest-summary](https://github.com/bryanl/manifest-summary) print summary of a kubernetes manifest

### Tricks

- Use `.Equals` instead of `==` to compare Time objects.
- Function parameters of interface type should not be a pointer as a normal
  interface parameter can accept both pointer and value. Function receiver (the
  parameter before function name) is the only exception. (see [Go interfaces
  and pointers](https://medium.com/@saiyerram/go-interfaces-pointers-4d1d98d5c9c6))

### Commands

List of all `GOOS` and `GOARCH` can be found in [`syslist.go`](https://github.com/golang/go/blob/master/src/go/build/syslist.go)


###### To build Windows executable

``` sh
GOOS=windows GOARCH=amd64 go build -o list.exe list.go
```

###### To build with ldflags

Assuming there is string global variable `version` defined in package `cmd`

```sh
go build -ldflags "-X github.com/alexhokl/rds-backup/cmd.version=$(git rev-parse --short HEAD)"
```

###### To build and install locally

```sh
go install
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

###### To test a project and view its test coverage

```sh
go test -cover ./...
```

###### To test a project and show its test coverage profile

```sh
go test -coverprofile=cover.out ./... && go tool cover -html=cover.out
```

###### To list all the tests in a project

```sh
go test -test.list .
```

###### To test all files with a short test results

```sh
go test --short all
```

### Modules

###### To list all module dependencies

```sh
go list -m all
```

###### To retrieve a specific version of library

```sh
go get library@version
```

###### To create a module

```sh
go mod init
```

##### To list all packages created in the current directory

```sh
go list ./...
```

##### To list all modules created in the current directory

```sh
go list -m ./...
```

##### To list all installed packages

```sh
go list all
```

##### To help page of a command

```sh
go help get
```

This shows the help page of command `go get`.
