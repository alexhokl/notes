- [.NET 9](#net-9)
  * [Hybrid cache](#hybrid-cache)
  * [SLNX](#slnx)
___

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

## SLNX

- [introduction](https://devblogs.microsoft.com/dotnet/introducing-slnx-support-dotnet-cli/)
- solution file in XML
- `dotnet sln migrate` to convert SLN to SLNX
- `dotnet sln .\example.slnx list` to list projects in the solution
- `dotnet sln .\example.slnx remove .\my-lib\` to remove a project from the
  solution
