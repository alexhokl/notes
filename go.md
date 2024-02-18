- [Links](#links)
- [Libraries](#libraries)
  * [Database](#database)
  * [Logging](#logging)
  * [Web](#web)
  * [CLI](#cli)
  * [Unit testing](#unit-testing)
  * [GUI](#gui)
  * [Kafka](#kafka)
  * [Finance](#finance)
  * [Security](#security)
  * [Others](#others)
- [Commands](#commands)
  * [Testing](#testing)
  * [Modules](#modules)
  * [Help](#help)
  * [Vulnerability detection](#vulnerability-detection)
  * [Update installed binaries](#update-installed-binaries)
- [Swagger](#swagger)
- [Language](#language)
  * [Error handling](#error-handling)
  * [main function](#main-function)
  * [Functional options](#functional-options)
  * [Interface](#interface)
  * [Empty interface and pointer](#empty-interface-and-pointer)
  * [Anonymous interface and dynamic function checking](#anonymous-interface-and-dynamic-function-checking)
  * [Pointers and types](#pointers-and-types)
  * [Array, slice, reference and range](#array-slice-reference-and-range)
  * [Maps and pointers](#maps-and-pointers)
  * [Iterator functions](#iterator-functions)
  * [sync.WaitGroup](#syncwaitgroup)
  * [Channels](#channels)
  * [errgroup](#errgroup)
  * [Context](#context)
  * [SIGTERM handling](#sigterm-handling)
  * [panic](#panic)
  * [signal.NotifyContext](#signalnotifycontext)
  * [os.Exit](#osexit)
  * [cmd](#cmd)
  * [Sprintf](#sprintf)
  * [Printf](#printf)
  * [Embed](#embed)
  * [Module](#module)
  * [Unix socket](#unix-socket)
  * [PostgreSQL](#postgresql)
  * [Testing](#testing-1)
  * [io.MultiReader](#iomultireader)
  * [Generics](#generics)
  * [Time](#time)
  * [Call stack](#call-stack)
  * [Build tags](#build-tags)
  * [Logging](#logging-1)
  * [Garbage collection](#garbage-collection)
  * [Cryptography](#cryptography)
- [Charm](#charm)
  * [Bubbletea](#bubbletea)
- [Vs Rust](#vs-rust)
____

## Links

- [Dave Cheney](https://dave.cheney.net/)
- [Practical Go - Dave Cheney](https://dave.cheney.net/practical-go)
- [Testing GO HTTP API](http://dennissuratna.com/testing-in-go/)
- [A Recap of Request Handling in Go](http://www.alexedwards.net/blog/a-recap-of-request-handling)
- [Important interfaces that every Go developer should know](https://www.rzaluska.com/blog/important-go-interfaces/)
- [Grumpy: Go running Python!](https://opensource.googleblog.com/2017/01/grumpy-go-running-python.html)
- [Gopherize.me](https://gopherize.me/)
- [Conference talks from Liz Rice](https://www.lizrice.com/talks)
- [Go Time Podcast](https://changelog.com/gotime)
- [Code review comments](https://github.com/golang/go/wiki/CodeReviewComments)
- [Top Go Web Frameworks](https://github.com/mingrammer/go-web-framework-stars)
- [Programming the Windows
  firewall](https://tailscale.com/blog/windows-firewall/)
- [Go project generator](https://goquick.dev/)

## Libraries

### Database

- [DATA-DOG/go-sqlmock](https://github.com/DATA-DOG/go-sqlmock)
- [go-jet/jet](https://github.com/go-jet/jet) generates `struct`s from a database
  connection but it is not an ORM tool. It also allows serialising data into
  custom `struct` created from the generated `struct`s.
- [go-gorm/gorm](https://github.com/go-gorm/gorm)
- [RadhiFadlillah/sqldiagram](https://github.com/RadhiFadlillah/sqldiagram)
  generates SQL diagram using SQL files - it only supports MySQL
- [czinc/sqlite](https://gitlab.com/cznic/sqlite) SQLite written purely in Go

### Logging

- [uber-go/zap](https://github.com/uber-go/zap) Blazing fast, structured,
  leveled logging in Go
  [example](https://github.com/uber-go/zap/blob/master/example_test.go),
  [FAQ](https://github.com/uber-go/zap/blob/master/FAQ.md)

### Web

- [go-chi/chi](https://github.com/go-chi/chi) lightweight, idiomatic and
  composable router for building Go HTTP services
- [microcosm-cc/bluemonday](https://github.com/microcosm-cc/bluemonday/) a HTML
  sanitizer
- [twitchtv/twirp](https://github.com/twitchtv/twirp) A simple RPC framework
  with protobuf service definitions
- [gin-gonic/gin](https://github.com/gin-gonic/gin) - easy to create web API and
  fast
- [labstack/echo](https://github.com/labstack/echo) - easy to create
  unit-testable web APIs

### CLI

- [spf13/viper](https://github.com/spf13/viper) for application configurations
- [urfave/cli](https://github.com/urfave/cli) for building command line applications
- [cohesivestack/valgo](https://github.com/cohesivestack/valgo) validates user
  input

### Unit testing

- [Fuzz test](https://go.dev/security/fuzz/)
- [leanovate/gopter](https://github.com/leanovate/gopter) property testing

### GUI

- [fyne-io/fyne](https://github.com/fyne-io/fyne) - purely in Go
- [wailsapp/wails](https://github.com/wailsapp/wails) - combining Go and HTML

### Kafka

- [Shopify/sarama](https://github.com/Shopify/sarama) a Go library for Apache
  Kafka 0.8, and up -
  [example](https://github.com/Shopify/sarama/blob/master/examples/http_server/http_server.go)
- [ThreeDotsLabs/watermill/](https://github.com/ThreeDotsLabs/watermill/) - a Go
  library as an abstraction to Kafka or Google Cloud Pub/Sub

### Finance

- [sdcoffey/techan](https://github.com/sdcoffey/techan/) a Technical (Financial)
  Analysis Library for Golang
- [piquette/finance-go](https://github.com/piquette/finance-go) a Financial
  markets data library implemented in go

### Security

- [mattevans/pwned-passwords](https://github.com/mattevans/pwned-passwords) Go
  client library for checking values against compromised HIBP Pwned Passwords
- [xeals/signal-back](https://github.com/xeals/signal-back) Decrypt Signal
  encrypted backups outside the app
- [egbakou/domainverifier](https://github.com/egbakou/domainverifier)
- [alexhokl/go-bb-pr](https://github.com/alexhokl/go-bb-pr) Example on using
  OAuth with CLI

### Others

- [src-d/enry](https://github.com/src-d/enry) A faster file programming language
  detector
- [schachmat/wego](https://github.com/schachmat/wego) weather app for the
  terminal
- [bryanl/manifest-summary](https://github.com/bryanl/manifest-summary) print
  summary of a kubernetes manifest
- [dolthub/swiss](https://github.com/dolthub/swiss) a replacement to built-in
  `map`
- [zephyrtronium/gotools](https://gitlab.com/zephyrtronium/gotools)

## Commands

List of all `GOOS` and `GOARCH` can be found in [`syslist.go`](https://github.com/golang/go/blob/master/src/go/build/syslist.go)


###### To build Windows executable

``` sh
GOOS=windows GOARCH=amd64 go build -o list.exe list.go
```

###### To build without cgo

```sh
CGO_ENABLED=0 go build -v -o helloworld
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

### Testing

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

###### To run fuzz test

```sh
go test -fuzz
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

##### To update dependencies

```sh
go mod tidy
```

##### To create a version

```sh
git tag v1.0.1 && git push --tags
```

### Help

##### To help page of a command

```sh
go help get
```

This shows the help page of command `go get`.

##### To upgrade Go version

```sh
go get golang.org/dl/go1.15.4
go1.15.4 download
```

### Vulnerability detection

```sh
govulncheck ./...
```

### Update installed binaries

```sh
gotools -u
```

## Swagger

##### To generate a client from an API specification

```sh
git clone https://github.com/swagger-api/swagger-codegen
cd swagger-codegen
./run-in-docker.sh mvn package
./run-in-docker.sh generate -i https://developers.strava.com/swagger/swagger.json -l go -o generated/go
```

or using `oapi-codegen`

```sh
oapi-codegen -package yourpackage -generate client swagger.json > proxy.go
```

##### To generate a server

```sh
oapi-codegen -package yourpackage -generate server swagger.json > server.go
```

## Language

### Error handling

Wrapping error messages to give more information

```go
func Something() error {
  if err := someProcess(); err != nil {
    return fmt.Errorf("more error information: %w", err)
  }
  return nil
}
```

Note that `%w` is different from `%v` in that it gives a chance for higher level
code which invokes `Something` to check the type of `err` (which could be
a complicated `struct` implements `error` interface).

### main function

To handle error better, a slim `main` function can be written. This also allows
the program can be tested easily.

```go
const (
  // exitFail is the exit code if the program fails
  exitFail = 1
)

func main() {
  if err := run(os.Args, os.Stdout); err != nil {
    fmt.Fprintf(os.Stderr, "%s\n", err)
    os.Exit(exitFail)
  }
}

func run(args []string, stdout io.Writer) error {
  // ...
}
```

Reference: [Why you shouldn't use func main in
Go](https://pace.dev/blog/2020/02/12/why-you-shouldnt-use-func-main-in-golang-by-mat-ryer.html)

### Functional options

Reference: [Functional options for friendly
APIs](https://dave.cheney.net/2014/10/17/functional-options-for-friendly-apis)

A common pattern is used to create a new object is to pass in a configuration
object. For example,

```go
type Config struct {
  one string
  two string
}

func main() {
  config, _ := parseArguments(os.Args)
  mandatoryParameter := os.Args[1]
  instance, _ := NewInstance(mandatoryParameter, config)
  // ...
}
```

The above approach made it difficult to handle mandatory parameters and optional
parameters. Validations are much harder (although not impossible) to be done.
Optional configuration object has to be prepared by caller regardless.

Using functional options gives the following advantages.

- The number of options can grow easily over time (instead of growing
  configuration object
- It makes the default use case to be the simplest
- It provides meaningful configuration parameters
- It gives access to initialize complex values

```go
func NewInstance(mandatoryParameter string, options ...func(*Instance)) (*Instance, error) {
  i := &Instance{mandatoryParameter: mandatoryParameter}
  for _, o := range options {
    if err := o(i); err != nil {
      return nil, err
    }
  }
  return i, nil
}

func Debug(i *Instance) error {
  return i.setDebugMode()
}

func Limit(int limit) func(*Instance) error {
  return func(i *Instance) error {
    if limit <= 0 {
      return fmt.Errorf("Limit must be positive but it was %d", limit)
    }
    return i.setLimit(limit)
  }
}

func parseArguments(args []string) ([]func(*Instance) error) {
  var options []func(*Instance) error
  if args[2] == "debug" {
    options = append(options, Debug)
  }

  if args[3] == 'limit' {
    options = append(options, Limit(args[4]))
  }
  return options
}

func main() {
  options, _ := parseArguments(os.Args)
  mandatoryParameter := os.Args[1]
  instance, _ := NewInstance(mandatoryParameter, ...options)
  // ...
}
```

Note that `Limit` helps adapting the signature to what required as an option.
All functions except `main` can live in another package (and makes things as
clean as using a configuration object).

### Interface

It is always prefer to have less methods in an interface to make it precise and
easier to implement. Big interface can be created by composing using smaller
interfaces.

Usually interface is named with what its functions do. For instance, `io.Writer`
has function `Write`.

Although name of arguments and return values used in an interface are not
enforced in the types that implement the interface, it is encouraged to name
them to enhance documentation.

Parameters of functions of an interface should be a type of lowest common
denominator. For instance, if it is a choice between `string` and `byte[]`,
`[]byte` should be used as it can be implemented by more types.

Pointers can be passed to functions implementing a non-pointer method. For
instance,

```go
type Stringer interface {
  String() string
}

type Something struct {}

func (s Something) String() string {
  return "something"
}

func main() {
  s := &Something{}
  fmt.Println(s.String())
  // this compiles and should display "something"
}
```

### Empty interface and pointer

```go
func main() {
	var ptr *string
	fmt.Println("ptr", ptr)
	fmt.Println("ptr is null", ptr == nil, "(expected true)")
	fmt.Println("function return:", notNil(ptr), "(expected false)")
}

func notNil(i interface{}) bool {
	fmt.Println("function parameter i:", i)
	return i != nil
}
```

Output

```
ptr <nil>
ptr is null true (expected true)
function parameter i: <nil>
function return: true (expected false)
```

A variable of interface contains the following two items

- a pointer to the actual type (`*rtype`)
- a pointer to the data (`unsafe.Pointer`)

In the example above, when the pointer is passed as `interface{}` variable,
a pointer to type `string` is store and the data is null. Thus, the variable is
never `== nil` although its value can be `nil`.

Thus, function parameters of interface type should not be a pointer as a normal
interface parameter can accept both pointer and value. Function receiver (the
parameter before function name) is the only exception. (see [Go interfaces and
pointers](https://medium.com/@saiyerram/go-interfaces-pointers-4d1d98d5c9c6))

For examples on pointers, see
[alexhokl/go-pointers](https://github.com/alexhokl/go-pointers)

### Anonymous interface and dynamic function checking

Reference: see section `... and anonymous interfaces` in [Golang Quirks
& Intermediate Tricks, Pt 1: Declarations, Control Flow,
& Typesystem](https://eblog.fly.dev/quirks.html)

Checking whether a function exist on an object can be made via anonymous
interface. The following example shows checking of function `Flush` and `Sync`
which are not include in interface `io.Writer`.

```go
import "gzip"
func writeZipped(w io.Writer, b []byte) (int, error) {
    zipw := gzip.NewWriter(w)
    n, err := zipw.Write(w)
    if err != nil {
        return n, err
    }
    if err := zipw.Close(); err != nil {
        return err
    }
    // flush the underlying buffer, if there is one
    if f, ok := w.(interface{Flush() error}); ok {
        _ = f.Flush()
    }
    // sync to disk if possible
    if f, ok := w.(interface{Sync() error}); ok {
        _ = f.Sync()
    }
}
```

### Pointers and types

Reference: [Golang Quirks & Tricks, Pt 2](https://eblog.fly.dev/quirks2.html)

The following program prints as follows.

```go
func main() {  // https://go.dev/play/p/io4pUcl2oiS

 for _, t := range []any{
  "",
  new(string),
  any(nil),
  io.Writer(new(bytes.Buffer)),
  io.Writer(io.Discard),
  (*io.Writer)(&io.Discard),
  (*any)(nil),
 } {
  fmt.Println(reflect.TypeOf(t))
 }
}
```

```
string
*string
<nil>
*bytes.Buffer
io.discard
*io.Writer
*interface {}
```

Note that `any` is an alias to `interface{}` (since Go 1.18).

### Array, slice, reference and range

Reference: [Go Slices: usage and internals](https://go.dev/blog/slices-intro)

Declarations of array and slice are different.

```go
array := [3]int{1,2,3}
anotherArray := [...]int{1,2,3}
slice := []int{1,2,3}
anotherSlice := make([]int)
```

Array is a value type while slice is a reference type.

```go
s1 := []int{20}
s2 := s1
s2[0] = 60

if s1[0] != 60 {
  panic("")
}

a1 := [...]int{20}
a2 := a1
a2[0] = 60

if a1[0] != 20 {
  panic("")
}

fmt.Println("No panics")
```

Length and capacity of a slice

```go
len(slice)
cap(slice)
```

Note that capacity is the number of elements in the underlying array but
counting from the beginning position of the slice. A slice cannot be grown
beyond its capacity. Attempting to do so will cause a runtime panic.

For reference,
[slice](https://github.com/golang/go/blob/master/src/runtime/slice.go#L15) is
defined as

```go
type slice struct {
    array unsafe.Pointer
    len int
    cap int
}
```

Function `append()` may or may not create a new copy of an array (which the
specified slice is referring to) depending on the capacity of the slice
specified. If the slice has enough capacity, no new array will be created;
created, otherwise. Thus, if we know the size we needed beforehand, it is
important to use `make(slice, beginIndex, size)` to ensure enough memory is
allocated.

Create a slice of `[]*Item` from array of `Item`

```go
var slice []*TodoItem
for i := range array {
  slice = append(slice, &array[i])
}
```

Note that the following does not work as value from `range` is a copied value
not a reference.

```go
var slice []*TodoItem
for _, v := range array {
  slice = append(slice, &v)
}
```

There are times that copy should be considered to allow release of large block
of memory sooner. If `Find` in the following example does not copy but simply
return a slice, the returned slice would keep a reference to the original byte
array which could hold a large file.

```go
var digitRegexp = regexp.MustCompile("[0-9]+")

func FindDigits(filename string) []byte {
    b, _ := ioutil.ReadFile(filename)
    return digitRegexp.Find(b)
}

func FindAndCopyDigits(filename string) []byte {
    b, _ := ioutil.ReadFile(filename)
    b = digitRegexp.Find(b)
    c := make([]byte, len(b))
    copy(c, b)
    return c
}
```

#### Initialisation of object being applied range

```go
fib := []int{0, 1}
for i, f1 := range fib {
  f2 := fib[i+1]
  fib = append(fib, f1+f2)
  if f1+f2 > 100 {
    break
  }
}
fmt.Println(fib)
```

The following code does not produce a Fibonacci sequence just over 100 but `[0
1 1 2]` instead. It is due to `fib` was of size `2` at the time `range` was
applied. It implies `i` would never reach `2` although `fib` array does expand
properly to size of `4` by the end of the algorithm.

### Maps and pointers

`map` is a reference object to the underlying `hmap` hash map object.

### Iterator functions

Signature of of iterator function of `Item`.

```go
func (yield func(Item) bool)
```

`range` will be responsible for implementation of function `yield` and iterator
function needs to feed `yield` with a value of `Item`. When yield returns false,
it implies `range` has been completed and it is the time for cleanup, if
necessary.

An example usage.

```go
package main

import "fmt"

type Item int

func main() {
	for i := range iterateItems {
		fmt.Println(i)
	}
}

func iterateItems(yield func(Item) bool) {
  items := []Item{1, 2, 3}
  for _, v := range items {
    if !yield(v) {
        return
    }
  }
}
```

Note that this is available after version `1.22` and `GOEXPERIMENT=rangefunc` is
required.

### sync.WaitGroup

```go
func notify(services ...string) {
  var wg sync.WaitGroup

  for _, service := range services {
    wg.Add(1)
    go func(s string) {
      defer wg.Done()
      fmt.Printf("Starting to notifing %s...\n", s)
      time.Sleep(time.Duration(rand.Intn(3)) * time.Second)
      fmt.Printf("Finished notifying %s...\n", s)
    }(service)
  }

  wg.Wait()
  fmt.Println("All services notified!")
}
```

### Channels

```go
func notify(services ...string) {
  res := make(chan string)
  count := 0

  for _, service := range services {
    count++
    go func(s string) {
      fmt.Printf("Starting to notifying %s...\n", s)
      time.Sleep(time.Duration(rand.Intn(3)) * time.Second)
      res <- fmt.Sprintf("Finished %s", s)
    }(service)
  }

  for i := 0; i < count; i++ {
    fmt.Println(<-res)
  }

  fmt.Println("All services notified!")
}
```

#### Channels and range

`range` over a channel returns one value (unlike two values for an array).

```go
ch := make(chan int)

// ...

for value := range ch {
  fmt.Println(value)
}
```

#### Direction of channel parameters

By default, if direction of a channel is not specified, it is bidirectional.

```go
func useChannels(a chan int, b <- chan int, c chan <- int)
```

where `a` is a bidirectional channel, `b` is an output channel, `c` is an input
channel.

### errgroup

`errgroup` can be found in package `golang.org/x/sync/errgroup`.

Note that `Wait()` returns on the first routine which returns an error.

```go
func notify(services ...string) {
  var g errgroup.Group

  for _, service := range services {
    // Copy the value from the service variable into a local variable to
    // avoid a common bug with closure inside a loop
    s := service
    g.Go(func() error {
      fmt.Printf("Starting to notifing %s...\n", s)
      time.Sleep(time.Duration(rand.Intn(3)) * time.Second)
      fmt.Printf("Finished notifying %s...\n", s)
      return nil // or a real error if we had one
    })
  }

  err := g.Wait()
  if err != nil {
    fmt.Printf("Error notifying services: %v\n", err)
    return
  }
  fmt.Println("All services notified successfully!")
}
```

### Context

- [Go Concurrency Patterns: Context](https://go.dev/blog/context)
- [Go Concurrency Patterns: Pipelines and
  cancellation](https://go.dev/blog/pipelines)
- [context package](https://pkg.go.dev/context)

#### HTTP server

```go
// A Context carries a deadline, cancellation signal, and request-scoped values
// across API boundaries. Its methods are safe for simultaneous use by multiple
// goroutines.
type Context interface {
    // Done returns a channel that is closed when this Context is canceled
    // or times out.
    Done() <-chan struct{}

    // Err indicates why this context was canceled, after the Done channel
    // is closed.
    Err() error

    // Deadline returns the time when this Context will be canceled, if any.
    Deadline() (deadline time.Time, ok bool)

    // Value returns the value associated with key or nil if none.
    Value(key interface{}) interface{}
}

// WithCancel returns a copy of parent whose Done channel is closed as soon as
// parent.Done is closed or cancel is called.
func WithCancel(parent Context) (ctx Context, cancel CancelFunc)

// A CancelFunc cancels a Context.
type CancelFunc func()

// WithTimeout returns a copy of parent whose Done channel is closed as soon as
// parent.Done is closed, cancel is called, or timeout elapses. The new
// Context's Deadline is the sooner of now+timeout and the parent's deadline, if
// any. If the timer is still running, the cancel function releases its
// resources.
func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)

// WithValue returns a copy of parent whose Value method returns val for key.
func WithValue(parent Context, key interface{}, val interface{}) Context
```

- each incoming request is handled in its own goroutine
- interface `Context` helps
  * passing value to one process to another process of the same request or its
    sub-routines
  * passing cancellation or timeout signals to a request and its sub-routines
- interface `Context` does not have a `Cancel` method since it is meant to be
  read-only (or receive-only) as demonstrated by `Done` method
  * the function receiving a cancellation signal is usually not the one that
    sends the signal
  * when a parent operation starts goroutines for sub-operations, those
    sub-operations should not be able to cancel the parent
  * instead, `WithCancel` function provides a way to cancel a new `Context`
    value
  * `Context` is safe for simultaneous use by multiple goroutines
    + code can pass a single `Context` to any number of goroutines and cancel
      that `Context` to signal all of them
- `context` package provides functions to derive new `Context` values from
  existing ones these values form a tree
  * when a `Context` is canceled, all `Context`s derived from it are also
    canceled
- `context.Background()` is the root of any `Context` tree
  * it is never cancelled
- `WithCancel` and `WithTimeout` return derived `Context` values that can be
  canceled sooner than the parent `Context`
- passing `Context` to a function effectively is passing `Done` channel to it
  * the function can then check if `Done` channel has been closed to decide to
    continue on with its work
- for a client making HTTP requests, an HTTP request can be added with `Context`
  via `WithContext` to allow cancellation control

### SIGTERM handling

```go
package main

import (
  "fmt"
  "os"
  "os/signal"
  "syscall"
)

func main() {

  sigs := make(chan os.Signal, 1)
  done := make(chan bool, 1)

  signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

  go func() {
    sig := <-sigs
    fmt.Println()
    fmt.Println(sig)
    done <- true
  }()

  fmt.Println("awaiting signal")
  <-done
  fmt.Println("exiting")
}
```

Note that hitting `ctrl` `c` is equivalent to sending `SIGINT`. `SIGTERM` is
usually sent from an operation system.

Also note that `SIGKILL` cannot be handled as it kills the process immediately.

### panic

`panic` does take care of the existing `defer` calls.

### signal.NotifyContext

```go
package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"time"
)

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	p, err := os.FindProcess(os.Getpid())
	if err != nil {
		log.Fatal(err)
	}

	// On a Unix-like system, pressing Ctrl+C on a keyboard sends a
	// SIGINT signal to the process of the program in execution.
	//
	// This example simulates that by sending a SIGINT signal to itself.
	if err := p.Signal(os.Interrupt); err != nil {
		log.Fatal(err)
	}

	select {
	case <-time.After(time.Second):
		fmt.Println("missed signal")
	case <-ctx.Done():
		fmt.Println(ctx.Err()) // prints "context canceled"
		stop()                 // stop receiving signal notifications as soon as possible.
	}

}
```

### os.Exit

- It does not cover any existing `defer` calls.
- It does stop all existing go routines.

### cmd

`cmd` creates a sub process instead of a sub-routine. Thus, when ending a parent
program, the sub process will not be cleaned up automatically and code has to be
written to handle that.

### Sprintf

##### Bytes

When bytes are included, casting to `string` is not necessary. That is, the
following should be used

```go
fmt.Sprintf("%s", byteslice)
```

instead of

```go
fmt.Sprintf("%s", string(byteslice))
```

##### Options

[String formatting options](https://gobyexample.com/string-formatting)

### Printf

- [A Deep Dive into fmt Printf in
  Golang](https://www.kosli.com/blog/a-deep-dive-into-fmt-printf-in-golang/)
  - format specifiers
    * `%t` - boolean values
  - escaping characters
    * `\a`  Alert or bell
    * `\b`  Backspace
    * `\t`  Horizontal tab
    * `\n`  New line
    * `\f`  Form feed
    * `\r`  Carriage return
    * `\v`  Vertical tab
    * `\'` Single quote (only in rune literals)
    * `\"` Double quote (only in string literals)
    * `\\` single slash
    * `%%` single percent
  - printing complex types
    * `%v` default representation of data
      - example
        - `[Mike David George]`
        - `{Michael 25}`
    * `%#v` Go's default representation of data
      - example
        - `[]string{"Mike", "David", "George"}`
        - `main.person{name:"Michael", age:25}`
    * `%+v` a representation between `%v` and `%#v`
      - example
        - `{name:Michael age:25}`
    * `%T` type of object

### Embed

A SQL file can be embedded for reading later

```go
import (
  _ "embed"
)

var (
  //go:embed sql/user_posts.sql
  queryUserPosts string
)

rows, err := db.Query(queryUserPosts, userID)
```

where `sql/user_post.sql` could be something like

```sql
SELECT users.email,
  posts.id,
  posts.title
FROM posts
  JOIN users ON posts.user_id = users.id
WHERE users.id = $1;
```

### Module

##### Testing a module locally

Use `replace` in `go.mod`

```go
module github.com/acme/foo

go 1.12

require (
	github.com/acme/bar v1.0.0
)

replace github.com/acme/bar => /path/to/local/bar
```

### Unix socket

- [alexhokl/unix-socket-test](https://github.com/alexhokl/unix-socket-test)

### PostgreSQL

- [PG advisory locks in Go with built-in
  hashes](https://brandur.org/fragments/pg-advisory-locks-with-go-hash) similar
  application lock in MSSQL

### Testing

#### Normal unit testing

```go
func TestValidateDate(t *testing.T) {
	tests := []struct {
		name          string
		str           string
		expectedError error
	}{
		{
			name:          "valid RFC3339 date",
			str:           "2022-11-21T05:00:00Z",
			expectedError: nil,
		},
		{
			name:          "invalid RFC3339 date",
			str:           "2022-11-21",
			expectedError: errors.New("invalid date format"),
		},
	}

	for _, test := range tests {
		testName := fmt.Sprintf(test.name, test.str)
		t.Run(testName, func(t *testing.T) {
			actualErr := ValidateDate(test.str)
			if actualErr != test.expectedError {
				if !strings.Contains(actualErr.Error(), test.expectedError.Error()) {
					t.Errorf("expected error %v, got %v", test.expectedError, actualErr)
				}
				return
			}
		})
	}
}
```

#### Fuzz testing

```go
func FuzzEnglish(f *testing.F) {
  f.Add(5, "five")
  f.Fuzz(func(t *testing.T, i int, s string) {
    out, err := English(i, s)
    if err != nil && out != "" {
      t.Errorf("%q, %v", out, err)
    }
  })
}
```

- There must be exactly one fuzz target per fuzz test.
- Fuzzing argument can only be primitive types.

### io.MultiReader

Function `io.MultiReader` takes multiple readers and returns a single
`io.Reader` which reads the list of readers sequentially.

One of the use cases is to read multiple files at the same time. Assuming
`files` is an array of readers connected to structured log files in `JSON`, the
following reads all the logs.

```go
logReader := io.MultiReader(files...)
dec := json.NewDecoder(logReader)
```

Another use case is to read some part of the file with one `io.Reader` and read
rest of the file with another `io.Reader`. This gives a chance where, when logic
applies, the program can choose not to read all of the file bytes.

```go
func checkContentType(r io.Reader) ([]byte, error) {
  buf := make([]byte, 512)
  n, err := r.Read(buf)
  if err != nil {
    return nil, err
  }
  contentType := http.DetectContentType(buf[:n])
  if contentType != "image/png" {
    return nil, fmt.Errorf("unexpected content type: %s", contentType)
  }
  return buf[:n], nil
}

func CreateImage(r io.Reader, filename string) error {
	readBytes, err := checkContentType(r)
	if err != nil {
		return err
	}
	f, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer f.Close()
	r = io.MultiReader(bytes.NewReader(readBytes), r)
	_, err = io.Copy(f, r)
	return nil
}
```

### Generics

The following function caters most of the integer types.

```go
func Min[T uint | int | int64](a, b T) T {
  if a < b {
    return a
  }
  return b
}
```

However, it would not work for `Duration` defined as

```go
type Duration int64
```

To cater types like `Duration`, operator `~` can be used.

```go
func Min[T ~uint | ~int | ~int64](a, b T) T {
  if a < b {
    return a
  }
  return b
}
```

In this particular case, package `constraints` can also be used.

```go
func Min[T constraints.Integer](a, b T) T {
  if a < b {
    return a
  }
  return b
}
```

#### Inferred types

The following example shows when Go unable infer generic types.

```go
func As1[FROM, TO any](f FROM) TO {
     return *(*TO)(unsafe.Pointer(&f)) // we'll conver unsafe later in this article.
}

func main() { // https://go.dev/play/p/no9apPCbMAX
    b := As1[uint64, [8]byte](4)
    fmt.Println(b)
}
```

Go is not able to guess (infer) the type of the second parameter from the call
to `As1`.

The following example shows when Go can infer generic types.

```go
func As2[TO, FROM any](f FROM) TO { // https://go.dev/play/p/50PexocApZy
 return *(*TO)(unsafe.Pointer(&f))
}
func main() {
    b := As2[[8]byte](4)
     fmt.Println(b)
}
```

The second parameter can be guessed as it can be inferred from function
parameter. Thus, only the first type parameter needs to be specified.

### Time

- Use `.Equals` instead of `==` to compare Time objects.

### Call stack

```go
func Logged[T any](t T) T {
    _, file, line, _ := runtime.Caller(1) // 1 = caller of Logged
    fmt.Printf("%s:%d: %T: %v\n", file, line, t, t)
    return t
}
```

where `runtime.Caller(skip int)` returns the caller in the call stack.

### Build tags

`main.go`

```go
package main
import "fmt"
// a is not defined here: it's in either a.go or not_a.go
func main() {
    if a {
        fmt.Println("a")
    } else {
        fmt.Println("!a")
    }
}
```

`a.go`

```go
//go:build a
package main
const a = true
```

`not_a.go`

```go
//go:build not_a
package main
const a = false
```

The following will generate different builds.

```sh
go build --tags a -o positive
go build --tags not_a -o negative
```

Multiple tags can also be applied. Here is the syntax.

```go
//go:build a && b
//go:build a || b
```

### Logging

- [log/slog](https://go.dev/blog/slog)
- [Resources of slog](https://github.com/golang/go/wiki/Resources-for-slog)
- [jussi-kalliokoski/slogdriver](https://github.com/jussi-kalliokoski/slogdriver)
  to send logs to GCP Cloud logging
- [ttys3/slogx](https://github.com/ttys3/slogx/) to send logs to OpenTelemetry
  collector
- [samber/slog-gin](https://github.com/samber/slog-gin)

### Garbage collection

The vast majority of the time the Go runtime performs garbage collection
concurrently with the execution of your program. This means that the GC is
running at the same time as your program.

There are two points in the GC process where the Go runtime needs to stop every
Goroutine. This is required to ensure data integrity. These usually takes in the
order of tens of microseconds.

- Before the Mark Phase of the GC the runtime stops every Goroutine to apply the
  write barrier, this ensures no objects created after this point are garbage
  collected. This phase is known as Sweep Termination.
- After the mark phase has finished there is another stop the world phase, this
  is known as Mark Termination and the same process happens to remove the write
  barrier.

When the Go runtime starts it creates an OS thread for each CPU core. The
problem is that the Go runtime is not aware of the CGroup CPU limits and will
happily schedule goroutines on all OS threads. Long stop the world durations
arise from the Go runtime needing to stop Goroutine on threads that it’s waiting
for the Linux Scheduler to schedule. These threads will not be scheduled once
the container has used it’s CPU quota.

Go allows you to limit the number of CPU threads that the runtime will create
using the `GOMAXPROCS` environment variable. The result of using the variable
correctly would be the garbage collection is much shorter, despite having the
exact same load.

The following explains how the variable can be configured (which can be passed
as an environment variable in `docker run`)

### Cryptography

A recent package [crypto/ecdh](https://pkg.go.dev/crypto/ecdh) can be used to
generated private and public key pairs. Interface `Curve` contains functions to
generate private key from a random number (where `crypto/rand.Reader` is
recommended) and to generate public key from a private key.

```sh
GOMAXPROCS=max(1, floor(CPUs))
```

## Charm

### Bubbletea

#### Debugging with Delve

[Reference](https://github.com/charmbracelet/bubbletea#debugging-with-delve)

Start a headless debugger (due to no access to `stdin` and `stdout`)

```sh
$ dlv debug --headless .
```

Assuming the port used by the headless Open another terminal

```sh
dlv connect 127.0.0.1:34241
```

#### Logging

```go
if len(os.Getenv("DEBUG")) > 0 {
	f, err := tea.LogToFile("debug.log", "debug")
	if err != nil {
		fmt.Println("fatal:", err)
		os.Exit(1)
	}
	defer f.Close()
}
```

## Vs Rust

Reference: [Vercel - Why Turborepo is migrating from Go to
Rust](https://vercel.com/blog/turborepo-migration-go-rust)

Go's strength is network computing in data centers and it excels at this task,
powering these workloads at the world's largest scales. The
goroutine-per-request model, Context API, and the standard library inclusion of
server infrastructure is testament to this community focus.

Additionally, Go favors simplicity over expressiveness. A side effect of that
decision means more errors are caught at runtime where other languages might
catch them at compilation. With a service running in a data center, you can roll
back, fix, and roll forward at your convenience. But, when building software
that users install, the cost of each mistake is higher.

The Rust language and community has prioritized correctness over API
abstraction—a tradeoff that we care a lot about when working with:

- Process management
- Filesystems
- Other low level OS concepts
- Shipping software to our users' machines

This means additional complexity is surfaced into our codebase, but it's
necessary complexity for the problems we're trying to solve.

Rust's type system and safety features allow us to put guardrails in place in
our codebase where we need them. The language's expressiveness allows our
developers to encode constraints that catch errors at compile time rather than
in GitHub issues.

#### Example

Go's preference for simplicity at the filesystem was creating problems for us
when it came to file permissions. Go lets users set a Unix-style file permission
code: a short number that describes who can read, write, or execute a file.

While this sounds convenient, this abstraction does not work across platforms;
Windows actually doesn't have the precise concept of file permissions. Go ends
up allowing us to set a file permission code on Windows, even when doing so will
have no effect.

In contrast, Rust's explicitness in this area not only made things simpler for
us but also more correct. If you want to set a file permission code in Rust, you
have to explicitly annotate the code as Unix-only. If you don't, the code won't
even compile on Windows. This surfacing of complexity helps us understand what
our code is doing before we ever ship our software to users.

