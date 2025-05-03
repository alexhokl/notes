- [.NET 8](#net-8)
  * [General](#general)
  * [TimeProvider](#timeprovider)
  * [SearchValues](#searchvalues)
  * [Keyed scope](#keyed-scope)
  * [IHostedLifecycleService](#ihostedlifecycleservice)
  * [Rate limiting](#rate-limiting)
    + [Algorithms](#algorithms)
  * [AOT](#aot)
  * [Trimming (self-contained)](#trimming-self-contained)
  * [Web Application creation](#web-application-creation)
  * [FrozenDictionary](#frozendictionary)
  * [StringBuilder](#stringbuilder)
____

# .NET 8

## General

- [What's new in .NET
  8](https://learn.microsoft.com/en-gb/dotnet/core/whats-new/dotnet-8)
- [Breaking changes in .NET
  8](https://learn.microsoft.com/en-gb/dotnet/core/compatibility/8.0)
- `\` characters are valid in directory and file names on Unix. Starting in .NET
  8, the native CoreCLR runtime no longer converts `\` to `/` on Unix.
- `System.ComponentModel.ITypeDescriptorContext` has three properties that were
  previously annotated as being non-nullable, but they were actually nullable in
  practice. The nullable annotations for these properties have been updated to
  indicate that they're nullable. This change can result in new build warnings
  related to use of nullable members.
- `Environment.GetFolderPath` changes
  | OS      | `SpecialFolder` value | .NET 7               | .NET 8                                                                 |
  | ---     | ---                   | ---                  | ---                                                                    |
  | Linux   | MyDocuments           | `$HOME`              | `XDG_DOCUMENTS_DIR`, or `$HOME/Documents` otherwise                    |
  | Linux   | Personal              | `$HOME`              | `XDG_DOCUMENTS_DIR`, or `$HOME/Documents` otherwise                    |
  | macOS   | MyDocuments           | `$HOME`              | `NSDocumentDirectory` (`$HOME/Documents`)                              |
  | macOS   | Personal              | `$HOME`              | `NSDocumentDirectory` (`$HOME/Documents`)                              |
  | macOS   | ApplicationData       | `$HOME/.config`      | `NSApplicationSupportDirectory`, (`$HOME/Library/Application Support`) |
  | macOS   | LocalApplicationData  | `$HOME/.local/share` | `NSApplicationSupportDirectory`, (`$HOME/Library/Application Support`) |
  | macOS   | MyVideos              | `$HOME/Videos`       | `NSMoviesDirectory` (`$HOME/Movies`)                                   |
  | Android | MyDocuments           | `$HOME`              | `$HOME/Documents`                                                      |
  | Android | Personal              | `$HOME`              | `$HOME/Documents`                                                      |
- performance-focused types
  * setup time is longer but the read time is very fast
  * `System.Collections.Frozen.FrozenDictionary<TKey,TValue>`
  * `System.Collections.Frozen.FrozenSet<TKey,TValue>`
- Docker images
  * a non-root user `app` has been included but not used by default
  * default port changed from `80` to `8080`
  * `ASPNETCORE_HTTP_PORTS` can be used to set port and it can replace the usage
    of `ASPNETCORE_URLS`
  * [chiseled Ubuntu
    images](https://mcr.microsoft.com/product/dotnet/nightly/aspnet/tags) are
    available
    + super small, no package manager, no shell and run as non-root

## TimeProvider

```cs
TimeProvider p = TImeProvider.System;

class Example(TimeProvider timeProvider)
{
    public DateTimeOffset GetTime() => timeProvider.GetUtcNow();
}
```

The advantage of using this over `DateTime.UtcNow` is that mocking can be done
via `TimeProvider` in unit tests.

## SearchValues

- `System.Buffers.SearchValues`
- the pattern for using a `SearchValues` is to create one, store it in a static
  readonly field, and then use that `SearchValues` for all searching operations
  for that target set
- it has the advantage of using less memory and performing at a faster speed

```cs
public static readonly SearchValues<char> sv = SearchValues.Create("!@#$%^&*()_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"u8);

// in a method

ReadOnlySpan<char> remaining = bookContentString;
var index = remaining.IndexOfAny(sv);
```

This automatically searches for the best, or most optimized, way to find a value
within a string.

The following values use different implementations.

Values

```cs
Console.WriteLine(SearchValues.Create(""));
Console.WriteLine(SearchValues.Create("a"));
Console.WriteLine(SearchValues.Create("ac"));
Console.WriteLine(SearchValues.Create("ace"));
Console.WriteLine(SearchValues.Create("ab\u05D0\u05D1"));
Console.WriteLine(SearchValues.Create("abc\u05D0\u05D1"));
Console.WriteLine(SearchValues.Create("abcdefghijklmnopqrstuvwxyz"));
Console.WriteLine(SearchValues.Create("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"));
Console.WriteLine(SearchValues.Create("\u00A3\u00A5\u00A7\u00A9\u00AB\u00AD"));
Console.WriteLine(SearchValues.Create("abc\u05D0\u05D1\u05D2"));
```

Underlying types

```cs
System.Buffers.EmptySearchValues`1[System.Char]
System.Buffers.SingleCharSearchValues`1[System.Buffers.SearchValues+TrueConst]
System.Buffers.Any2CharSearchValues`1[System.Buffers.SearchValues+TrueConst]
System.Buffers.Any3CharSearchValues`1[System.Buffers.SearchValues+TrueConst]
System.Buffers.Any4SearchValues`2[System.Char,System.Int16]
System.Buffers.Any5SearchValues`2[System.Char,System.Int16]
System.Buffers.RangeCharSearchValues`1[System.Buffers.SearchValues+TrueConst]
System.Buffers.AsciiCharSearchValues`1[System.Buffers.IndexOfAnyAsciiSearcher+Default]
System.Buffers.ProbabilisticCharSearchValues
System.Buffers.ProbabilisticWithAsciiCharSearchValues`1[System.Buffers.IndexOfAnyAsciiSearcher+Default]
```

## Keyed scope

```cs
builder.Services.AddKeyedScoped<ISomeService, SomeService>("key1");
```

```cs
public SomeFunction(ILogger logger, [FromKeyedServices("key2")] ICache cache)
{
    // do something
}
```

There are other method signatures such as

- `AddKeyedSingleton`
- `AddKeyedTransient`

## IHostedLifecycleService

It inherits from `IHostedService` and provide more lifecycle methods.

- `StartingAsync(CancellationToken)` triggered before `StartAsync(CancellationToken)`
- `StartedAsync(CancellationToken)` triggered after `StartAsync(CancellationToken)`
- `StoppingAsync(CancellationToken)` triggered before `StopAsync(CancellationToken)`
- `StoppedAsync(CancellationToken)` triggered after `StopAsync(CancellationToken)`


## Rate limiting

reference: [Rate limiting middleware in ASP.NET
Core](https://learn.microsoft.com/en-us/aspnet/core/performance/rate-limit)

### Algorithms

- [Fixed
  window](https://learn.microsoft.com/en-us/aspnet/core/performance/rate-limit#fixed-window-limiter)
- [Sliding
  window](https://learn.microsoft.com/en-us/aspnet/core/performance/rate-limit#sliding-window-limiter)
- [Token
  bucket](https://learn.microsoft.com/en-us/aspnet/core/performance/rate-limit#token-bucket-limiter)
- [Concurrency](https://learn.microsoft.com/en-us/aspnet/core/performance/rate-limit#concurrency-limiter)
- [Create chained
  limiters](https://learn.microsoft.com/en-us/aspnet/core/performance/rate-limit#create-chained-limiters)
  to understand how `PartitionedRateLimiter` can be used

## AOT

- advantages
  * minimised disk footprint
  * reduced startup times
  * reduced memory demand
- `5.8x` of normal build time

## Trimming (self-contained)

- available since .NET 6 but not all library supported
  * `TrimMode` was set to `partial` until .NET 8
  * only assemblies that explicitly stated they supported trimming would be
  * ASP.NET Core libraries are not compatible with trimming yet
  trimmed
- remove code that is not used
- libraries need to annotate types and methods calls to tell trimmer about code
  being used that the trimmer cannot determine
- `TrimMode` is set to `full` in .NET 8
  * all assemblies are trimmed by default
  * ASP.NET Core libraries are compatible with trimming
  * trim speed (during compilation) is faster than previous versions
    + `2.7x` of normal build time

## Web Application creation

- existing method
  * `WebApplication.CreateBuilder`
- new methods
  * `WebApplication.CreateSlimBuilder`
  * `WebApplication.CreateEmptyBuilder` (`builder.WebHost.UseKestrelCore()` is
    needed)

## FrozenDictionary

- optimised for read operations at the cost of slower constructions
- it is used in routing in ASP.NET

## Span-related performance boosts

### StringBuilder

- `AppendInterpolated` needs less memory than `AppendToString`
- `StringBuilder.Append(CultureInfo.InvariantCulture, $"{b:x2}");`
  * and `StringBuilder.Append(b.ToString("x2", CultureInfo.InvariantCulture));`
    is slower

### String.Split

- signature `String.Split(char[], Int32)` is faster as it uses
  `System.MemoryExtensions` for its implementation

### ReadOnlySpan<T>.Count

- it is a new method to look for an element in a span

### ReadOnlySpan<T>.IndexOfAnyInRange

- it is a new method to look for any element in a span within the specified
  range
- examples
  * `bool nonAsciiOrControlCharacters = text.IndexOfAnyExceptInRange((char)0x20, (char)0x7e) >= 0;`
  * `Encoding enc = _text.AsSpan().ContainsAnyExceptInRange((char)32, (char)126) ? Encoding.UTF8 : Encoding.ASCII;`
