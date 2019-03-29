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

- 

