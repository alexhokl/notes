- [Libraries](#libraries)
- [Commands](#commands)
- [Talks](#talks)
  * [Practical C++ Development of Bloomberg Terminal](#practical-c-development-of-bloomberg-terminal)
  * [Hashing](#hashing)
____

## Libraries

- [oatpp](https://github.com/oatpp/oatpp) - a web framework


## Commands

##### To compile a simple C++ program

```sh
g++ main.app -o output
```

```sh
gcc -xc++ -lstdc++ main.cpp -o output
```

```sh
clong -xc++ -lstdc++ main.cpp -o output
```

where `-xc++` is a compiler option and `-lstdc++` is a linker option.

## Talks

### Practical C++ Development of Bloomberg Terminal

#### Datum

- a structure stores all the types required
- [IEEE 754-2008](https://standards.ieee.org/standard/754-2008.html) double
  format
- using fewer bits in a 4- or 6-byte data to indicate the type of data
- taking advantage of a different first (two) bytes of each data type
- this kind of structure is not good at manipulating strings, especially longer
    strings
  - but the gain in all other data types are very significant

#### Allocator

- checkout `str::pmr::memory_resource` (C++17)
  - `std::pmr::polymorphic_allocator` is backported to C++11 and C++03
- `new_delete_resource`
- `null_memory_resource`
- `synchronized_pool_resource`
- `monotonic_buffer_resource` for short-lived C++ objects that allocate and
    deallocate, often you would prefer to defer deallocation
  - it allocates sequentially from a single buffer just by moving a pointer
      within a range of bytes
- `std::pmr::string`

### Hashing

- it does not help when the container (or the amount of data rows, or bucket)
  is large
- attacks can be made by trying to create hash collisions
  - using seed per application lifecycle (or per process) can help avoid
- hash values should be uniformly distributed
  - so that bucketing is balanced
- pointer should not be used
- processes
  - hash_code
  - hash_expansion
    - append respective members
- use static functions (not virtual)

```c
hash_code hash_expansion(hash_code h, X const& value) {
  return HashCode::combine(move(h), value.member1, value.memeber2);
}
```

