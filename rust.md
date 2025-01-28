- [References](#references)
- [Libraries](#libraries)
  * [GUI](#gui)
- [Commands](#commands)
- [Language](#language)
  * [Declarations](#declarations)
  * [Control flow](#control-flow)
  * [Ownership](#ownership)
  * [References](#references-1)
  * [Compound data type](#compound-data-type)
  * [Packages, crates and modules](#packages-crates-and-modules)
  * [Collections](#collections)
  * [String and string slice](#string-and-string-slice)
  * [Hash map](#hash-map)
  * [Error handling](#error-handling)
  * [Generics](#generics)
  * [Traits](#traits)
  * [Lifetimes (Generics Lifetimes)](#lifetimes-generics-lifetimes)
  * [Testing](#testing)
  * [CLI](#cli)
  * [Closures](#closures)
  * [Iterators](#iterators)
  * [Documentation](#documentation)
  * [Crate](#crate)
  * [Cargo workspace](#cargo-workspace)
  * [Smart pointers](#smart-pointers)
  * [Concurrency (and parallelism)](#concurrency-and-parallelism)
  * [Object-oriented programming](#object-oriented-programming)
  * [Pattern matching](#pattern-matching)
  * [Advanced types](#advanced-types)
  * [Advanced functions and closures](#advanced-functions-and-closures)
  * [Marcos](#marcos)
  * [Others](#others)
____

## References

- [The Rust Programming Language](https://doc.rust-lang.org/book/)
  - [Keywords](https://doc.rust-lang.org/book/appendix-01-keywords.html)
  - [Operators and
    Symbols](https://doc.rust-lang.org/book/appendix-02-operators.html)
  - [Derivable
    Traits](https://doc.rust-lang.org/book/appendix-03-derivable-traits.html)
- [Rust playground](https://play.rust-lang.org/)
- [Comprehensive Rust](https://google.github.io/comprehensive-rust/) - a
  training course
- [rust-embedded/rust-raspberrypi-OS-tutorials](https://github.com/rust-embedded/rust-raspberrypi-OS-tutorials)
  learn to write an embedded OS in Rust (on Raspberry Pi)

## Libraries

### GUI

- [Yew](https://yew.rs/)
- [iced-rs/iced](https://github.com/iced-rs/iced) inspired by Elm

## Commands

##### To create a new package

```sh
cargo new package_name
```

or, to create a library

```sh
cargo new package_name --lib
```

This will create package in path `./package_name`.

```sh
cargo init
```

This will create a new package in the currect directory instead. The current
directory name will be used as the package name.

Both commands create a `git` respository by default.

##### To compile and build an executable

```sh
rustc main.rs
```

If `Cargo.toml` exists,

```sh
cargo build
```

where executable `./main` will be created

To build for release,

```sh
cargo build --release
```

##### To check if there is any compilation errors with producing a build

```sh
cargo check
```

##### To execute a program

```sh
cargo run
```

To run with arguments

```sh
cargo run 123 456
```

##### To run tests

```rust
cargo test
```

or, to run tests with name contains the argument

```rust
cargo test add
```

where it runs all tests with name contains `add`.

##### To generate documentation

```sh
cargo doc --open
```

##### To publish a crate

```sh
cargo publish
```

## Language

#### Common libraries

- `std::env`

### Declarations

##### Immutable variables by default

Declaration `let text:String = "abc"` is immutable by default.

To modify variable, declare it like `let mut text:String = "abc"`.

##### Un-used variable

By adding underscore

```rust
let _result = io::stdin().read_line(&mut guess);
```

##### Constant

```rust
const NAME_CONVENTION: String = "prefix_";
```

Note that type must be declared.

### Control flow

##### Loop

```rust
loop {
  println!("this loop won't quit!")
}
```

To return a value

```rust
let mut counter = 0;
let reuslt = loop {
  count += 1;
  if counter == 5 {
    break counter;
  }
};
```

##### While loop

```rust
let mut counter = 0;
while counter == 5{
  count += 1;
};
```

##### For loop

```rust
let a = [10, 20, 30];
for num in a.iter() {
  println!("number: {}", num);
};
```

##### One-liner if

```rust
let condition = true;
let number = if condition { 1 } else { 0 };
```

### Ownership

- stack stores values in the order it gets them and removes the values in the
  opposite order (FIFO)
- all data stored on the stack must have a known, fixed size
- data with an unknown size at compile time or a size that might change must be
  stored on the heap instead
- pushing to the stack is faster than allocating on the heap because the
  allocator never has to search for a place to store new data; that location is
  always at the top of the stack
  - allocating space on the heap requires more work, because the allocator must
    first find a big enough space to hold the data and then perform bookkeeping
    to prepare for the next allocation
  - accessing data in the heap is slower than accessing data on the stack
    because you have to follow a pointer to get there
- when your code calls a function, the values passed into the function and the
  function’s local variables get pushed onto the stack; when the function is
  over, those values get popped off the stack
- the main purpose of ownership is to manage heap data
- rules
  - each value in Rust has a variable that’s called its owner
  - there can only be one owner at a time
  - when the owner goes out of scope, the value will be dropped
- there is no deep copy in Rust
  - rather than shadow copy, it is more like a move due to transfer of ownership

##### stack copy (which does not involve ownership)

```rust
fn main() {
    let x = 5;
    let y = x;
}
```

Transfer of ownership of heap memory

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1;
}
```

where pointers in stack are copied but the ownership has been transferred from
`s1` to `s2`. Note that `s1` is no longer valid after `s2 = s1`.

##### Functions

```rust
fn main() {
    let s = String::from("hello");  // s comes into scope

    takes_ownership(s);             // s's value moves into the function...
                                    // ... and so is no longer valid here

    let x = 5;                      // x comes into scope

    makes_copy(x);                  // x would move into the function,
                                    // but i32 is Copy, so it's okay to still
                                    // use x afterward

} // Here, x goes out of scope, then s. But because s's value was moved, nothing
  // special happens.

fn takes_ownership(some_string: String) { // some_string comes into scope
    println!("{}", some_string);
} // Here, some_string goes out of scope and `drop` is called. The backing
  // memory is freed.

fn makes_copy(some_integer: i32) { // some_integer comes into scope
    println!("{}", some_integer);
} // Here, some_integer goes out of scope. Nothing special happens.
```

```rust
fn main() {
    let s1 = gives_ownership();         // gives_ownership moves its return
                                        // value into s1

    let s2 = String::from("hello");     // s2 comes into scope

    let s3 = takes_and_gives_back(s2);  // s2 is moved into
                                        // takes_and_gives_back, which also
                                        // moves its return value into s3
} // Here, s3 goes out of scope and is dropped. s2 was moved, so nothing
  // happens. s1 goes out of scope and is dropped.

fn gives_ownership() -> String {             // gives_ownership will move its
                                             // return value into the function
                                             // that calls it

    let some_string = String::from("yours"); // some_string comes into scope

    some_string                              // some_string is returned and
                                             // moves out to the calling
                                             // function
}

// This function takes a String and returns one
fn takes_and_gives_back(a_string: String) -> String { // a_string comes into scope
    a_string  // a_string is returned and moves out to the calling function
}
```

### References

- to avoid transfer of ownership
- the action of creating a reference is called borrowing

```rust
fn main() {
    let s1 = String::from("hello");

    let len = calculate_length(&s1);

    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

##### Mutable reference

- there can be only one mutable reference to a particular piece of data at
  a time

```rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

where as the following code would not compile

```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &mut s;
    let r2 = &mut s;

    println!("{}, {}", r1, r2);
}
```

### Compound data type

##### Tuple

```rust
let key_value = ("KEY", 10);
let key = key_value.0
let value = key_value.1
```

##### Array

```rust
let error_codes = [400, 401, 403, 409, 500];
let conflict = error_codes[3];
```

##### Enum

```rust
enum IpAddressVersion{
  V4(u8, u8, u8, u8),
  V6(String),
}

impl IpAddressVersion {
  fn pretty_print(&self) {
    match self {
      IpAddressVersion::V4(a, b, c, d) => {
        println!("{}.{}.{}.{}", a, b, c, d);
      },
      IpAddressVersion::V6(addr) => {
        println!("{}", addr);
      }
    }
  }
}

fn main() {
  let localhost = IpAddressVersion::V4(127, 0, 0, 0);
  let remote = IpAddressVersion::V6(String::from("fe80::42:dfff:fed6:9bb0"));
  localhost.pretty_print();
  remote.pretty_print();
}
```

Note that `match` statement must exhause all possible values.

There are no `null` in Rust and `Option<T>` is the way to indicate the
possibility of having no value.

```rust
fn main() {
    let x: i8 = 5;
    let y: Option<i8> = Some(5);
    let sum = x + y.unwrap_or(0);
    println!("{}", sum);
}
```

```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
  match x {
    None => None,
    Some(i) => Some(i + 1),
  }
}
```

To have a default case

```rust
fn pretty_print(x: Option<i32>) {
  match x {
    Some(3) => {
      println!("it is three. you got it!");
    },
    Some(i) => {
      println!("it is not {}. it is another value", i);
    },
    _ => (),
  }
}
```

##### Structure

```rust
struct User {
  username: String,
  email: String,
  age: u16,
  active: bool,
}

impl User {
    fn print(&self) {
        println!("{}", self.username);
        println!("{}", self.email);
        println!("{}", self.age);
        println!("{}", self.active);
    }

    fn build(username: String, email: String, age: u16, active: bool) -> User {
        User {
            username,
            email,
            age,
            active,
        }
    }
}

fn main() {
    let user1 = User {
        username: String::from("John"),
        email: String::from("john@mail.com"),
        age: 30,
        active: true,
    };

    let user2 = User {
        username: String::from("Jane"),
        email: String::from("jane@mail.com"),
        ..user1
    };

    user2.print();

    let user3 = User::build(
        String::from("doe"),
        String::from("doe@mail.com"),
        30,
        true,
    );
    user3.print();
}
```

### Packages, crates and modules

- each package
  - zero or multiple binary crates
    - `main.rs` is a binary crate
    - each `.rs` file in `bin` directory is a binary crate
  - zero or one library crate
    - `lib.rs` is a library crate
- a package can be a binary or a bunch of source code
- each crate contains a root module and named as `crate`
- module is defined by `mod`
- modules can be nested and submodules are private to root module by default
  - `pub` is needed to allow access
- the first level of submodules are define in the same directrory as `lib.rs`
  - sumodules of a first level submodule are in a directory with the name of the
    first level submodule
    - example
      - `lib.rs`
      - `first_module.rs`
      - `first_module/second_module.rs`
- reference example
  - `package_name::first_module::second_module::*`

### Collections

##### Vectors

```rust
let mut v1: Vec<i32> = Vec::new();
v1.push(99);

let v2 = vec![1, 2, 3];
let index = 2;
match v2.get(index) {
  Some(i) => println!("the value is {}", i),
  None => println!("invalid index"),
};

for i in &mut v1 {
  *i += 2;
}
for i in &mut v1 {
  println!("value is {}", i);
}
for i in &v2 {
  println!("value is {}", i);
}

```

### String and string slice

- `String` is always on heap due to its variable size

```rust
let s1: String = String::new();
let s2: &str = "hello";
let s3: String = String::from("world");

let mut s4: String = s2.to_string();
s4.push(' ');
s4.push_str("world");

let s5 = String::from("!");
let s6: String = s4 + &s5; // s6 borrowed s4 and s4 cannot be referenced anymore
let s7 = s2.to_string();
let s8 = format!("{} {}", s7, s3);

for b in s8.bytes() {
  println!("{}", b);
}
for c in s8.chars() {
  println!("{}", c);
}
```

### Hash map

It uses to store key-value pairs.

```rust
use std::collections::HashMap;

fn main() {
    // type specification is not required
    // as it could be inferred from the the first insert usage
    let mut scores = HashMap::new();

    let blue = String::from("Blue");

    scores.insert(blue, 10);    // blue cannot be referenced anymore since it has been borrowed by scores
    scores.insert(String::from("Yellow"), 50);

    let blue = String::from("Blue");
    let score: Option<&i32> = scores.get(&blue);
    println!("{:?}", score);

    // overwrites a value of a key
    scores.insert(String::from("Blue"), 25);

    // this does nothing as key yellow exists
    scores.entry(String::from("Yellow")).or_insert(99);

    // writes a value of a key if it not exists
    let red_score: &mut i32 = scores.entry(String::from("Red")).or_insert(99);

    // updates value of red in scores
    *red_score += 1;

    // iterating over a hashmap
    for (key, value) in &scores {
        println!("{}: {}", key, value);
    }
}
```

### Error handling

##### Result

`std::result::Result` is an `enum` with generic types of `Ok<T>` and `Err(E)`.
Note that Rust does not have exceptions but it serves panic.

###### To handle error as panic

```rust
let user_input = String::new();
let user_number_input: u32 = user_input.parse().expect("Please type a number!");
println!("The number: {}", user_number_input);
```

###### To handle error and continue

```rust
let user_input = String::new();
let user_number_input: u32 = match user_input.parse() {
    Ok(num) => num,
    Err(_) => {
        println!("Please enter a number");
        return;
    }
};
```

where `match` is for `enum` handling.

###### To bubble error to caller

```rust
fn parse(str: String) -> Result<i32, Error> {
  let user_number_input: u32 = match user_input.parse()?;
  user_number_input
}
```

Note that, to use `?`, the enclosed function must return either `Result` or
`Option`.

###### To not handle error

```rust
let user_input = String::new();
let user_number_input: u32 = user_input.parse().unwrap();
println!("The number: {}", user_number_input);
```

###### To write a function with potential error

```rust
fn halves_if_even(i: i32) -> Result<i32, Error> {
    if i % 2 == 0 {
        Ok(i / 2)
    } else {
        Err(/* something */)
    }
}
```

```rust
fn run(path: &str) -> Result<(), Box<dyn std::error::Error>> {
  let content = std::fs::read_to_string()?;
  println!("Content: {}", content);
  Ok(());
}
```

##### ErrorKind

```rust
use std::fs::File;
use std::io::ErrorKind;

fn main() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create("hello.txt") {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => {
                panic!("Problem opening the file: {:?}", other_error)
            }
        },
    };

    println!("File size is {}", f.metadata().unwrap().len());
}
```

##### Main

Possible signatures

```rust
fn main() {
}
```

```rust
fn main() -> Result<(), Box<dyn Error>> {
}
```

where `dyn Error` means any type of error.

### Generics

- Compiler generates the concrete type implementation using the inferred type
  and, thus, the runtime performance penalty is negligible

##### Enum

```rust
enum Strategy<T, E> {
    Stop,
    Continue(T),
    Err(E),
}
```

##### Methods

```rust
struct Point<T, U> {
    x: T,
    y: U,
}

impl<T, U> Point<T, U> {
    fn x(&self) -> &T {
        &self.x
    }

    fn mix<V, W>(self, other: Point<V, W>) -> Point<T, W> {
        Point {
            x: self.x,
            y: other.y,
        }
    }
}

impl Point<f64, f64> {
    fn y(&self) -> &f64 {
        &self.y
    }
}

fn main() {
    let p = Point { x: 5, y: 10 };
    let q = Point { x: 5.0, y: 10.0 };
    println!("p.x = {}", p.x());
    println!("q.x = {}, q.y = {}", q.x(), q.y());

    let r = Point { x: 5, y: 10.0 };
    let s = p.mix(r);
    println!("s.x = {}", s.x());
}
```

### Traits

- concept of traits is similar to interface in other languages
- if only funtion signature is defined in a trait, it behaved like an abstract
  method on other languages

##### To implement a trait

```rust
pub trait Summary {
    fn summarize(&self) -> String;
}

pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

pub struct Tweet {
    pub username: String,
    pub content: String,
    pub reply: bool,
    pub retweet: bool,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}
```

##### To accept a trait

```rust
pub fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}
```

or, using trait bounds syntax

```rust
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```

##### To accept a parameter require multiple traits

```rust
pub fn notify<T: Summary + Clone>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```

or, using `where` syntax

```rust
pub fn notify<T>(item: &T)
    where T: Summary + Clone
{
    println!("Breaking news! {}", item.summarize());
}
```

##### Returning traits

```rust
fn returns_summarizable() -> impl Summary {
    Tweet {
        username: String::from("horse_ebooks"),
        content: String::from(
            "of course, as you probably already know, people",
        ),
        reply: false,
        retweet: false,
    }
}
```

Note that compiler generates the concrete type implementation using the inferred
type and, thus, no casting is required.

##### Blanket implementation

To implement a function for all type with the same traits. The concept is
similar to extension methods in C#.

```rust
impl<T: Display> ToString for T {
    // --snip--
}
```

##### Associated types

- define a trait that uses some types without needing to know exactly what those
  types are until the trait is implemented

```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;
}
```

```rust
struct Counter {
    count: u32,
}

impl Counter {
    fn new() -> Counter {
        Counter { count: 0 }
    }
}

impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        // --snip--
        if self.count < 5 {
            self.count += 1;
            Some(self.count)
        } else {
            None
        }
    }
}
```

##### Default generic type parameters

```rust
trait Add<Rhs=Self> {
    type Output;

    fn add(self, rhs: Rhs) -> Self::Output;
}
```

which allows the following implementation with specifying the generic type
parameter

```rust
use std::ops::Add;

#[derive(Debug, Copy, Clone, PartialEq)]
struct Point {
    x: i32,
    y: i32,
}

impl Add for Point {
    type Output = Point;

    fn add(self, other: Point) -> Point {
        Point {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

fn main() {
    assert_eq!(
        Point { x: 1, y: 0 } + Point { x: 2, y: 3 },
        Point { x: 3, y: 3 }
    );
}
```

##### Disambiguation

```rust
trait Pilot {
    fn fly(&self);
}

trait Wizard {
    fn fly(&self);
}

struct Human;

impl Pilot for Human {
    fn fly(&self) {
        println!("This is your captain speaking.");
    }
}

impl Wizard for Human {
    fn fly(&self) {
        println!("Up!");
    }
}

impl Human {
    fn fly(&self) {
        println!("*waving arms furiously*");
    }
}

fn main() {
    let person = Human;
    Pilot::fly(&person);
    Wizard::fly(&person);
    person.fly();
}
```

```rust
trait Animal {
    fn baby_name() -> String;
}

struct Dog;

impl Dog {
    fn baby_name() -> String {
        String::from("Spot")
    }
}

impl Animal for Dog {
    fn baby_name() -> String {
        String::from("puppy")
    }
}

fn main() {
    println!("A baby dog is called a {}", <Dog as Animal>::baby_name());
}
```

##### Supertraits

- when one trait depends on another trait, the trait being relied on is the
  supertrait

```rust
trait OutlinePrint: fmt::Display {
    fn outline_print(&self) {
        let output = self.to_string();
        let len = output.len();
        println!("{}", "*".repeat(len + 4));
        println!("*{}*", " ".repeat(len + 2));
        println!("* {} *", output);
        println!("*{}*", " ".repeat(len + 2));
        println!("{}", "*".repeat(len + 4));
    }
}

struct Point {
    x: i32,
    y: i32,
}

impl OutlinePrint for Point {}

use std::fmt;

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

fn main() {
    let p = Point { x: 1, y: 3 };
    p.outline_print();
}
```

##### Newtype

- a term originates from the Haskell
- to implement external traits on external types
  - otherwise not possible as it is only allowed to implement a trait on a type
    as long as either the trait or the type are local to the crate
- no runtime performance penalty for using this pattern, and the wrapper type is
  elided at compile time
- it is mostly about wrapping with an existing type and implement it wiht extra
  methods
- similar to `type Age int` in Go

```rust
use std::fmt;

struct Wrapper(Vec<String>);

impl fmt::Display for Wrapper {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "[{}]", self.0.join(", "))
    }
}

fn main() {
    let w = Wrapper(vec![String::from("hello"), String::from("world")]);
    println!("w = {}", w);
}
```

where `Wrapper` does not have the methods of `Vec` and, if such behaviour is
needed, one of the solutions is to implement `Deref` trait.

### Lifetimes (Generics Lifetimes)

- it is another kind of generics
- annotating lifetimes is not common in other languages
- the main aim is to prevent dangling references
- the compiler has a borrow checker that compares scopes to determine whether
  all borrows are valid
- lifetime elision rules
  - the compiler assigns a lifetime parameter to each parameter that’s
    a reference
  - if there is exactly one input lifetime parameter, that lifetime is assigned
    to all output lifetime parameters
  - if there are multiple input lifetime parameters, but one of them is `&self` or
    `&mut` self because this is a method, the lifetime of self is assigned to all
    output lifetime parameters

##### Out of scope example

```rust
fn main() {
    let r;

    {
        let x = 5;
        r = &x;  //`x` does not live long enoughborrowed value does not live long enough rustc (E0597) [6, 13]
    }

    println!("r: {}", r);
}
```

```rust
fn longest<'a>(x: &str, y: &str) -> &'a str {
    let result = String::from("really long string");
    result.as_str()
}
```

Note that `result` owned by the function.

##### Ambiguous example

```rust
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

Since `x` and `y` could have different lifetimes, the compiler (or the borrow
checker) cannot determine the lifetime of the returned reference.

##### Lifetime annotation syntax

```rust
&i32        // a reference
&'a i32     // a reference with an explicit lifetime
&'a mut i32 // a mutable reference with an explicit lifetime
```

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

It means the returned value has the lifetime of minimium of the lifetime of the
two parameters.

```rust
struct ImportantExcerpt<'a> {
    part: &'a str,
}
```

It means an instance of `ImportantExcerpt` cannot outlive the reference it holds in
its `part` field.

```rust
let s: &'static str = "I have a static lifetime.";
```

It denotes that the affected reference can live for the entire duration of the
program.

### Testing

- `#[test]` to annotate a function as test function
- `#[ignore]` to ignore a test function
- a test function fails when it panicked
- useful marcos
  - `assert!`
  - `assert_eq!`
  - `assert_ne!` (assert not equal)
- unit tests live in the same package but as a different (submodule) module
  (usually `test`)
- putting test code in the same file as working code is a common convention
- testing private functions is possible
- each file in directory `tests` is a set of integration tests

##### Basic example

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn larger_can_hold_smaller() {
        let larger = Rectangle {
            width: 8,
            height: 7,
        };
        let smaller = Rectangle {
            width: 5,
            height: 1,
        };

        assert!(larger.can_hold(&smaller));
    }
}
```

##### Custom assert failure message

```rust
assert!(
  result.contains("Carol"),
  "Greeting did not contain name, value was `{}`",
  result
);
```

##### Test against panic

```rust
pub struct Guess {
    value: i32,
}

impl Guess {
    pub fn new(value: i32) -> Guess {
        if value < 1 {
            panic!(
                "Guess value must be greater than or equal to 1, got {}.",
                value
            );
        } else if value > 100 {
            panic!(
                "Guess value must be less than or equal to 100, got {}.",
                value
            );
        }

        Guess { value }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[should_panic(expected = "Guess value must be less than or equal to 100")]
    fn greater_than_100() {
        Guess::new(200);
    }
}
```

##### Using Result

```rust
#[cfg(test)]
mod tests {
    #[test]
    fn it_works() -> Result<(), String> {
        if 2 + 2 == 4 {
            Ok(())
        } else {
            Err(String::from("two plus two does not equal four"))
        }
    }
}
```

Note that `?` can be used. However, `should_panic` cannot be used.

### CLI

##### Reading arguments

```rust
fn main() {
    let args: Vec<String> = std::env::args().collect();
    let first = &args[1];
    let second = &args[2];
    println!("{:?}", args);
}
```

##### Reading environment variable

```rust
fn main() {
    let str = std::env::var("DADADA").unwrap();
    println!("{}", str);
}
```

##### To quit with an exit code

```rust
std::process::exit(0);
```

##### To use stderr

```rust
eprintln!("error message");
```

where `args[0]` contains the executable name


### Closures

- the concept is like anonymous function
- it has access to variables from the scope in which it is defined

##### Basic syntax

```rust
let delegate = |num| {
    println!("{}", num);
    num
};
let result = delegate(99);
println!("{:?}", result);
```

##### As generic parameters

```rust
struct Cacher<T>
where
    T: Fn(u32) -> u32,
{
    calculation: T,
    value: Option<u32>,
}

impl<T> Cacher<T>
where
    T: Fn(u32) -> u32,
{
    fn new(calculation: T) -> Cacher<T> {
        Cacher {
            calculation,
            value: None,
        }
    }

    fn value(&mut self, arg: u32) -> u32 {
        match self.value {
            Some(v) => v,
            None => {
                let v = (self.calculation)(arg);
                self.value = Some(v);
                v
            }
        }
    }
}
```

where there are also `FnMut` and `FnOnce` besides `Fn`.

### Iterators

- `for` statements will invoke iterator
- iterators are like function defintions which does not get invoked until a call
  to consumer like `collect`
  - adapters like `map` which takes one iterator and return an other iterator
- `into_iter()` takes ownership of the iterator of the object such as `Vec<>`
- variables of iterator has to be marked as `mut` since it will be mutated
  during iteration

##### Iterator definition

```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;

    // methods with default implementations are not shown here
}
```

Reference:
[std::iter::Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html)

##### Basic iterator

```rust
struct InfiniteArray {
    data: i32,
}

impl InfiniteArray {
    fn new(data: i32) -> InfiniteArray {
        InfiniteArray { data }
    }
}

impl Iterator for InfiniteArray {
    type Item = i32;

    fn next(&mut self) -> Option<Self::Item> {
        self.data += 1;
        Some(self.data)
    }
}

fn main() {
    let array = InfiniteArray::new(0);
    for i in array {
        println!("{}", i);
        if i > 10 {
            break;
        }
    }
}
```

### Documentation

- `///` is used as function documentation
- `//!` is used as package documentation
- content within the documentation is interpreted as markdown
- code within documentation is executed and evaluated as document test

### Crate

##### Re-export

This can be used to make it easier for external users to consume functions or
structures in a crate without understanding the internal folder structure.

```rust
pub use self::kinds::PrimaryColor;
pub use self::utils::mix;
```

### Cargo workspace

`Cargo.toml`

```toml
[workspace]

members = [
  "package1",
  "package2"
]
```

where the packages are located in sub-directories `package1` and `package2`
respectively (which can be created via `cargo new`.

Note that, in case a package name involves multiple words, it is better to use
`_` to separate the words than `-`.

### Smart pointers

- it is data structures that not only act like a pointer but also have
  additional metadata and capabilities
- different smart pointers defined in the standard library provide functionality
  beyond that provided by references
- references are pointers that only borrow data; in contrast, in many cases,
  smart pointers own the data they point to
- examples
  - `String`
  - `Vec<T>`
- usually implemented using structs with implementing `Deref` and `Drop` traits
  - `Deref` allows an instance of the smart pointer struct to behave like
    a reference so you can write code that works with either references or smart
    pointers
  - `Drop` allows you to customize the code that is run when an instance of the
    smart pointer goes out of scope

##### Box<T>

- to store data in heap
- to deal with large data object and to avoid copying
- to deal with recursive types
  - where it is impossible to determine the memory size in heap

```rust
let a = 5
let b = Box::new(a);
println!("b = {}", *b);
println!("b = {}", b);
```

##### Deref

```rust
use std::ops::Deref;

impl<T> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

struct MyBox<T>(T);

impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}

fn main() {
    let x = 5;
    let y = MyBox::new(x);

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

##### Implicit Deref coercions

```rust
use std::ops::Deref;

impl<T> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &T {
        &self.0
    }
}

struct MyBox<T>(T);

impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}

fn hello(name: &str) {
    println!("Hello, {}!", name);
}

fn main() {
    let m = MyBox::new(String::from("Rust"));
    hello(&m);
}
```

where casting from `&String` to `&str` is not required and it is done at compile
time.

##### Drop<T>

- effectively a destructor implementation

```rust
struct CustomSmartPointer {
    data: String,
}

impl Drop for CustomSmartPointer {
    fn drop(&mut self) {
        println!("Dropping CustomSmartPointer with data `{}`!", self.data);
    }
}

fn main() {
    let c = CustomSmartPointer {
        data: String::from("my stuff"),
    };
    let d = CustomSmartPointer {
        data: String::from("other stuff"),
    };
    println!("CustomSmartPointers created.");
}
```

Note that `c.drop()` cannot be invoked directly but it is okay to call `drop(c)`
(where `drop` is available globally).

##### Rc<T>

- a reference counted smart pointer
- it should only be used in single-threaded program
- it is not needed if the last owner is known at compile time
  - as we could simply assign the ownership to the last owner
- `Rc::strong_count` returns the number of references

```rust
enum List {
    Cons(i32, Rc<List>),
    Nil,
}

use crate::List::{Cons, Nil};
use std::rc::Rc;

fn main() {
    let a = Rc::new(Cons(5, Rc::new(Cons(10, Rc::new(Nil)))));
    let b = Cons(3, Rc::clone(&a));
    let c = Cons(4, Rc::clone(&a));
}
```

##### RefCell<T>

- related to interior mutability pattern
  - to mutate data even when there are immutable references to that data;
    normally, this action is disallowed by the borrowing rules
    - types that uses the interior mutability pattern when we can
      ensure that the borrowing rules will be followed at runtime, even though
      the compiler can’t guarantee that. The `unsafe` code involved is then
      wrapped in a safe API, and the outer type is still immutable.
- it should only be used in single-threaded program

```rust
fn main() {
    let x = 5;
    let y = &mut x;
}
```

where this code will not compile.

```rust
pub trait Messenger {
    fn send(&self, msg: &str);
}

pub struct LimitTracker<'a, T: Messenger> {
    messenger: &'a T,
    value: usize,
    max: usize,
}

impl<'a, T> LimitTracker<'a, T>
where
    T: Messenger,
{
    pub fn new(messenger: &T, max: usize) -> LimitTracker<T> {
        LimitTracker {
            messenger,
            value: 0,
            max,
        }
    }

    pub fn set_value(&mut self, value: usize) {
        self.value = value;

        let percentage_of_max = self.value as f64 / self.max as f64;

        if percentage_of_max >= 1.0 {
            self.messenger.send("Error: You are over your quota!");
        } else if percentage_of_max >= 0.9 {
            self.messenger
                .send("Urgent warning: You've used up over 90% of your quota!");
        } else if percentage_of_max >= 0.75 {
            self.messenger
                .send("Warning: You've used up over 75% of your quota!");
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::cell::RefCell;

    struct MockMessenger {
        sent_messages: RefCell<Vec<String>>,
    }

    impl MockMessenger {
        fn new() -> MockMessenger {
            MockMessenger {
                sent_messages: RefCell::new(vec![]),
            }
        }
    }

    impl Messenger for MockMessenger {
        fn send(&self, message: &str) {
            self.sent_messages.borrow_mut().push(String::from(message));
        }
    }

    #[test]
    fn it_sends_an_over_75_percent_warning_message() {
        // --snip--
        let mock_messenger = MockMessenger::new();
        let mut limit_tracker = LimitTracker::new(&mock_messenger, 100);

        limit_tracker.set_value(80);

        assert_eq!(mock_messenger.sent_messages.borrow().len(), 1);
    }
}
```

##### Weak<T>

- pretty much like `Rc<T>` but it does not attribute to `Rc::strong_count` and
  this allows clean-up can be done sooner (as long as `Rc::strong_count` is
  zero) which avoids potential memory leak

```rust
use std::cell::RefCell;
use std::rc::{Rc, Weak};

#[derive(Debug)]
struct Node {
    value: i32,
    parent: RefCell<Weak<Node>>,
    children: RefCell<Vec<Rc<Node>>>,
}

fn main() {
    let leaf = Rc::new(Node {
        value: 3,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![]),
    });

    println!(
        "leaf strong = {}, weak = {}",
        Rc::strong_count(&leaf),
        Rc::weak_count(&leaf),
    );

    {
        let branch = Rc::new(Node {
            value: 5,
            parent: RefCell::new(Weak::new()),
            children: RefCell::new(vec![Rc::clone(&leaf)]),
        });

        *leaf.parent.borrow_mut() = Rc::downgrade(&branch);

        println!(
            "branch strong = {}, weak = {}",
            Rc::strong_count(&branch),
            Rc::weak_count(&branch),
        );

        println!(
            "leaf strong = {}, weak = {}",
            Rc::strong_count(&leaf),
            Rc::weak_count(&leaf),
        );
    }

    println!("leaf parent = {:?}", leaf.parent.borrow().upgrade());
    println!(
        "leaf strong = {}, weak = {}",
        Rc::strong_count(&leaf),
        Rc::weak_count(&leaf),
    );
}
```

where tree has a strong reference to its leaves and leaf has a weak reference to
it parent (when a tree is to be clean up, its leaf nodes should be cleaned up
whereas vice versa is not true).

### Concurrency (and parallelism)

- in other languages, usually kind of threads are available
  - system threads
  - user threads
    - multiple user threads may map to one system threads but not vice versa
- only system thread is available in Rust as Rust is a lower level language


##### Thread

```rust
use std::thread;
use std::time::Duration;

fn main() {
    thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }
}
```

where the spwan thread does not get to finish.

##### JoinHandle

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let handle = thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }

    handle.join().unwrap();
}
```

where the spawn thread get to finish.

##### Channel

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let vals = vec![
            String::from("hi"),
            String::from("from"),
            String::from("the"),
            String::from("thread"),
        ];

        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    for received in rx {
        println!("Got: {}", received);
    }
}
```

where `move` is to transfer the ownership of objects into the closure of the
spawned thread, `mpsc` refers to "multiple producers single consumer".

For multiple producers,

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    // --snip--

    let (tx, rx) = mpsc::channel();

    let tx1 = tx.clone();
    thread::spawn(move || {
        let vals = vec![
            String::from("hi"),
            String::from("from"),
            String::from("the"),
            String::from("thread"),
        ];

        for val in vals {
            tx1.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    thread::spawn(move || {
        let vals = vec![
            String::from("more"),
            String::from("messages"),
            String::from("for"),
            String::from("you"),
        ];

        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    for received in rx {
        println!("Got: {}", received);
    }

    // --snip--
}
```

##### Mutex

- `Mutex::lock` blocks the thread until it acquires the lock
  - it errors if the other user holding the lock panics
  - it panics if the current thread is already holding the lock

```rust
use std::sync::Mutex;

fn main() {
    let m = Mutex::new(5);

    {
        let mut num = m.lock().unwrap();
        *num = 6;
    }

    println!("m = {:?}", m);
}
```

where the lock is released automatically when `num` is out of scope.

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();

            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

where a bare `Mutex` cannot be used as the ownership has to be shared between
threads and wrapping the mutex with `Rc<T>` does not work as it is not
thread-safe. Thus, `Arc<T>` is used here.

### Object-oriented programming

##### Trait objects

The following example using trait bounds will not work as expected.

```rust
pub trait Draw {
    fn draw(&self);
}

pub struct Screen<T: Draw> {
    pub components: Vec<T>,
}

impl<T> Screen<T>
where
    T: Draw,
{
    pub fn run(&self) {
        for component in self.components.iter() {
            component.draw();
        }
    }
}
```

The reason is that a generic type parameter can only be substituted with one
concrete type at a time due to the monomorphization process performed by the
compiler when we use trait bounds on generics; the compiler generates nongeneric
implementations of functions and methods for each concrete type that we use in
place of a generic type parameter. In this case, the compiler would either
generate the specified type of `Vec<T>` or the inferred type of the first usage.

```rust
pub trait Draw {
    fn draw(&self);
}

pub struct Screen {
    pub components: Vec<Box<dyn Draw>>,
}

impl Screen {
    pub fn run(&self) {
        for component in self.components.iter() {
            component.draw();
        }
    }
}
```

where the above will work as expected due to trait objects allow for multiple
concrete types to fill in for the trait object at runtime.

### Pattern matching

##### if let

```rust
fn main() {
    let favorite_color: Option<&str> = None;
    let is_tuesday = false;
    let age: Result<u8, _> = "34".parse();

    if let Some(color) = favorite_color {
        println!("Using your favorite color, {}, as the background", color);
    } else if is_tuesday {
        println!("Tuesday is green day!");
    } else if let Ok(age) = age {
        if age > 30 {
            println!("Using purple as the background color");
        } else {
            println!("Using orange as the background color");
        }
    } else {
        println!("Using blue as the background color");
    }
}
```

##### while let

```rust
fn main() {
    let mut stack = Vec::new();

    stack.push(1);
    stack.push(2);
    stack.push(3);

    while let Some(top) = stack.pop() {
        println!("{}", top);
    }
}
```

##### for

```rust
fn main() {
    let v = vec!['a', 'b', 'c'];

    for (index, value) in v.iter().enumerate() {
        println!("{} is at index {}", value, index);
    }
}
```

where using `enumerate` returns a tuple with an index.

##### Destructuring

```rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p = Point { x: 0, y: 7 };

    let Point { x: a, y: b } = p;
    assert_eq!(0, a);
    assert_eq!(7, b);
}
```

```rust
fn main() {
    struct Point {
        x: i32,
        y: i32,
    }

    let ((feet, inches), Point { x, y }) = ((3, 10), Point { x: 3, y: -10 });
}
```

##### Match

```rust
fn main() {
    let x = 1;

    match x {
        1 => println!("one"),
        2 => println!("two"),
        3 => println!("three"),
        _ => println!("anything"),
    }
}
```

```rust
fn main() {
    let x = Some(5);
    let y = 10;

    match x {
        Some(50) => println!("Got 50"),
        Some(y) => println!("Matched, y = {:?}", y),
        _ => println!("Default case, x = {:?}", x),
    }

    println!("at the end: x = {:?}, y = {:?}", x, y);
}
```

```rust
fn main() {
    let x = 1;

    match x {
        1 | 2 => println!("one or two"),
        3 => println!("three"),
        _ => println!("anything"),
    }
}
```

```rust
fn main() {
    let x = 5;

    match x {
        1..=5 => println!("one through five"),
        _ => println!("something else"),
    }
}
```

```rust
fn main() {
    let x = 'c';

    match x {
        'a'..='j' => println!("early ASCII letter"),
        'k'..='z' => println!("late ASCII letter"),
        _ => println!("something else"),
    }
}
```

```rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p = Point { x: 0, y: 7 };

    match p {
        Point { x, y: 0 } => println!("On the x axis at {}", x),
        Point { x: 0, y } => println!("On the y axis at {}", y),
        Point { x, y } => println!("On neither axis: ({}, {})", x, y),
    }
}
```

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

fn main() {
    let msg = Message::ChangeColor(0, 160, 255);

    match msg {
        Message::Quit => {
            println!("The Quit variant has no data to destructure.")
        }
        Message::Move { x, y } => {
            println!(
                "Move in the x direction {} and in the y direction {}",
                x, y
            );
        }
        Message::Write(text) => println!("Text message: {}", text),
        Message::ChangeColor(r, g, b) => println!(
            "Change the color to red {}, green {}, and blue {}",
            r, g, b
        ),
    }
}
```

```rust
enum Color {
    Rgb(i32, i32, i32),
    Hsv(i32, i32, i32),
}

enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(Color),
}

fn main() {
    let msg = Message::ChangeColor(Color::Hsv(0, 160, 255));

    match msg {
        Message::ChangeColor(Color::Rgb(r, g, b)) => println!(
            "Change the color to red {}, green {}, and blue {}",
            r, g, b
        ),
        Message::ChangeColor(Color::Hsv(h, s, v)) => println!(
            "Change the color to hue {}, saturation {}, and value {}",
            h, s, v
        ),
        _ => (),
    }
}
```

```rust
fn main() {
    let mut setting_value = Some(5);
    let new_setting_value = Some(10);

    match (setting_value, new_setting_value) {
        (Some(_), Some(_)) => {
            println!("Can't overwrite an existing customized value");
        }
        _ => {
            setting_value = new_setting_value;
        }
    }

    println!("setting is {:?}", setting_value);
}
```

```rust
fn main() {
    let numbers = (2, 4, 8, 16, 32);

    match numbers {
        (first, _, third, _, fifth) => {
            println!("Some numbers: {}, {}, {}", first, third, fifth)
        }
    }
}
```

```rust
fn main() {
    struct Point {
        x: i32,
        y: i32,
        z: i32,
    }

    let origin = Point { x: 0, y: 0, z: 0 };

    match origin {
        Point { x, .. } => println!("x is {}", x),
    }
}
```

```rust
fn main() {
    let numbers = (2, 4, 8, 16, 32);

    match numbers {
        (first, .., last) => {
            println!("Some numbers: {}, {}", first, last);
        }
    }
}
```

```rust
fn main() {
    let num = Some(4);

    match num {
        Some(x) if x % 2 == 0 => println!("The number {} is even", x),
        Some(x) => println!("The number {} is odd", x),
        None => (),
    }
}
```

```rust
fn main() {
    let x = 4;
    let y = false;

    match x {
        4 | 5 | 6 if y => println!("yes"),
        _ => println!("no"),
    }
}
```

```rust
fn main() {
    enum Message {
        Hello { id: i32 },
    }

    let msg = Message::Hello { id: 5 };

    match msg {
        Message::Hello {
            id: id_variable @ 3..=7,
        } => println!("Found an id in range: {}", id_variable),
        Message::Hello { id: 10..=12 } => {
            println!("Found an id in another range")
        }
        Message::Hello { id } => println!("Found some other id: {}", id),
    }
}
```

### Advanced types

##### Type aliases

```rust
type Kilometers = i32;
```

alias `Kilometers` is a synonym for `i32`

##### Empty type

```rust
fn bar() -> ! {
    // --snip--
}
```

where the function is called a diverging function.

```rust
let guess: u32 = match guess.trim().parse() {
  Ok(num) => num,
  Err(_) => continue,
};

println!("You guessed: {}", guess);
```

where `continue` returns `!` which does not assign any value to `guess`.

##### Dynamically sized types

- `Sized` trait to determine whether or not a type’s size is known at compile
  time

```rust
fn generic<T>(t: T) {
    // --snip--
}
```

implicitly means

```rust
fn generic<T: Sized>(t: T) {
    // --snip--
}
```

To write a generic function without `Sized` limitation,

```rust
fn generic<T: ?Sized>(t: &T) {
    // --snip--
}
```

### Advanced functions and closures

##### Function pointers

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}

fn do_twice(f: fn(i32) -> i32, arg: i32) -> i32 {
    f(arg) + f(arg)
}

fn main() {
    let answer = do_twice(add_one, 5);

    println!("The answer is: {}", answer);
}
```

where `fn` is a type and function pointers implement all 3 of the closure traits
(`Fn`, `FnMut` and `FnOnce`).

##### Returning closures

```rust
fn returns_closure() -> Box<dyn Fn(i32) -> i32> {
    Box::new(|x| x + 1)
}
```

where returning closure directly does not compile due to the size of closure is
not known at compile time.

### Marcos

- a way of writing code that writes other code, which is known as
  metaprogramming
- it is useful for reducing the amount of code you have to write and maintain
- a function signature must declare the number and type of parameters the
  function has.
  - macros, on the other hand, can take a variable number of parameters
- macros are expanded before the compiler interprets the meaning of the code
  - a marco can implement a trait on a given type
- marcos much be defined or must be brought into a scope before it can be
  invoked

##### Example using `macros_rules!`

- this is an example of declarative macro
- declarative macro replaces code in a template

```rust
#[macro_export]
macro_rules! vec {
    ( $( $x:expr ),* ) => {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}
```

where `( $( $x:expr ),* )` is a pattern to be matched. Note that this is for
illustration and not an actual implementation.

It translates `vec![1, 2, 3];` to

```rust
{
    let mut temp_vec = Vec::new();
    temp_vec.push(1);
    temp_vec.push(2);
    temp_vec.push(3);
    temp_vec
}
```

#### Procedural macro

- procedural macro generates code with code
- 3 types
  - custom derive
  - attribute-like
  - function-like

##### An example of custom derive procedural macro

```rust
pub trait HelloMacro {
    fn hello_macro();
}
```

```rust
use proc_macro::TokenStream;
use quote::quote;
use syn;

#[proc_macro_derive(HelloMacro)]
pub fn hello_macro_derive(input: TokenStream) -> TokenStream {
    // Construct a representation of Rust code as a syntax tree
    // that we can manipulate
    let ast = syn::parse(input).unwrap();

    // Build the trait implementation
    impl_hello_macro(&ast)
}

fn impl_hello_macro(ast: &syn::DeriveInput) -> TokenStream {
    let name = &ast.ident;
    let gen = quote! {
        impl HelloMacro for #name {
            fn hello_macro() {
                println!("Hello, Macro! My name is {}!", stringify!(#name));
            }
        }
    };
    gen.into()
}
```

The macro takes a stream of tokens (or code characters) and output generated
code in form of another `TokenStream`.

The macro can be used like the following.

```rust
use hello_macro::HelloMacro;
use hello_macro_derive::HelloMacro;

#[derive(HelloMacro)]
struct Pancakes;

fn main() {
    Pancakes::hello_macro();
}
```

Note that, for details related to crate creation and dependency setup, refer to
[How to Write a Custom derive Macro
](https://doc.rust-lang.org/book/ch19-06-macros.html#how-to-write-a-custom-derive-macro)

##### An example usage of attribute-like procedural macro

```rust
#[route(GET, "/")]
fn index() {
```

##### An example usage of function-like procedural macro

```rust
let sql = sql!(SELECT * FROM posts WHERE id=1);
```

### Others

##### String interpolation

```rust
println!("hello {}", name)
```

```rust
println!("{:?}", name)
```

where it prints `name` in debug format (if available)

```rust
let s = format!("{} {}", "hello", "world");
```

##### Reading string allowing invalid UTF-8 characters

```rust
String::from_utf8_lossy(&buffer[..]);
```

##### Create a byte string

```rust
let get = b"GET / HTTP/1.1\r\n";
```

##### Function

`return` keyword and `;` can be omitted if it is the last statement of
a function.

```rust
fn sum(a: i32, b: i32) -> i32 {
  a + b
}
```

##### File IO

To read string from file

```rust
let content = std::fs::read_to_string("filename").unwrap();
```
