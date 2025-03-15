# .NET 9

## Hybrid cache

- [introduction](https://devblogs.microsoft.com/dotnet/hybrid-cache-is-now-ga/)
- it has a simpler API to work with comparing `IDistributedCache`
  * it is built on top of `IDistributedCache`
- it has cache-stampede protection
  * it can occur when the same data is requested by multiple clients at the same
    time but the data is not in the cache initially
- it allows cache invalidation by using a tag
  * data can be tagged with multiple tags
