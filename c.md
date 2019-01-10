## Libraries

- [oatpp](https://github.com/oatpp/oatpp) - a web framework

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
