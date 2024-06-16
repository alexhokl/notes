- [.NET 8](#net-8)
  * [General](#general)
  * [TimeProvider](#timeprovider)
  * [SearchValues](#searchvalues)
  * [Keyed scope](#keyed-scope)
  * [IHostedLifecycleService](#ihostedlifecycleservice)
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

```csharp
TimeProvider p = TImeProvider.System;

class Example(TimeProvider timeProvider)
{
    public DateTimeOffset GetTime() => timeProvider.GetUtcNow();
}
```

The advantage of using this over `DateTime.UtcNow` is that mocking can be done
via `TimeProvider` in unit tests.

## SearchValues

```csharp
var sv = SearchValues.Create("!@#$%^&*()_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"u8);
var keyword= (byte)"z"[0];
for (var i = 0; i < N; i++)
{
    sv.Contains(keyword);
}
```

This automatically looks for the best way (or the most optimised way) to search
for a value in a string.

## Keyed scope

```csharp
builder.Services.AddKeyedScoped<ISomeService, SomeService>("key1");
```

```csharp
public SomeFunction(ILogger logger, [FromKeyedServices("key2")] ICache cache)
{
    // do something
}
```

## IHostedLifecycleService

It inherits from `IHostedService` and provide more lifecycle methods.

- `StartingAsync(CancellationToken)` triggered before `StartAsync(CancellationToken)`
- `StartedAsync(CancellationToken)` triggered after `StartAsync(CancellationToken)`
- `StoppingAsync(CancellationToken)` triggered before `StopAsync(CancellationToken)`
- `StoppedAsync(CancellationToken)` triggered after `StopAsync(CancellationToken)`

