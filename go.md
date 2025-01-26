- [Links](#links)
- [Libraries](#libraries)
  * [AI](#ai)
  * [CLI](#cli)
  * [Configuration](#configuration)
  * [Database](#database)
  * [Documentation](#documentation)
  * [Finance](#finance)
  * [GUI](#gui)
  * [JSON](#json)
  * [Kafka](#kafka)
  * [Logging](#logging)
  * [PDF](#pdf)
  * [Protobuf](#protobuf)
  * [Security](#security)
  * [Source control](#source-control)
  * [Visualisation](#visualisation)
  * [Unit testing](#unit-testing)
  * [Web](#web)
  * [Others](#others)
- [Configuration](#configuration-1)
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
  * [init](#init)
  * [Functional options](#functional-options)
  * [Interface](#interface)
  * [Empty interface and pointer](#empty-interface-and-pointer)
  * [Anonymous interface and dynamic function checking](#anonymous-interface-and-dynamic-function-checking)
  * [Pointers and types](#pointers-and-types)
  * [Array, slice, reference and range](#array-slice-reference-and-range)
  * [Maps and pointers](#maps-and-pointers)
  * [Iterator functions](#iterator-functions)
  * [Goroutine](#goroutine)
  * [sync.WaitGroup](#syncwaitgroup)
  * [Channels](#channels)
  * [Semaphore](#semaphore)
  * [errgroup](#errgroup)
  * [pkg/group](#pkggroup)
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
  * [Range over function](#range-over-function)
  * [Time](#time)
  * [Timer](#timer)
  * [Call stack](#call-stack)
  * [Build tags](#build-tags)
  * [Logging](#logging-1)
  * [Garbage collection](#garbage-collection)
  * [Cryptography](#cryptography)
  * [HTTP server](#http-server-1)
  * [Type alias](#type-alias)
  * [Tools](#tools)
  * [Multiline string](#multiline-string)
  * [Vendoring](#vendoring)
  * [JSON marshalling](#json-marshalling)
  * [Protobuf](#protobuf-1)
- [Charm](#charm)
  * [Bubbletea](#bubbletea)
- [Ko](#ko)
  * [Commands](#commands-1)
- [Vs Rust](#vs-rust)
___

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
- [Go for Experienced
  Programmers](https://github.com/jboursiquot/go-for-experienced-programmers/wiki)

## Libraries

### AI

- [andrewstuart/openai](https://github.com/andrewstuart/openai) OpenAI API
  wrapper
- [mdelapenya/generative-ai-with-testcontainers](https://github.com/mdelapenya/generative-ai-with-testcontainers)
  demonstrates how to leverage Testcontainers Go for building and testing
  generative AI applications

### CLI

- [spf13/viper](https://github.com/spf13/viper) for application configurations
- [urfave/cli](https://github.com/urfave/cli) for building command line applications
- [cohesivestack/valgo](https://github.com/cohesivestack/valgo) validates user
  input
- [charmbracelet/huh](https://github.com/charmbracelet/huh) a library for
  building interactive TUI

### Configuration

- [chasinglogic/appdirs](https://github.com/chasinglogic/appdirs) - find
  platform-specific directories

### Database

- [DATA-DOG/go-sqlmock](https://github.com/DATA-DOG/go-sqlmock)
- [go-jet/jet](https://github.com/go-jet/jet) generates `struct`s from a database
  connection but it is not an ORM tool. It also allows serialising data into
  custom `struct` created from the generated `struct`s.
- [go-gorm/gorm](https://github.com/go-gorm/gorm)
- [RadhiFadlillah/sqldiagram](https://github.com/RadhiFadlillah/sqldiagram)
  generates SQL diagram using SQL files - it only supports MySQL
- [czinc/sqlite](https://gitlab.com/cznic/sqlite) SQLite written purely in Go

### Documentation

- [swaggo/gin-swagger](https://github.com/swaggo/gin-swagger) - gin middleware
  to automatically generate RESTful API documentation with Swagger 2.0

### Finance

- [sdcoffey/techan](https://github.com/sdcoffey/techan/) a Technical (Financial)
  Analysis Library for Golang
- [piquette/finance-go](https://github.com/piquette/finance-go) a Financial
  markets data library implemented in go

### GUI

- [fyne-io/fyne](https://github.com/fyne-io/fyne) - purely in Go
  * [introduction](https://www.youtube.com/watch?v=sXKsyuSjJ8o)
  * cross-platform (including mobile) compilation is available
- [wailsapp/wails](https://github.com/wailsapp/wails) - combining Go and HTML

### JSON

- [orsinium/valdo](https://github.com/orsinium-labs/valdo) - JSON validation for
  API and it can generate OpenAPI schema

### Kafka

- [Shopify/sarama](https://github.com/Shopify/sarama) a Go library for Apache
  Kafka 0.8, and up -
  [example](https://github.com/Shopify/sarama/blob/master/examples/http_server/http_server.go)
  * from Slack Engineering, it sounds like there were a few bugs in some edge
    cases
- [ThreeDotsLabs/watermill/](https://github.com/ThreeDotsLabs/watermill/) - a Go
  library as an abstraction to Kafka or Google Cloud Pub/Sub
- [confluentinc/confluent-kafka-go](https://github.com/confluentinc/confluent-kafka-go)
  a library better than `sarama`

### Logging

- [uber-go/zap](https://github.com/uber-go/zap) Blazing fast, structured,
  leveled logging in Go
  [example](https://github.com/uber-go/zap/blob/master/example_test.go),
  [FAQ](https://github.com/uber-go/zap/blob/master/FAQ.md)

### PDF

- [ledongthuc/pdf](https://github.com/ledongthuc/pdf) read texts from PDF file

### Protobuf

- [grpc-ecosystem/grpc-gateway](https://github.com/grpc-ecosystem/grpc-gateway)
  it generates a reverse-proxy server which translates a RESTful JSON API into
  gRPC; this is useful as the same protobuf file can be used to generate both
  gRPC server and RESTful JSON API server (which is the proxy); see `option
  (google.api.http)` and import of `google/api/annotations.proto` in `README.md`
  of the repository
- [grpc-ecosystem/go-grpc-middleware](https://github.com/grpc-ecosystem/go-grpc-middleware)
  allows logging, OpenTelemetry, and other middleware to be added to gRPC
  server; it can also be used to generate OpenAPI schema v2 (not v3)

### Security

- [mattevans/pwned-passwords](https://github.com/mattevans/pwned-passwords) Go
  client library for checking values against compromised HIBP Pwned Passwords
- [xeals/signal-back](https://github.com/xeals/signal-back) Decrypt Signal
  encrypted backups outside the app
- [egbakou/domainverifier](https://github.com/egbakou/domainverifier)
- [securego/gosec](https://github.com/securego/gosec) - security checker

### Source control

- [alexhokl/go-bb-pr](https://github.com/alexhokl/go-bb-pr) Example on using
  OAuth with CLI
- [gomods/athens](https://github.com/gomods/athens) - a Go module datastore and
  proxy; [summary](https://engineering.grab.com/go-module-proxy)

### Visualisation

- [ajstarks/dchart](https://github.com/ajstarks/dchart) both a Go library and
  binary to generate XML files in deck (a language to draw visualisation).
  Visualisation (in `png` or `pdf`) can then be generated by using other commands
  such as `pngdeck` or `pdfdeck`.
  * [ajstarks/deck/cmd/pngdeck](https://github.com/ajstarks/deck/cmd/pngdeck)
  * [ajstarks/deck/cmd/pdfdeck](https://github.com/ajstarks/deck/cmd/pdfdeck)
- [ajstarks/decksh](https://github.com/ajstarks/decksh) a binary to generate
  deck files (a language to draw visualisation) from scripts. The deck files can
  then be used to generate slides.

### Unit testing

- [Fuzz test](https://go.dev/security/fuzz/)
- [leanovate/gopter](https://github.com/leanovate/gopter) property testing
- [frankban/quicktest](https://github.com/frankban/quicktest) a helper library
  for assertions in tests
- [DATA-DOG/go-sqlmock](https://github.com/DATA-DOG/go-sqlmock) for mocking SQL
  database connection `sql/driver`
  * [example using gorm without
    assertions](https://tanutaran.medium.com/golang-unit-testing-with-gorm-and-sqlmock-postgresql-simplest-setup-67ccc7c056ef)
- [testing a Gin endpoint](https://gin-gonic.com/docs/testing/)

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
- [golangci/golangci-lint](https://golangci-lint.run/) - linter for Go

## Configuration

- `GOMEMLIMIT`
  * reference: [A Guide to the Go Garbage
    Collector](https://tip.golang.org/doc/gc-guide)
  * introduced since 1.19
  * without this limit set, Go garbage collector (after each GC cycle) picks
    a total heap size proportional to the live heap size without considering the
    memory available to the system
    + the proportion is determined by environment variable `GOGC` and its
      default value is `100`
  * setting this to too a values could introduce a scenario called thrashing
    where the garbage collector is running continuously and consumes all the CPU
    but it does not throw an out-of-memory error
    + thus, it is worst than having an out-of-memory error
  * this is a soft limit to GC to avoid thrashing
    + Go ignore this limit if GC comsume too much CPU
  * good use-cases
    + deployment to a container
  * bad use-cases
    + heap size is likely very close to the memory limit to be set (which can
      results in thrashing)
  * examples
    + `export GOMEMLIMIT=250MiB`

## Commands

List of all `GOOS` and `GOARCH` can be found in
[`syslist.go`](https://github.com/golang/go/blob/master/src/go/build/syslist.go)


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

###### To test with race detector

```sh
go test -race -v ./...
```

###### To run benchmarking tests

```sh
go test -bench=.
```

Note that, by default, it benchmarks on CPU only.

Note that `.` after `-bench` is a regular expression to match the name of the
test (not test file).

To benchmark on both CPU and memory,

```sh
go test -bench=. -benchmem
```

To create profile at the same time,

```sh
$ go test -bench=BenchmarkFindPalindromes \
	-count=10 \
	-benchmem \
	-memprofile ./benchmarking/wordlens/benchmarks/unoptimized.mem.prof \
	-cpuprofile ./benchmarking/wordlens/benchmarks/unoptimized.cpu.prof \
	./benchmarking/wordlens/unoptimized | tee ./benchmarking/wordlens/benchmarks/unoptimized.bench.txt
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

### init

`init` function is used to initialise a package. It is called after all the
variables in the package have been initialised. This behaviour is difficult to
understand and it is not recommended to use `init` function.

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
has function `Write`. The naming convention is to suffix with `er`.

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

#### Internal interface only specify part of the public interface

Assuming the public interface is defined as following.

```go
type PublicWriter interface {
  A()
  B()
  C()
  D()
}
```

and also assuming we only use/care about function `C`, we can define an internal
interface.

```go
type internalWriter interface {
  C()
}
```

In this way a type can easily implement the internal interface for testing.

```go
type TestWriter struct {}

func (t TestWriter) C() {
  fmt.Println("C")
}
```

But the actual type can be satisfied as well.

```go
actualWriter := publicpackage.NewWriter()
actualWriter.C()
```

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

### Goroutine

- resource management
  * stopping a goroutine and releasing all resources associated with it
    + it is hard to implement in practice
  * notify the goroutine to stop
    + it might take a bit of time for a goroutine to stop even it received
      a signal (it has nothing do with how the code is written but the scheduler
      of Go)
    + a goroutine can hold up resources due to its waiting of IO (be it network
      or file or even `stdout` if there is a lot of lines)

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

#### nil channel

reference: [nil
channels](https://www.campoy.cat/blog/justforfunc-26-nil-chans/)

- by default, a closed channel returns its defualt value; thus, a `string`
  channel returns `""`, an `int` channel returns `0`, etc.
  * thus, `ok` should be checked as in `v, ok := <- c`
- for output channel, if it is not closed, it could cause a deadlock; thus,
  `defer close(c)` should be used to ensure the channel is closed
- a close channel does not blocks; thus, to finish the channel, it should be set
  to `nil`

#### server timeout

```go
func greetHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("Handling greeting request")
	defer log.Println("Handled greeting request")

	completeAfter := time.After(5 * time.Second)

	for {
		select {
		case <-completeAfter:
			fmt.Fprintln(w, "Hello Gopher!")
			return
		default:
			time.Sleep(1 * time.Second)
			log.Println("Greetings are hard. Thinking...")
		}
	}
}

func main() {
	http.HandleFunc("/", greetHandler)
	log.Println("Server listening on :8080...")
	log.Fatal(http.ListenAndServe("127.0.0.1:8080", nil))
}
```

`time.After` returns a channel that will send a signal after the specified time.

#### handling request cancellation

```go
func greetHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("Handling greeting request")
	defer log.Println("Handled greeting request")

	completeAfter := time.After(5 * time.Second)
	ctx := r.Context()

	for {
		select {
		case <-completeAfter:
			fmt.Fprintln(w, "Hello Gopher!")
			return
		case <-ctx.Done():
			err := ctx.Err()
			log.Printf("Context Error: %s", err.Error())
			return
		default:
			time.Sleep(1 * time.Second)
			log.Println("Greetings are hard. Thinking...")
		}
	}
}

func main() {
	http.HandleFunc("/", greetHandler)
	log.Println("Server listening on :8080...")
	log.Fatal(http.ListenAndServe("127.0.0.1:8080", nil))
}
```

The key is to handle `Done` channel of the context object of request object.

#### Worker pool

Reference: [Go by Example: Worker Pools](https://gobyexample.com/worker-pools)

```go
listOfInputs := []int{1, 2, 3, 4, 5}
numWorkers := runtime.NumCPU()
inputsChan := make(chan int, numWorkers) // assuming imput type is int
resultsChan := make(chan int) // assuming result type is int

for i := 0; i < cap(inputsChan); i++ { // numWorkers also acceptable here
  // initialise workers but the work would not start until inputs are sent from
  // inputsChan channel
  go worker(otherParameters, inputsChan, resultsChan)
}

go func() {
  for _, p := range listOfInputs {
    inputsChan <- p
  }
}()

var results []int
for i := 0; i < len(listOfInputs); i++ {
  if p := <-resultsChan; p != 0 { // non-zero port means it's open
    results = append(results, p)
  }
}

close(inputsChan)
close(resultsChan)

fmt.Println("RESULTS")
sort.Ints(results)
for _, p := range results {
  fmt.Printf("%d\n", p)
}
```

where `worker` contains the actual logic of the work.

### Semaphore

The advantage of using semaphore could be avoiding the use of channels in some
of the cases which leads to more readable code.

#### Basic

```go
listOfInputs := []int{1, 2, 3, 4, 5}
numWorkers := runtime.NumCPU()

sem := semaphore.NewWeighted(int64(numWorkers))
results := make([]int, 0)
ctx := context.TODO()

for _, i := range listOfInputs {
  if err := sem.Acquire(ctx, 1); err != nil {
    fmt.Printf("Failed to acquire semaphore: %v", err)
    break
  }

  go func(input int) {
    defer sem.Release(1)
    p := worker(otherParameters, input)
    if p != 0 {
      results = append(results, p)
    }
  }(i)
}

// We block here until done.
if err := sem.Acquire(ctx, int64(numWorkers)); err != nil {
  fmt.Printf("Failed to acquire semaphore: %v", err)
}

fmt.Println("RESULTS")
sort.Ints(results)
for _, p := range results {
  fmt.Printf("%d\n", p)
}
```

where `worker` contains the actual logic of the work.

#### With timeout

```go
listOfInputs := []int{1, 2, 3, 4, 5}
numWorkers := runtime.NumCPU()

sem := semaphore.NewWeighted(int64(numWorkers))
results := make([]int, 0)
ctx, cancel := context.WithTimeout(context.Background(), time.Duration(timeout)*time.Second)
defer cancel()

for _, i := range listOfInputs {
  if err := sem.Acquire(ctx, 1); err != nil {
    fmt.Printf("Failed to acquire semaphore: %v", err)
    break
  }

  go func(input int) {
    defer sem.Release(1)
    p := worker(otherParameters, input)
    if p != 0 {
      results = append(results, p)
    }
  }(i)
}

// We block here until done.
if err := sem.Acquire(ctx, int64(numWorkers)); err != nil {
  fmt.Printf("Failed to acquire semaphore: %v", err)
}

fmt.Println("RESULTS")
sort.Ints(results)
for _, p := range results {
  fmt.Printf("%d\n", p)
}
```

where `worker` contains the actual logic of the work.

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

### pkg/group

- [pkg/group](https://github.com/pkg/group)
  * [examples](https://github.com/pkg/group/blob/main/example_test.go)
- this can be better than `errgroup` as goroutines using `errgroup` needs to
  have access to the group and handle it
  * in constrast, `group` is transparent to goroutines
- `group` allows passing of `context.Context` object to goroutines and goroutines
  can normal flow control using the context object

To handle timeout within a goroutine

```go
ctx := context.Background()
g := group.New(group.WithContext(ctx))
g.Add(func(c context.Context) error {
  select {
  case <-c.Done():
    return c.Err()
  case <-time.After(1 * time.Second):
    return errors.New("timed out")
  }
})

// Wait for all goroutines to finish.
if err := g.Wait(); err != nil {
  fmt.Println(err)
}
```

To handle error within a goroutine

```go
ctx := context.Background()
g := group.New(group.WithContext(ctx))
g.Add(func(_ context.Context) error {
  return errors.New("startup error")
})

// Wait for all goroutines to finish.
if err := g.Wait(); err != nil {
  fmt.Println(err)
}
```

To handle external signal to goroutines

```go
ctx := context.Background()
g := group.New(group.WithContext(ctx))
shutdown := make(chan struct{})
g.Add(func(c context.Context) error {
  select {
  case <-c.Done():
    return c.Err()
  case <-shutdown:
    return errors.New("timed out")
  }
})

time.AfterFunc(1*time.Second, func() {
  close(shutdown)
})

// Wait for all goroutines to finish.
if err := g.Wait(); err != nil {
  fmt.Println(err)
}
```

To handle SIGTERM signal in multiple goroutines

```go
ctx := context.Background()
ctx, _ = signal.NotifyContext(ctx, os.Interrupt)

g := group.New(group.WithContext(ctx))

g.Add(MainHTTPServer)
g.Add(DebugHTTPServer)
g.Add(AsyncLogger)

<-time.After(100 * time.Millisecond)

// simulate ^C
proc, _ := os.FindProcess(os.Getpid())
proc.Signal(os.Interrupt)

if err := g.Wait(); err != nil {
  fmt.Println(err)
}
```

### Context

- [Go Concurrency Patterns: Context](https://go.dev/blog/context)
- [Go Concurrency Patterns: Pipelines and
  cancellation](https://go.dev/blog/pipelines)
- [context package](https://pkg.go.dev/context)
- one of the functionalities is to provide an API to pass data between function
  calls without keep changing the function signature; some data could be
  relatively "global" and use of global variable is avoided
- another functionality is to provide a way to cancel a function call and its
  sub-routines; for example, before a database query is made, `Context` object
  should be checked if cancellation signal has been sent
- another functionality is to provide a way to set a deadline for a function
  call and its sub-routines
- `Context` object is immutable; it is safe to pass it to multiple goroutines;
  and it is only additively modified
- `context.TODO()` should be used when the function to be invoked has `Context`
  as a parameter but the current function does not have a `Context` object to
  pass
- keys should be a non-exported type alias instead of a string or int to avoid
  collision with other packages
- good candidates as values
  * database transaction handles
  * per-transation object caches
  * side effect buffers
    + such as those for writing events to a message queue

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

If there is a lot of properties involved or the object is very nested,
`DeepEqual` can be used instead.

```go
if !reflect.DeepEqual(tc.want, got) {
  t.Fatalf("expected: %v, got: %v", tc.want, got)
}
```

`reflect.DeepEqual` compares unexported fields as well. If only exported fields
should be compared or more complex logic is needed package
`github.com/google/go-cmp/cmp` can be used (see
[examples](https://github.com/google/go-cmp/blob/master/cmp/example_test.go).

#### Parallel testing

```go
t.Parallel()
```

indicates that preparation has been completed and the code followed can be run
in parallel. It implies that test scheduler will wait for all the test reach
this `t.Parallel()` before running them in parallel.

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

#### Benchmarking

```go
func fib(n int) int {
	if n < 2 {
		return n
	}
	return fib(n-1) + fib(n-2)
}

func benchFib(i int, b *testing.B) {
	for n := 0; n < b.N; n++ {
		fib(i)
	}
}

func BenchmarkFib1(b *testing.B) { benchFib(1, b)}
func BenchmarkFib10(b *testing.B) { benchFib(10, b)}
func BenchmarkFib20(b *testing.B) { benchFib(20, b)}
```

To get only CPU benchmarks,

```sh
go test -bench=.
```

Note that `.` after `-bench` is a regular expression to match the name of the
test (not test file).

To get CPU and memory benchmarks,

```sh
go test -bench=. -benchmem
```

To create profile at the same time,

```sh
$ go test -bench=BenchmarkFindPalindromes \
	-count=10 \
	-benchmem \
	-memprofile ./benchmarking/wordlens/benchmarks/unoptimized.mem.prof \
	-cpuprofile ./benchmarking/wordlens/benchmarks/unoptimized.cpu.prof \
	./benchmarking/wordlens/unoptimized | tee ./benchmarking/wordlens/benchmarks/unoptimized.bench.txt
```

To check the profile generated,

```sh
go tool pprof ./benchmarking/wordlens/benchmarks/unoptimized.cpu.prof
```

It is an interactive tool. To get a list of commands, type `help`. Command `top`
shows the hotspots (where CPU or memory usage is high) of the program.

To get a more readable output in terminal,

```sh
benchstat -filter ".unit:(sec/op)" \
		unoptimized=./benchmarking/wordlens/benchmarks/unoptimized.bench.txt
```

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

### Range over function

- added since Go `1.23`
- range over function that take a single argument and the argument must itself
  be a function that takes zero to two arguments and returns a `bool`
  * by convention, the function is identified as yield function
  * signatures
    + `func (yield func() bool)`
    + `func (yield func(V) bool)`
    + `func (yield func(K, V) bool)`
  * typically, yield function is specified by user of `range` and invoked by an
    iterator
- standard iterators are push iterators
  * since it pushes out a sequence of values by calling a yield function
```go
package iter
type Seq[V any] func(yield func(V) bool)
type Seq2[K, V any] func(yield func(K, V) bool)
```
  * example
```go
// All is an iterator over the elements of s.
func (s *Set[E]) All() iter.Seq[E] {
    return func(yield func(E) bool) {
        for v := range s.m {
            if !yield(v) {
                // clean up here if needed
                return
            }
        }
    }
}
```
  * how does it work
    + for some sequence of values, they call a yield function with each value in
      the sequence. If the yield function returns `false`, no more values are
      needed, and the iterator can just return, doing any cleanup that may be
      required. If the yield function never returns false, the iterator can just
      return after calling yield with all the values in the sequence.
  * As a matter of convention, it is encouraged that all container types to
    provide an `All` method that returns an iterator, so that programmers do not
    have to remember whether to range over `All` directly or whether to call
    `All` to get a value they can range over. They can always do the latter.
- pull iterators
  * it is a function that is written such that each time you call it, it returns
    the next value in the sequence
  * it is not supported directly by the `for`/`range` statement; however, it is
    straightforward to write an ordinary `for` statement that loops through a
    pull iterator
  * since there is no way to force the yield function to return `false`, a stop
    function is needed
    + strictly speaking you do not need to call the stop function if the pull
      iterator returns false to indicate that it has reached the end of the
      sequence, but it is usually simpler to just always call it
    + an example on reporting whether two arbitrary sequences contain the same
      elements in the same order
      + note that there is no `for`/`range` involved
```go
func EqSeq[E comparable](s1, s2 iter.Seq[E]) bool {
    next1, stop1 := iter.Pull(s1)
    defer stop1()
    next2, stop2 := iter.Pull(s2)
    defer stop2()
    for {
        v1, ok1 := next1()
        v2, ok2 := next2()
        if !ok1 {
            return !ok2
        }
        if ok1 != ok2 || v1 != v2 {
            return false
        }
    }
}
```
- iterator examples
  * an example on filtering
    + note that the first arugment is the fucntion defined by the user to
      perform the actual filtering logic
```go
func Filter[V any](f func(V) bool, s iter.Seq[V]) iter.Seq[V] {
    return func(yield func(V) bool) {
        for v := range s {
            if f(v) {
                if !yield(v) {
                    return
                }
            }
        }
    }
}
```
  * an example on binary tree
```go
type Tree[E any] struct {
    val   E
    left  *Tree[E]
    right *Tree[E]
}

func (t *Tree[E]) All() iter.Seq[E] {
    return func(yield func(E) bool) {
        t.push(yield)
    }
}

func (t *Tree[E]) push(yield func(E) bool) bool {
    if t == nil {
        return true
    }
    return t.left.push(yield) &&
        yield(t.val) &&
        t.right.push(yield)
}
```
- updates in slice and maps package since Go `1.23`
  * functions work with iterators
    + slice package
      + `All([]E) iter.Seq2[int, E]`
      + `Values([]E) iter.Seq[E]`
      + `Collect(iter.Seq[E]) []E`
      + `AppendSeq([]E, iter.Seq[E]) []E`
      + `Backward([]E) iter.Seq2[int, E]`
      + `Sorted(iter.Seq[E]) []E`
      + `SortedFunc(iter.Seq[E], func(E, E) int) []E`
      + `SortedStableFunc(iter.Seq[E], func(E, E) int) []E`
      + `Repeat([]E, int) []E`
      + `Chunk([]E, int) iter.Seq([]E)`
    + maps package
      + `All(map[K]V) iter.Seq2[K, V]`
      + `Keys(map[K]V) iter.Seq[K]`
      + `Values(map[K]V) iter.Seq[V]`
      + `Collect(iter.Seq2[K, V]) map[K, V]`
      + `Insert(map[K, V], iter.Seq2[K, V])`
  * examples
    + an example on filtering
```go
// LongStrings returns a slice of just the values
// in m whose length is n or more.
func LongStrings(m map[int]string, n int) []string {
    isLong := func(s string) bool {
        return len(s) >= n
    }
    return slices.Collect(Filter(isLong, maps.Values(m)))
}
```
    + an example on iterating over lines in a file
      + the original (inefficient) way
```go
nl := []byte{'\n'}
// Trim a trailing newline to avoid a final empty blank line.
for _, line := range bytes.Split(bytes.TrimSuffix(data, nl), nl) {
    handleLine(line)
}
```
      + the new (efficient) way
```go
func Lines(data []byte) iter.Seq[[]byte] {
    return func(yield func([]byte) bool) {
        for len(data) > 0 {
            line, rest, _ := bytes.Cut(data, []byte{'\n'})
            if !yield(line) {
                return
            }
            data = rest
        }
    }
}

for line := range Lines(data) {
    handleLine(line)
}
```

### Time

- Use `.Equals` instead of `==` to compare Time objects.

### Timer

```go
shutdown := make(chan struct{})
time.AfterFunc(5*time.Second, func() {
  close(shutdown)
})
```

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
- [m-mizutani/masq](https://github.com/m-mizutani/masq) - a redacting utility to
  conceal sensitive data for slog

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

### HTTP server

Reference: [How I write HTTP services in Go after 13
years](https://grafana.com/blog/2024/02/09/how-i-write-http-services-in-go-after-13-years/)

```go
// Validator is an object that can be validated.
type Validator interface {
	// Valid checks the object and returns any
	// problems. If len(problems) == 0 then
	// the object is valid.
	Valid(ctx context.Context) (problems map[string]string)
}

func main() {
	ctx := context.Background()
	if err := run(ctx, os.GetEnv, os.Stdin, os.Stdout, os.Stderr, os.Args); err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err)
		os.Exit(1)
	}
}

func run(ctx context.Context, getenv func(string) string, stdin io.Reader, stdout, stderr io.Writer, args []string) error {
  ctx, cancel := signal.NotifyContext(ctx, os.Interrupt)
	defer cancel()

  logger := NewLogger()
  config := LoadConfig()
  store := NewStore()

  srv := NewServer(logger, config, store)
  httpServer := &http.Server{
    Addr:    net.JoinHostPort(config.Host, config.Port),
    Handler: srv,
  }

  go func() {
    log.Printf("listening on %s\n", httpServer.Addr)
    if err := httpServer.ListenAndServe(); err != nil && err != http.ErrServerClosed {
      fmt.Fprintf(os.Stderr, "error listening and serving: %s\n", err)
    }
  }()

  var wg sync.WaitGroup
  wg.Add(1)

  go func() {
    defer wg.Done()
    <-ctx.Done()
    // make a new context for the Shutdown (thanks Alessandro Rosetti)
    shutdownCtx := context.Background()
    shutdownCtx, cancel := context.WithTimeout(shutdownCtx, 10 * time.Second)
    defer cancel()
    if err := httpServer.Shutdown(shutdownCtx); err != nil {
      fmt.Fprintf(os.Stderr, "error shutting down http server: %s\n", err)
    }
  }()
  wg.Wait()
  return nil
}

func NewServer(logger *Logger, config *Config, store *Store) {
  mux := http.NewServeMux()
	addRoutes(mux, logger, config, stored)
	var handler http.Handler = mux
	handler = someMiddleware(handler)
	handler = someMiddleware2(handler)
	handler = someMiddleware3(handler)
	return handler
}

func addRoutes(mux *http.ServeMux, logger *Logger, config *Config, store *Store) {
  mux.Handle("/api/v1/", handleGet(logger, store))
	mux.Handle("/", http.NotFoundHandler())
}

func handleGet(logger *Logger, store *Store) http.Handler {
	thing := prepareThing()
	return http.HandlerFunc(
		func(w http.ResponseWriter, r *http.Request) {
			// use thing to handle request
			logger.Info(r.Context(), "msg", "handleGet")
		}
	)
}

func decodeValid[T Validator](r *http.Request) (T, map[string]string, error) {
	var v T
	if err := json.NewDecoder(r.Body).Decode(&v); err != nil {
		return v, nil, fmt.Errorf("decode json: %w", err)
	}
	if problems := v.Valid(r.Context()); len(problems) > 0 {
		return v, problems, fmt.Errorf("invalid %T: %d problems", v, len(problems))
	}
	return v, nil, nil
}
```

#### Handling endpoint dependencies

##### Using closure

```go
func CreateTweet(db *sql.DB, creatorID int, content string) (*Tweet, error) {
  row := db.QueryRow("INSERT INTO tweets ...")
  // more code to follow
}

func CreateTweetHandler(db *sql.DB) http.HandlerFunc {
  return func(w http.ResponseWriter, r *http.Request) {
    return func(w http.ResponseWriter, r *http.Request) {
      creatorID, content := parseForm(r)
      tweet, err := CreateTweet(db, creatorID, content)
      if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
      }
      json.NewEncoder(w).Encode(tweet)
    }
  }
}
```

##### Using a dependency struct

This can be considered when there are multiple dependencies.

```go
type TweetStorage struct {
  db *sql.DB
}

func (ts *TweetStorage) CreateTweet(creatorID int, content string) (*Tweet, error) {
  row := ts.db.QueryRow("INSERT INTO tweets ...")
  // more code to follow
}
```

### Type alias

#### Creating a type

The following are two distinct types.

```go
type Celsius float64
type Fahrenheit float64
```
It improves type safety by preventing us from accidentally passing `Celsius` to
a function expecting `Fahrenheit`.

When creating a type definition, it contains the fields of the underlying data
type but not its method.

#### Creating a type alias

```go
type Celsius = float64
type Manager = Employee
type Pair[T any] = oldpkg.Pair[T]
```

Type alias is particularly useful during a refactoring process where renaming is
planned.

### Tools

Dependencies not built into the final executable (or non-production) used to
managed by adding `tools.go` with content like the following.

```go
import (
  _ gitHub.com/username/some_package;
)
```

Since version `1.24`, command `tool` can be used instead.

##### To add a tool

```sh
go get -tool go.uber.org/mock/mockgen@latest
```

##### To list tools

```sh
go tool
```

##### To update all tools

```sh
go get -u tool
```

##### To install all tools

```sh
go install tool
```

### Multiline string

```go
` This is an example
    with tab intentation.`
```

### Vendoring

Create a directory `vendor` in the root directory.

The dependencies can be copied to the `vendor` directory with the directory
hierarchy of something like `github.com/username/package`.

The directory should be in source control as this replaces the process of
pulling packages from the internet during the build process.

### JSON marshalling

- it does not marshal unexported (private) fields and, thus, unexported fields
  will be initialised with its default value
  * an exception is with embbedded struct where all the fields are considered as
    exported and, thus, those embedded fields will be marshalled

### Protobuf

- printing it can change the state of protobuf instance, thus, calling `Reset()`
  would be required for further operations

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

## Ko

- This is tool to build Docker images of Go executable without Docker.
- It build images from `gcr.io/distroless/static:nonroot`
  * no shell
  * no other executables
  * it has
    + CA certificates
    + timezone data

### Commands

##### To build a Docker image locally

```sh
KO_DOCKER_REPO=gcr.io/YOUR_PROJECT/my-app KO ko build -L .
```

To replace image name in Kubernetes manifests

```sh
ko resolve -f deployment.yml | kubectl apply -f -
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

