- [Libraries](#libraries)
- [.NET Core](#net-core)
    + [Links](#links)
    + [Tools](#tools)
    + [.NET CLI](#net-cli)
    + [Visual Studio](#visual-studio)
    + [Nuget](#nuget)
    + [ASP.NET Core](#aspnet-core)
    + [Entity Framework](#entity-framework)
    + [Async](#async)
    + [Reducing heap consumption](#reducing-heap-consumption)
    + [No reflection](#no-reflection)
    + [Mac Installation](#mac-installation)
    + [Kestrel](#kestrel)
    + [Garbage collection](#garbage-collection)
    + [Code Analysis](#code-analysis)
    + [Cultures](#cultures)
    + [Forwarding headers behind reverse proxy](#forwarding-headers-behind-reverse-proxy)
    + [IPv6](#ipv6)
    + [`System.Drawing.Common`](#systemdrawingcommon)
    + [Alpine](#alpine)
    + [Cryptography](#cryptography)
    + [Snapshot testing](#snapshot-testing)
    + [Prometheus](#prometheus)
    + [OpenTelemetry](#opentelemetry)
    + [Regular Expression (regex)](#regular-expression-regex)
    + [Dictionaries](#dictionaries)
    + [Microsoft.IO.RecyclableMemoryStream](#microsoftiorecyclablememorystream)
    + [Workarounds](#workarounds)
  * [Libraries](#libraries-1)
    + [Proto.Actor](#protoactor)
    + [Microsoft Orleans](#microsoft-orleans)
    + [Resilience (Polly)](#resilience-polly)
- [.NET (Classic)](#net-classic)
    + [To check which .NET framework versions are installed](#to-check-which-net-framework-versions-are-installed)
- [C#](#c%23)
    + [Generics](#generics)
    + [ref](#ref)
    + [Span, Memory and Pipeline](#span-memory-and-pipeline)
- [ASP.NET](#aspnet)
    + [Links](#links-1)
    + [Lifecycle](#lifecycle)
    + [Web API](#web-api)
    + [Error handling](#error-handling)
    + [CORS](#cors)
    + [Directory](#directory)
    + [Troubleshooting](#troubleshooting)
- [Nuget](#nuget-1)
- [IIS](#iis)
- [IIS Express](#iis-express)
    + [Making ASP.NET site available on port 8080 to other machines](#making-aspnet-site-available-on-port-8080-to-other-machines)
    + [Making ASP.NET site running on a Windows VM on Mac (and accessing it via a web client on Mac (the host))](#making-aspnet-site-running-on-a-windows-vm-on-mac-and-accessing-it-via-a-web-client-on-mac-the-host)
- [MSSQL](#mssql)
- [Azure](#azure)
    + [SQL](#sql)
- [Monitoring](#monitoring)
- [General Practices](#general-practices)
    + [To increase testability (C#)](#to-increase-testability-c%23)
    + [Multi-threading](#multi-threading)
    + [Log4Net](#log4net)
    + [.editorconfig](#editorconfig)
    + [Quartz.NET](#quartznet)
____

# Libraries

- [Marten](https://martendb.io/)
  * It serves two major functions
    + as a document DB
    + as a store of events like Kafka but the data lives on PostgreSQL
- [StackExchange.Exceptional](https://github.com/NickCraver/StackExchange.Exceptional)
- [Audit.NET](https://github.com/thepirat000/Audit.NET) An extensible
  framework to audit executing operations in .NET and .NET Core
- [bilal-fazlani/tracker-enabled-dbcontext](https://github.com/bilal-fazlani/tracker-enabled-dbcontext)
  Tracker-enabled DbContext offers you to implement full auditing in your
  database
- [microsoft/garnet](https://github.com/microsoft/garnet) a new remote
  cache-store from Microsoft Research
  * [getting started](https://microsoft.github.io/garnet/docs/getting-started)
  * clients such as `StackExchange.Redis` can be used
- [nietras/Sep](https://github.com/nietras/Sep) - a fast .NET CSV Parser;
  cross-platform, trimmable and AOT/NativeAOT compatible; it also has extensive
  documentation of its APIs

# .NET Core

### Links

- [.NET Fiddle](https://dotnetfiddle.net/) - acts like a playground
- [Source code of .NET Core](https://source.dot.net/)
- [sharplab.io](https://sharplab.io/) - live compilation to intermediate language
- [C# 12](./csharp12.md)
- [.NET 8](./net8.md)
- [Porting to .NET Core from .NET
  Framework](https://learn.microsoft.com/en-us/dotnet/core/porting/)
- [Conditional TargetFrameworks for Multi-Targeted .NET SDK Projects on
  Cross-Platform
  Builds](https://weblog.west-wind.com/posts/2017/Sep/18/Conditional-TargetFrameworks-for-MultiTargeted-NET-SDK-Projects-on-CrossPlatform-Builds)
- [Download Visual
  Studio](https://visualstudio.microsoft.com/vs/older-downloads/)

### Tools

##### dotnet-counters

Reference: [Investigate performance counters
(dotnet-counters)](https://docs.microsoft.com/en-us/dotnet/core/diagnostics/dotnet-counters)

```sh
curl -sSL https://aka.ms/dotnet-counters/linux-x64 -o dotnet-counters
chmod +x dotnet-counters
./dotnet-counters monitor -p 1
```

Note that one can check for the architecture in the reference above when using
it on Linux Alpine.

##### dotnet-dump

Reference: [Dump collection and analysis utility
(dotnet-dump)](https://docs.microsoft.com/en-us/dotnet/core/diagnostics/dotnet-dump)

```sh
curl -sSL https://aka.ms/dotnet-dump/linux-x64 -o dotnet-counters
chmod +x dotnet-dump
./dotnet-dump collect -p 1
```

Note that to run this in a Docker container, `--cap-add=SYS_PTRACE` or
`--privileged` is needed.

To analyse the dump,

```sh
./dotnet-dump analyze some_dump_file
```

Commands can be used include

- `clrstack`
- `eeheap -gc`
- `dumpheap -stat`
- `dumpheap -mt some_object_id`
- `dumparray -length 10 some_object_id`
- `db -c 1024 some_object_id`
- `gcroot some_object_id`

Note that one can check for the architecture in the reference above when using
it on Linux Alpine.

##### dotnet-trace

The tool is available on machines with .NET SDK.

For linux machine only has .NET runtime, it can be installed by

```sh
curl -L https://aks.ms/dotnet-trace/linux-x64 -o dotnet-trace
chmod +x dotnet-trace
```

To list processes and its PID running in .NET runtime

```sh
dotnet-trace ps
```

To collect events for 30 seconds

```sh
dotnet-trace collect -p $PID —duration 00:00:30
```

- the resultant trace file can be opened on any Windows machine
  * Visual Studio
  * `perfview`
- profiles can be selected via command line options
  * default profile
    + CPU
  * GC
  * database (EF)
- example use-cases
  * it can report the top methods that uses the largest amount of CPU
- call tree is available

### .NET CLI

##### To check the installed SDKs and runtimes

```sh
dotnet --info
```

##### To create a new solution file

```sh
dotnet new sln -n Name.Space
```

##### To create a new class library project from a solution

```sh
dotnet new classlib -n Name.Space.Library -o src/Name.Space.Library
dotnet sln add src/Name.Space.Library/
```

##### To add a Nuget package to a project

```sh
dotnet add Your.Project.Name package Your.Package.Name --version 1.0.0
```

##### To remove a Nuget package from a project

```sh
dotnet remove Your.Project.Name package Your.Package.Name
```

##### To do a full rebuild

```sh
dotnet build --no-incremental
```

##### To test the current solution or project

```sh
dotnet test
```

##### To test a project

```sh
dotnet test Your.Project.Name
```

##### To kickstart testing without a build

```sh
dotnet test --no-build
```

##### To kickstart a slient test

```sh
dotnet test -v q
```

##### To add unit test coverage

```sh
dotnet tool install --global altcover.global
dotnet tool install --global dotnet-reportgenerator-globaltool
```

and to run tests

```sh
dotnet test /p:CollectCoverage=true
dotnet test /p:AltCover=true
```

##### To run a project

```sh
dotnet run --project Your.Project.Name/
```

##### To run multiple projects

```sh
dotnet run --project Your.Project.Name/ --project Your.Project2.Name/
```

##### To run a DLL

```sh
dotnet run  Your.Project.Name.dll
```

##### To publish for a runtime

```sh
dotnet publish -r alpine.3.7-x64 -o ./output
```

or, without restore

```sh
dotnet publish --no-restore -r alpine.3.7-x64 -o ./output
```

##### To add a migration for a data context

```sh
dotnet ef migrations add YourMigrationName -c YourDataContext -o Path/To/Migration/Output
```

##### To add a migration for a data context in another project

```sh
dotnet ef migrations add YourMigrationName -c YourDataContext -o Path/To/Migration/Output --startup-project ../Your.Parent.Project
```

##### To execute migration

```sh
dotnet ef database update -c YourDataContext --project Your.Project.Name --startup-project Your.Parent.Project
```

##### To remove a migration

```sh
dotnet ef migrations remove YourMigrationName --project Your.Project.Name
```

##### To install format tool

```sh
dotnet tool install -g dotnet-format
```

##### To format code according to .editorconfig

```sh
dotnet format
```

[`.editorconfig`](https://github.com/dotnet/roslyn/blob/master/.editorconfig) of Roslyn team

##### To check if code has been formatted according to .editorconfig

```sh
dotnet format --dry-run --check -v n
```

### Visual Studio

- [productivity features](https://github.com/kendrahavens/ProductivityFeatures)

### Nuget

##### To install Nuget on macOS/Linux [link](https://docs.microsoft.com/en-us/nuget/install-nuget-client-tools#macoslinux)

```sh
sudo curl -o /usr/local/bin/nuget.exe https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
```

Add alias `alias nuget="mono /usr/local/bin/nuget.exe"`

Note that Mono 4.4.2 or later is required.

See also [feature
availability](https://docs.microsoft.com/en-us/nuget/install-nuget-client-tools#feature-availability)

### ASP.NET Core

- [Writing Custom Middleware in ASP.NET Core
  1.0](https://www.exceptionnotfound.net/writing-custom-middleware-in-asp-net-core-1-0)
- [ASP.NET Core Logging with NLog AND
  ElasticSearch](https://damienbod.com/2016/08/20/asp-net-core-logging-with-nlog-and-elasticsearch)
- [Accepting Raw Request Body Content in ASP.NET Core API
  Controllers](https://weblog.west-wind.com/posts/2017/Sep/14/Accepting-Raw-Request-Body-Content-in-ASPNET-Core-API-Controllers)
- [A few notes on creating Class Libraries for ASP.NET
  Core](https://weblog.west-wind.com/posts/2017/Sep/26/A-few-notes-on-creating-Class-Libraries-for-ASPNET-Core)
  (mostly about not including a kitchen sink of dependencies)
- [Dependency injection in ASP.NET
  Core](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection)
- [Create instance from ASP.NET Core dependency
  injection](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection?view=aspnetcore-2.1#call-services-from-main)
- [Services available in
  `ConfigureServices`](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection?view=aspnetcore-2.1#framework-provided-services)
- [Identity management solutions for .NET web
  apps](https://learn.microsoft.com/en-gb/aspnet/core/security/identity-management-solutions)

##### Object lifecycle management

- `IServiceCollection.AddSingleton` one per application
- `IServiceCollection.AddScoped` one per HTTP request
- `IServiceCollection.AddTransient` always create a new instance upon injection
- Not supported features of built-in container
  - Property injection
  - Injection based on name
  - Child containers
  - Custom lifetime management
  - `Func<T>` support for lazy initialization
- The root service provider is created when `BuildServiceProvider` is called.
  The root service provider's lifetime corresponds to the app/server's lifetime
  when the provider starts with the app and is disposed when the app shuts down.
  Scoped services are disposed by the container that created them. If a scoped
  service is created in the root container, the service's lifetime is effectively
  promoted to singleton because it's only disposed by the root container when
  app/server is shut down. Validating service scopes catches these situations
  when `BuildServiceProvider` is called.
- The services available within an ASP.NET Core request from `HttpContext` are
  exposed through the `HttpContext.RequestServices` collection
  - Generally, an app shouldn't use these properties directly. Instead, request
    the types that classes require via class constructors and allow the framework
    inject the dependencies. This yields classes that are easier to test.
- [recommendations](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection?view=aspnetcore-2.1#recommendations)
  - `async`/`await` and `Task` based service resolution is not supported. C# does
    not support asynchronous constructors, therefore the recommended pattern is
    to use asynchronous methods after synchronously resolving the service
  - Avoid storing data and configuration directly in the service container.
    For example, a user's shopping cart shouldn't typically be added to the service
    container. Configuration should use the options pattern. Similarly, avoid
    "data holder" objects that only exist to allow access to some other object.
    It's better to request the actual item via DI.
  - Avoid static access to services (for example, statically-typing
    `IApplicationBuilder.ApplicationServices` for use elsewhere).
  - Avoid using the service locator pattern. For example, don't invoke `GetService`
    to obtain a service instance when you can use DI instead. Another service locator
    variation to avoid is injecting a factory that resolves dependencies at runtime.
    Both of these practices mix Inversion of Control strategies.
  - Avoid static access to `HttpContext` (for example, `IHttpContextAccessor.HttpContext`).

##### Dependency injection

- Constructor injection
  - good practices
    - it makes service cannot be constructed without its dependencies
    - assign injected dependency to a read only field
- Property injection
  - not supported by ASP.NET and third-party container is needed
  - good practices
    - used only for optional dependencies
    - use null object pattern or always check for null
- Service locator
  ```
  public ProductService(IServiceProvider serviceProvider)
  {
    _logger = serviceProvider.GetService<ILogger<ProductService>>() ?? NullLogger<ProductService>.Instance;
  }

  ```
  - good practices
    - should not be used then service type is known in development time
      - it makes unit tests harder to be mocked
    - resolve dependencies in the service constructor if possible
      - resolving in a service method makes the application more complicated and
        error prone
- Service life times
  - types
    - transient
      - created every time upon injection
    - scoped
      - created per scope
      - in ASP.NET, every web request creates a new scope
    - singleton
      - created per DI container
  - good practices
    - use transient whenever possible
      - multi-threading and memory leaks are generally not a concern
    - scoped can be tricky when there is child scope or non-web application
      - it is an optimisation for web application
      - `HttpContextAccessor` implementation uses `AsyncLocal` to share the same
        `HttpContext` during a web request
    - take care of multi-threading and potential memory leak when using
      singleton
    - do not depend on a transient or scoped service from a singleton service
      - ASP.NET default DI container throws exception by default
- Resolving services in a method
  - create a scope using `IServiceProvider.CreateScope()` and use
    `scope.ServiceProvider.GetRequiredService(aServiceType)`
  - injecting a scoped service in a child scope will result in a new instance of
    service being created
- Singleton
  - use thread-safe constructs like `ConcurrentDictionary` to hold a state
  - avoid memory leaks by releasing/disposing objects at the right time and not
    until the end of the application

##### Dynamic dependency injection

In `Startup.cs`,

```csharp
public void ConfigureServices(IServiceCollection services)
{
  services.AddScoped<IPet, Cat>();
  services.AddScoped<IPet, Dog>();
  services.AddScoped<IPet, Hamster>();
  services.AddScoped<Cat>();
  services.AddScoped<Dog>();
  services.AddScoped<Hamster>();
  services.AddScoped<Func<string, IPet>>(serviceProvider => key =>
  {
    switch (key)
    {
      case "Cat":
        return serviceProvider.GetService<Cat>();
      case "Dog":
        return serviceProvider.GetService<Dog>();
      case "Hamster":
        return serviceProvider.GetService<Hamster>();
      default:
        throw new NotImplementedException();
    }
  });
}
```

In a controller,

```csharp
public class TestController
{
  public TestController(Func<string, IPet> serviceLocator)
  {
    this.serviceLocator = serviceLocator;
  }

  public void TestMethod(string petType)
  {
    var pet = serviceLocator(petType);
  }

  Func<string, IPet> serviceLocator;
}
```

##### Mocking IServiceProvider

In controller,

```csharp
public class TestController : ControllerBase
{
    private readonly IServiceProvider _serviceProvider;

    public TestController(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public async Task<string> Get(int id)
    {
        using (var scope = _serviceProvider.GetRequiredService<IServiceScopeFactory>().CreateScope())
        {
            var svc = scope.ServiceProvider.GetRequiredService<TestService>();
            return svc.ReturnMemberValue(id);
        }
    }
}
```

In test,

```csharp
//Arrange
var serviceProvider = new Mock<IServiceProvider>();
serviceProvider
    .Setup(x => x.GetService(typeof(TestService)))
    .Returns(new TestService("MemberValue"));

var serviceScope = new Mock<IServiceScope>();
serviceScope.Setup(x => x.ServiceProvider).Returns(serviceProvider.Object);

var serviceScopeFactory = new Mock<IServiceScopeFactory>();
serviceScopeFactory
    .Setup(x => x.CreateScope())
    .Returns(serviceScope.Object);

serviceProvider
    .Setup(x => x.GetService(typeof(IServiceScopeFactory)))
    .Returns(serviceScopeFactory.Object);

var sut = new TestController(serviceProvider.Object);

//Act
var actual = sut.Get(myIntValue);

//Asssert
//...
```

##### Environment variables

- Environment variables are available in `IConfiguration` objects
- Setting environment variable `Logging:LogLevel:Default` to `INFO` can change
  log level of an application

##### Authentication

- CSRF (Cross-site Request Forgery) applies only in cookie-based authentication
    and it is not a concern in token-based authentication even the token could
    be saved in local storage
- [ASP.NET OAuth
  providers](https://github.com/aspnet-contrib/AspNet.Security.OAuth.Providers/tree/dev/src)

##### SameSite Cookie

References
- [Upcoming SameSite Cookie Changes in ASP.NET and ASP.NET
Core](https://devblogs.microsoft.com/aspnet/upcoming-samesite-cookie-changes-in-asp-net-and-asp-net-core/)
- [Chromium - SameSite Updates](https://www.chromium.org/updates/same-site)

- originally it was an opt-in property
- possible values
  - `Lax`
    - cookie should be sent on navigation within the same site, or
    - through `GET` navigation to your site from other sites
    - the new [Chrome default](https://www.chromium.org/updates/same-site)
  - `Strict`
    - cookie to requests which only originated from the same site
  - (Unspecified)
    - the old default
    - place no restrictions on how the cookie flowed in requests
    - OpenIdConnect authentication operations (e.g. login, logout), and other
      features that send POST requests from an external site to the site
      requesting the operation, can use cookies for correlation and/or CSRF
      protection. These operations would need to opt-out of `SameSite`, by not
      setting the property at all, to ensure these cookies will be sent during
      their specialized request flows
  - `None`
    - a new value
    - with Chrome's new implementation, site will have to use cookies whose
      `SameSite` property is set to this value for features like OpenIdConnect
    - old browser may understand this value as `Strict` and, thus, site will
      need to add user agent sniffing to determine the `SameSite` value to set
- packet sniffing

```csharp
private void CheckSameSite(HttpContext httpContext, CookieOptions options)
{
    if (options.SameSite == SameSiteMode.None)
    {
        var userAgent = httpContext.Request.Headers["User-Agent"].ToString();
        // TODO: Use your User Agent library of choice here.
        if (/* UserAgent doesn’t support new behavior */)
        {
               // For .NET Core < 3.1 set SameSite = (SameSiteMode)(-1)
               options.SameSite = SameSiteMode.Unspecified;
         }
    }
}

public void ConfigureServices(IServiceCollection services)
{
    services.Configure<CookiePolicyOptions>(options =>
    {
        options.MinimumSameSitePolicy = SameSiteMode.Unspecified;
        options.OnAppendCookie = cookieContext =>
            CheckSameSite(cookieContext.Context, cookieContext.CookieOptions);
        options.OnDeleteCookie = cookieContext =>
            CheckSameSite(cookieContext.Context, cookieContext.CookieOptions);
    });
}

public void Configure(IApplicationBuilder app)
{
    app.UseCookiePolicy(); // Before UseAuthentication or anything else that writes cookies.
    app.UseAuthentication();
    // …
}
```

##### HttpClient with cookies

```csharp
var server = "https://test.com";
var cookieContainer = new CookieContainer();
using (var handler = new HttpClientHandler() { CookieContainer = cookieContainer, AllowAutoRedirect = false })
{
  using (var clientCode = new HttpClient(handler) { BaseAddress = server })
  {
    var request = new HttpRequestMessage(HttpMethod.Get, $"/hello/");
    cookieContainer.Add(server, new Cookie("name", "value"));
    return clientCode.SendAsync(request).GetAwaiter().GetResult();
  }
}
```

##### Paths

- `IHostingEnvironment.ContentRootPath` points to the directory of the web
    deployment
  - `${IHostingEnvironment.ContentRootPath}/bin` points to the directory of
      containing DLLs
- `IHostingEnvironment.WebRootPath` generally points to `wwwroot` directory and
    may not available in every application

##### Graceful termination

Reference: [Graceful termination in Kubernetes with ASP.NET
Core](https://blog.markvincze.com/graceful-termination-in-kubernetes-with-asp-net-core/)

ASP.NET performs graceful termination automatically. However, the timeout of
graceful termination is 5 seconds. Upon receiving `TERM` signal, ASP.NET will
start finishing the existing requests but it would still process new incoming
requests. The event of the signal can be captured by
`IApplicationLifetime.ApplicationStopping.Register`.

Once shutdown timeout has been reached, all the un-finished requests will be
terminated. The event of termination can be captured by
`IApplicationLifetime.ApplicationStopped.Register`.

To extend the shutdown timeout, chain `UseShutdownTimeout` to `UseStartup` in
`Program.cs`.

```csharp
public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
  WebHost
    .CreateDefaultBuilder(args)
    .UseConfiguration(new ConfigurationBuilder().AddCommandLine(args).Build())
    .UseStartup<Startup>()
    .UseShutdownTimeout(TimeSpan.FromSeconds(30));
```

Note that the default timeout is 5 seconds.

##### Clean architecture

- [ardlis/CleanArchitecture](https://github.com/ardalis/CleanArchitecture)
- `dotnet new install Ardalis.CleanArchitecture.Template` to install template
  for creating a new solution
- `dotnet new clean-arch -o YourNameSpace.SolutionName` to create a new solution

### [Entity Framework](./entity-framework.md)

### Async

#### References

- [ConfigureAwait FAQ](https://devblogs.microsoft.com/dotnet/configureawait-faq/)
- [Should I await a Task with .ConfigureAwait(false)?](https://github.com/Microsoft/vs-threading/blob/master/doc/cookbook_vs.md#should-i-await-a-task-with-configureawaitfalse)
- [There is no thread](https://blog.stephencleary.com/2013/11/there-is-no-thread.html)
- [ASP.NET Core SynchronizationContext](https://blog.stephencleary.com/2017/03/aspnetcore-synchronization-context.html)
- [Understanding the Whys, Whats, and Whens of ValueTask](https://devblogs.microsoft.com/dotnet/understanding-the-whys-whats-and-whens-of-valuetask/)
- [Eliding Async and Await](https://blog.stephencleary.com/2016/12/eliding-async-await.html)
- [Don't Block on Async Code](https://blog.stephencleary.com/2012/07/dont-block-on-async-code.html)
- [There is no thread](https://blog.stephencleary.com/2013/11/there-is-no-thread.html)
- [Recommended patterns for CancellationToken](https://devblogs.microsoft.com/premier-developer/recommended-patterns-for-cancellationtoken/)

#### ConfigureAwait

- Different types of application has a different derived-type of
  `SynchronizationContext`. Examples are Windows Forms, Windows Presentation
  Foundation, Windows RunTime (WinRT) where all have a different implementation
  of `SynchronizationContext.Post` which affects how code is executed after the
  `await` line.
- `SynchronizationContext` provides a single API that can be used to queue
  a delegate for handling however the creator of the implementation desires,
  without needing to know the details of that implementation
- `SynchronizationContext` is a general abstraction for a "Scheduler"
- Individual frameworks sometimes have their own abstractions for a scheduler.
  Just as `SynchronizationContext` provides a virtual `Post` method to queue
  a delegate’s invocation, `TaskScheduler` provides an abstract `QueueTask`
  method.
- The default scheduler as returned by `TaskScheduler.Default` is the thread
  pool
  - it is possible to derive from `TaskScheduler` and override the
    relevant methods to achieve arbitrary behaviors for when and where a `Task`
    is invoked
    - example: `ConcurrentExclusiveSchedulerPair`
- `await`ing a `Task` pays attention by default to
  `SynchronizationContext.Current`, as well as to `TaskScheduler.Current`
  - the compiler transforms the code to ask (via calling `GetAwaiter`) the
    “awaitable” (in this case, the `Task`) for an “awaiter”
  - awaiter is responsible for hooking up the callback (often referred to as
    the “continuation”) that will call back into the state machine when the
    awaited object completes, and it does so using whatever context/scheduler
    it captured at the time the callback was registered.
- `ConfigureAwait` provides a hook to change the behaviour of how the `await`
  behaves via a custom awaiter
  - for `ConfigureAwait(continueOnCapturedContext: false)`, it ignores the
    current synchronization context and the current task scheduler
- `ConfigureAwait(false)` advantages
  - improving performance
    - avoid the extra work of queuing the callback; especially useful for very
      hot paths
    - avoid the unnecessary thread static accesses
    - utilize optimisations from the framework
  - avoiding deadlocks
    - deadlocks could be resulted with use of `.Wait()`, `.Result` or
      `.GetAwaiter().GetResult()`; especially true when the current
      synchronization context has a very limited number of concurrent
      operations (like a UI thread)
    - it is not a problem for ASP.NET in general
- scenarios to use `ConfigureAwait(false)`
  - general-purpose library
    - almost all .NET Core runtime libraries use it
  - exceptions
    - a library takes delegates to be invoked
- `ConfigureAwait(false)` does not guarantee the callback would not be run in
  the original context (especially when `Task` has already completed)
- `ConfigureAwait(false)` should not be only applied to the first `await`
- the awaiter pattern requires awaiters to expose
  - `IsCompleted` property
  - `GetResult` method
  - `OnCompleted` method (and `UnsafeOnCompleted`)
- `ConfigureAwait` only affects the behaviour of `OnCompleted`
  - `task.ConfigureAwait(false).GetAwaiter().GetResult()` is equivalent to
    `task.GetAwaiter().GetResult()`
- `ConfigureAwait(false)` causes the compiler to interact with
  `ConfiguredTaskAwaiter` instead of `TaskAwaiter` and it means to always
  schedule continuations to the threadpool (or in some cases inline the
  continuation immediately after the `Task` itself is completed)
- use `await TaskScheduler.Default;` before CPU intensive, free-threaded work
- `ConfigureAwait(false)` may not actually move CPU intensive work off the UI
  thread since it only makes the switch on the first yielding await
- `ConfigureAwait(false)` contributes to threadpool starvation when the code
  using it is called in the context of a `JoinableTaskFactory.Run` delegate
  (where `JoinableTaskFactory` is used when developer wants to avoid deadlocks)
- `ConfigureAwait(ConfigureAwaitOptions)` introduced since .NET 8
  * `ConfigureAwaitOptions` is a `Flags` enum (implies combination is possible)
    + `None`
    + `ContinueOnCapturedContext`
    + `SuppressThrowing`
    + `ForceYielding`
  * the default flag is `None`
    + there is no change to the default behaviour of `ConfigureAwait`
    + when this method signature is used, `None` is included unless
      `ContinueOnCapturedContext` is explicitly included
  * `ConfigureAwait(ConfigureAwaitOptions.ContinueOnCapturedContext)` is
    equivalent to `ConfigureAwait(true)`
  * `ConfigureAwait(ConfigureAwaitOptions.None)` is equivalent to
    `ConfigureAwait(false)`
  * `await task.ConfigureAwait(ConfigureAwaitOptions.SuppressThrowing);` is
    equivalent to `try { await task.ConfigureAwait(false); } catch { }`
  * `ForceYielding` schedules the continuation to the threadpool even if the
    task is already completed (where the normal behaviour is to run the task on
    the current thread)
    + similar to `Task.Yield` but not the same
      + `Yield` returns a special awaitable that always claims to be not
        completed but schedule its continuations immediately
      + `Yield` will resume on the captured context
      + equivalent to `await Task.CompletedTask.ConfigureAwait(ConfigureAwaitOptions.ForceYielding | ConfigureAwaitOptions.ContinueOnCapturedContext)`
- ASP.NET Core specifics
  - classic ASP.NET has its own `SynchronizationContext` but ASP.NET Core does
    not (mostly because ASP.NET Core is context-less, like no
    `HttpContext.Current`)
  - there is no context captured by `await` and this means that blocking on
    asynchronous code will not cause a deadlock. `Task.GetAwaiter().GetResult()`
    (or `Task.Wait` or `Task<T>.Result`) can be used without fear of deadlock.
    But it should be avoided to give up scalability.
  - since there is no context anymore, there is no need for
    `ConfigureAwait(false)`
- the following code may result `results` in random order
```csharp
private HttpClient _client = new HttpClient();

async Task<List<string>> GetBothAsync(string url1, string url2)
{
    var result = new List<string>();
    var task1 = GetOneAsync(result, url1);
    var task2 = GetOneAsync(result, url2);
    await Task.WhenAll(task1, task2);
    return result;
}

async Task GetOneAsync(List<string> result, string url)
{
    var data = await _client.GetStringAsync(url);
    result.Add(data);
}
```

#### `async`

- it ensures exceptions are caught and returned in `Task`

#### ValueTask

- `ValueTask` can be used instead of `Task` if the hot path of an `async`
  method does not have `await` lines involved
- `ValueTask` lives on stack rather than on heap
- `ValueTask` cannot be re-used (or use `ValueTask.AsTask()`)
- avoid creating a local variable of type `ValueTask<T>` (due to possible
  re-use)
- do not `ValueTask.GetAwaiter().GetResult()` as it is likely lead to race
  condition
- advanced usage

```csharp
int bytesRead;
{
    ValueTask<int> readTask = _connection.ReadAsync(buffer);
    if (readTask.IsCompletedSuccessfully)
    {
        bytesRead = readTask.Result;
    }
    else
    {
        using (_connection.RegisterCancellation())
        {
            bytesRead = await readTask;
        }
    }
}
```

- one of the non-use-case is where one path leads to database retrieval and the
  other path leads to a Redis read
  - since both lead to a remote call, `ValueTask` should not be used

#### CancellationToken

- do not cancel if the point of no cancellation has been passed
  - to cancel, reverting all the changes made is not a must but it must be in
    a valid state that users of the method can expect
  - `OperationCanceledException` should only be thrown after the method
    reaching a valid state (be it a total revert or partial revert)
  - pass `CancellationToken` once the point of no cancellation has been passed
- `cancellationToken.ThrowIfCancellationRequested()` checks and throws
  `OperationCanceledException`
- propagate `CancellationToken` as much as possible
- do not throw `OperationCanceledException` after all the work has been
  completed; leave it to caller to decide if how to handle the cancellation
- input validation before handling cancellation checks
- if `cancellationToken.CanBeCanceled` returns `false` (usage of
  `CancellationToken.None`), the method could use more efficient processing
  like parallelism
- use `CancellationToken` method parameter as the last method
  parameter
- make `CancellationToken` optional in public APIs; mandatory, otherwise
- `TaskCanceledException` inherits `OperationCanceledException`
- exception handling pattern
```csharp
try
{
  await httpClient.SendAsync(form, cancellationToken);
}
catch (OperationCanceledException)
{
  // clean up code here

  throw;
}
```

#### Code smells

- `Task.Wait()`
- `Task.Result`
- `async void` - but there are exceptions

#### GetResult

The following code is not recommended.

```csharp
void DoSomething()
{
    DoSomethingElseAsync().Wait();
    DoSomethingElseAsync().GetAwaiter().GetResult();
    var result = CalculateSomethingAsync().Result;
}
```

It can be replaced with the following.

```csharp
void DoSomething()
{
    // to manage SynchronizationContext
    var context = new JoinableTaskContext();

    var joinableTaskFactory = new JoinableTaskFactory(context);

    joinableTaskFactory.Run(async delegate
    {
        await DoSomethingElseAsync();
        await DoSomethingElseAsync();
        var result = await CalculateSomethingAsync();
    });
}
```

#### Tricks

- if `return await` and the is no `try`/`catch` or `using`, keyword `async` and
  `await` could be removed to avoid state machine but the code is much more
  tricky to be maintained

- to handle async call in a constructor

```csharp
static async void HandleSafeFireAndForget<TException>(this Task task, bool continueOnCapturedContext, Action<TException>? onException) where TException : Exception
{
    try
    {
        await task.ConfigureAwait(continueOnCapturedContext);
    }
    catch (TException ex) when (onException != null)
    {
        HandleException(ex, onException);
    }
}
```

### Reducing heap consumption

- `System.Array.CopyTo`
- `System.Text.StringBuilder`

### No reflection

#### Constructor

```csharp
public delegate object ConstructorDelegate();

private ConstructorDelegate GetConstructor(string typeName)
{
    Type t = Type.GetType(typeName);
    ConstructorInfo ctor = t.GetConstructor(new Type[0]);
    string methodName = t.Name + "Ctor";
    DynamicMethod dm = new DynamicMethod(methodName, t, new Type[0], typeof(Activator));
    ILGenerator lgen = dm.GetILGenerator();
    lgen.Emit(OpCodes.Newobj, ctor);
    lgen.Emit(OpCodes.Ret);
    return dm.CreateDelegate(typeof(ConstructorDelegate)) as ConstructorDelegate;
}
```

#### Properties

```csharp
public delegate object PropertyGetDelegate(object obj);
public delegate void PropertySetDelegate(object obj, object value);

private PropertyGetDelegate GetPropertyGetter(string typeName, string propertyName)
{
    Type t = Type.GetType(typeName);
    PropertyInfo pi = t.GetProperty(propertyName);
    MethodInfo getter = pi.GetGetMethod();

    DynamicMethod dm = new DynamicMethod("GetValue", typeof(object), new Type[] { typeof(object) }, typeof(object), true);
    ILGenerator lgen = dm.GetILGenerator();
    lgen.Emit(OpCodes.Ldarg_0);
    lgen.Emit(OpCodes.Call, getter);

    if (getter.ReturnType.GetTypeInfo().IsValueType)
    {
        lgen.Emit(OpCodes.Box, getter.ReturnType);
    }
    lgen.Emit(OpCodes.Ret);

    return dm.CreateDelegate(typeof(PropertyGetDelegate)) as PropertyGetDelegate;
}

private PropertySetDelegate GetPropertySetter(string typeName, string propertyName)
{
    Type t = Type.GetType(typeName);
    PropertyInfo pi = t.GetProperty(propertyName);
    MethodInfo setter = pi.GetSetMethod(false);

    DynamicMethod dm = new DynamicMethod("SetValue", typeof(void), new Type[] { typeof(object), typeof(object) }, typeof(object), true);
    ILGenerator lgen = dm.GetILGenerator();
    lgen.Emit(OpCodes.Ldarg_0);
    lgen.Emit(OpCodes.Ldarg_1);

    Type parameterType = setter.GetParameters()[0].ParameterType;
    if (parameterType.GetTypeInfo().IsValueType)
    {
        lgen.Emit(OpCodes.UnBox_Any, parameterType);
    }
    lgen.Emit(OpCodes.Call, setter);
    lgen.Emit(OpCodes.Ret);

    return dm.CreateDelegate(typeof(PropertySetDelegate)) as PropertySetDelegate;
}
```

### Mac Installation

The SDK installations are located at

```console
/usr/local/share/dotnet/sdk/
```

### Kestrel

Kestrel uses `libuv` for transport layer (whereas Kestrel handles hosting
layer). `libuv` handles I/O work from Kestrel and uses a single-threaded event
loop model. All non I/O is done in managed code on standard .NET worker threads
in Kestrel. Kestrel supports multiple event loops. The number of event loops is
based on the number of logical processors available or overridden by the
configuration.

Each connection is bounded to a user thread in Kestrel and all I/O operation
requests are coming from this thread. When an I/O call is requested, Kestrel
marshal the `libuv` thread to perform the actual I/O.

### Garbage collection

#### Reference

- [Fundamentals of garbage
  collection](https://docs.microsoft.com/en-us/dotnet/standard/garbage-collection/fundamentals)

#### Concept of memory

- Each process has its own, separate virtual address space. All processes on
  the same computer share the same physical memory and the page file
- 3 states of virtual memory
  - free
  - reserved - available but cannot store data until committed
  - committed - the block of memory is assigned to physical storage
- When a virtual memory allocation is requested, the virtual memory manager has
  to find a single free block that is large enough to satisfy that allocation
  request.
- Out of memory if there isn't enough virtual address space to reserve or
  physical space to commit
- The page file is used even if physical memory pressure is low.
  - The first time physical memory pressure is high and it backs up some of the
    data that is in physical memory to a page file. That data is not paged
    until it's needed, so it's possible to encounter paging in situations where
    the physical memory pressure is low.

#### Conditions for a garbage collection (any one)

- the system has low physical memory
- the memory that is used by allocated objects on the managed heap surpasses
an acceptable threshold. This threshold is continuously adjusted as the
process runs.
- `GC.Collect()`

#### Managed heap

- There is a managed heap for each managed process. All threads in the process
  allocate memory for objects on the same heap.
- The size of segments allocated by the garbage collector is
  implementation-specific and is subject to change at any time
- large object heap contains very large objects that are 85k bytes or larger
  - the size configurable via environment variable `COMPlus_GCLOHThreshold` (in
    hex)
  - since large objects are not efficient to be moved between generations, .NET
    will allocate such objects to generation `2` directly and skipping
    generation `0` and `1`

#### Generations

- Generation 0
  - the youngest generation and contains short-lived objects
    - An example of a short-lived object is a temporary variable. Garbage
      collection occurs most frequently in this generation.
  - Newly allocated objects form a new generation of objects and are
    implicitly generation 0 collections. However, if they are large objects,
    they go on the large object heap in a generation 2 collection.
- Generation 1
- Generation 2
  - This generation contains long-lived objects. An example of a long-lived
    object is an object in a server application that contains static data
    that's live for the duration of the process.
- Collecting a generation means collecting objects in that generation and all
  its younger generations.
  - A generation 2 garbage collection is also known as a full garbage
    collection, because it reclaims all objects in all generations (that is,
    all objects in the managed heap).
- Objects that are not reclaimed in a garbage collection are known as survivors
  and are promoted to the next generation
- When the garbage collector detects that the survival rate is high in
  a generation, it increases the threshold of allocations for that generation.
  The next collection gets a substantial size of reclaimed memory. The CLR
  continually balances two priorities: not letting an application's working set
  get too large by delaying garbage collection and not letting the garbage
  collection run too frequently.
- Generation 0 and 1 are ephemeral generations
- Each new segment acquired by the garbage collector becomes the new ephemeral
  segment and contains the objects that survived a generation 0 garbage
  collection. The old ephemeral segment becomes the new generation 2 segment.
- Sizes of ephemeral segment
  - Workstation GC - 25 6MB
  - Server GC - 4 GB
  - Server GC with > 4 logical CPUs - 2 GB
  - Server GC with > 8 logical CPUs - 1 GB
- Generation 2 objects can use multiple segments
- The amount of freed memory from an ephemeral garbage collection is limited to
  the size of the ephemeral segment

#### Process of garbage collection

- A marking phase that finds and creates a list of all live objects
- A relocating phase that updates the references to the objects that will be
  compacted
- A compacting phase that reclaims the space occupied by the dead objects and
  compacts the surviving objects. The compacting phase moves objects that have
  survived a garbage collection toward the older end of the segment.
- Because generation 2 collections can occupy multiple segments, objects that
  are promoted into generation 2 can be moved into an older segment. Both
  generation 1 and generation 2 survivors can be moved to a different segment
- Ordinarily, the large object heap (LOH) is not compacted, because copying
  large objects imposes a performance penalty.
  - the behavior can be changed by
    `System.Runtime.GCSettings.LargeObjectHeapCompactionMode`
  - the LOH is automatically compacted when a hard limit is set by specifying
    either
    - a memory limit on a container, or
    - on .NET Core 3.0 and after, environment variable
      `COMPlus_GCHeapHardLimit` or `COMPlus_GCHeapHardLimitPercent`
- Before a garbage collection starts, all managed threads are suspended except
  for the thread that triggered the garbage collection

#### Manipulate unmanaged resources

- To perform the cleanup, you can make the managed object
  [finalizable](https://docs.microsoft.com/en-us/dotnet/api/system.object.finalize)
- When a finalizable object is discovered to be dead, its finalizer is put in
  a queue so that its cleanup actions are executed, but the object itself is
  promoted to the next generation. Therefore, you have to wait until the next
  garbage collection that occurs on that generation (which is not necessarily
  the next garbage collection) to determine whether the object has been
  reclaimed.

#### Workstation and server garbage collection

- CLR provides the following types of garbage collection
  - Workstation GC
    - the default and default to use background garbage collection
    - The collection occurs on the user thread that triggered the garbage
      collection and remains at the same priority
      - the garbage collector must compete with other threads for CPU time
      - is always used on a computer that has only one processor, regardless of
        configuration setting
  - Server GC
    - The collection occurs on multiple dedicated threads that are running at
      `THREAD_PRIORITY_HIGHEST` priority level
    - A heap and a dedicated thread to perform garbage collection are provided
      for each CPU, and the heaps are collected at the same time.
    - it is faster than workstation GC on the same size heap in general
    - it is recommended to use workstation GC instead if the number of
      processes are really high.
- configurable using environment variable `COMPlus_gcServer`
  - `0` for workstation
  - `1` for server

#### Background workstation garbage collection

- performed on a dedicated thread and applies only to generation 2 collections
- enabled by default
  - configure via environment variable `COMPlus_gcConcurrent`
- during background GC, the dedicated thread frequently checks if there is
  a need for foreground GC (Gen 0 and Gen 1). If there is one, it will suspend
  until the foreground GC is done
- background GC can remove dead objects in ephemeral generations and it can
  also expand the heap if needed during a generation 1 garbage collection

#### Typical issues

- a very high percentage time paused for garbage collection
- individual GCs with unusually long pauses
  - likely a GC thread problem
- excessively induced GCs (induced GCs vs total GCs)
- excessive number of gen2 GCs
- long suspension issues
  - suspension usually should take much less than 1ms
- excessive number of pinned handles
  - it is a concern if there are hundreds of it especially if it is during
    ephemeral GCs

### Code Analysis

#### References

- [Fxcop rules](https://docs.microsoft.com/en-us/visualstudio/code-quality/fxcop-rule-port-status)
- [StyleCopAnalyzers](https://github.com/DotNetAnalyzers/StyleCopAnalyzers)
- [StyleCop rules](https://github.com/DotNetAnalyzers/StyleCopAnalyzers/blob/master/DOCUMENTATION.md)

#### Adding code analysis warnings to a project

```sh
dotnet add your-project-name package Microsoft.CodeAnalysis.FxCopAnalyzers
dotnet add your-project-name package StyleCop.Analyzers
```

### Cultures

#### Invariant mode

References:

- [Runtime configuration options for
  globalization](https://learn.microsoft.com/en-us/dotnet/core/runtime-config/globalization)
- [.NET Core Globalization Invariant
  Mode](https://github.com/dotnet/runtime/blob/main/docs/design/features/globalization-invariant-mode.md)
- [.NET Docker images](https://github.com/dotnet/dotnet-docker/)

- `DOTNET_SYSTEM_GLOBALIZATION_INVARIANT`
  - determines whether a .NET Core app runs in globalization-invariant mode
    without access to culture-specific data and behaviour
  - `0` access to cultural data
  - `1` run in invariant mode
  - not setting this environment variable is equivalent setting value to `0`
- globalization data is not sourced from .NET by the underlying OS
  - installation of package [ICU](https://icu.unicode.org/) on Linux is required
  - alpine
    - only `:sdk` images are installed with `icu-libs` and `icu-data-full` and
      some of the images does not have `DOTNET_SYSTEM_GLOBALIZATION_INVARIANT`
      set correctly
- in invariant culture
  - date formatting and parsing will be affected
  - number formatting and parsing will be affected
  - no currency symbols
  - casing will be done in ASCII range only
  - sorting is done as ordinal only
  - Internationalized Domain Names (IDN) is not supported
  - on Linux, only standard time zone names are used but not the ones from `ICU`

### Forwarding headers behind reverse proxy

Reference: [Configure ASP.NET Core to work with proxy servers and load
balancers](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/proxy-load-balancer)

There is
[ForwardedHeadersMiddleware](https://github.com/dotnet/aspnetcore/blob/main/src/Middleware/HttpOverrides/src/ForwardedHeadersMiddleware.cs)
helping to handle forwarded headers after traffic passing through a reverse
proxy. `ForwardedHeadersOptions` can be used to configure this middleware.

```csharp
builder.Services.Configure<ForwardedHeadersOptions>(options =>
{
    options.KnownProxies.Add(IPAddress.Parse("127.0.10.1"));
});
```

And it has to be configured before `app.UseForwardedHeaders()`.

- environment variable `ASPNETCORE_FORWARDEDHEADERS_ENABLED`
  * setting it to `1` enables `ForwardedHeadersMiddleware`
  * use this setting only when it is impossible to set `KnownNetworks` and
    `KnownProxies` (such as a Nginx ingress on Kubernetes where its private IP
    address could be changed at anytime)
- `KnownNetworks`
  - address ranges of known networks to accept forwarded headers from
  - the default is an `IList<IPNetwork>` containing a single entry for
    `IPAddress.Loopback` (which is `127.0.0.1`)
- `KnownProxies`
  * addresses of known proxies to accept forwarded headers from
  * The default is an `IList<IPAddress>` containing a single entry for
    `IPAddress.IPv6Loopback`
- forwarded headers can have more than 1 values and the middleware processes
  headers in reverse order from right to left
  - however, since `ForwardLimit` is default to `1`, only one value will be
    returned from the headers
    - setting `ForwardLimit` to `null` disables this limits but it has security
      impacts (header spoofing)

To troubleshoot forwarded headers,

```csharp
builder.Services.AddHttpLogging(options =>
{
    options.LoggingFields = HttpLoggingFields.RequestPropertiesAndHeaders;
});

app.UseForwardedHeaders();
app.UseHttpLogging();

app.Use(async (context, next) =>
{
    // Connection: RemoteIp
    app.Logger.LogInformation("Request RemoteIp: {RemoteIpAddress}",
        context.Connection.RemoteIpAddress);

    await next(context);
});
```

and have the following in `appsettings.json` if needed

```json
{
  "Logging": {
    "LogLevel": {
      "Microsoft.AspNetCore.HttpLogging": "Information"
    }
  }
}
```

### IPv6

[DualMode](https://learn.microsoft.com/en-gb/dotnet/api/system.net.sockets.socket.dualmode)
sockets is being used in `SocketsHttpHandler`. This allows us to handle IPv4
traffic from an IPv6 socket, and is considered to be a favourable practice by
[RFC 1933](https://www.rfc-editor.org/rfc/rfc1933).

Environment variable `DOTNET_SYSTEM_NET_DISABLEIPV6` can be set to `1` to
disable IPv6.

### `System.Drawing.Common`

If the .NET app uses the `System.Drawing.Common` assembly, `libgdiplus` will
also need to be installed. Because `System.Drawing.Common` is no longer
supported on Linux, this only works on .NET 6 and requires setting the
`System.Drawing.EnableUnixSupport` runtime configuration switch.

In `runtimeconfig.template.json`, specify the property like

```json
{
  "configProperties": {
    "System.Drawing.EnableUnixSupport": true
  }
}
```

To generate a runtime configuration file in publish process, add the following
property in `.csproj`.

```xml
<GenerateRuntimeConfigurationFiles>true</GenerateRuntimeConfigurationFiles>
```

To install `libgdiplus` on Alpine 3.16 or newer (older versions don't include
the package)

```sh
apk add libgdiplus
```

### Alpine

Required installations

```sh
apk add bash icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib
```

### Cryptography

To load public key from JSON Web Key definition

```csharp
var keys = LoadKeys(new Uri("https://test.com/.well-known/openid-configuration/jwks"));

public static IEnumerable<RSA> LoadKeys(Uri uri)
{
    var client = new HttpClient();
    var response = client.GetAsync(uri.ToString()).Result;
    var content = response.Content;
    var json = content.ReadAsStringAsync().Result;
    var keySet = new JsonWebKeySet(json);

    foreach (var jwk in keySet.Keys)
    {
        var rsaParams = new RSAParameters
        {
            Modulus = Base64UrlEncoder.DecodeBytes(jwk.N),
            Exponent = Base64UrlEncoder.DecodeBytes(jwk.E),
        };

        yield return RSA.Create(rsaParams);
    }
}
```

To load public key from JSON Web Key definition

```csharp
var keys = LoadKeys(new Uri("https://test.com/.well-known/openid-configuration/jwks"));

public static IEnumerable<RSA> LoadKeys(Uri uri)
{
    var client = new HttpClient();
    var response = client.GetAsync(uri.ToString()).Result;
    var content = response.Content;
    var json = content.ReadAsStringAsync().Result;
    var keySet = new JsonWebKeySet(json);

    foreach (var jwk in keySet.Keys)
    {
        var rsaParams = new RSAParameters
        {
            Modulus = Base64UrlEncoder.DecodeBytes(jwk.N),
            Exponent = Base64UrlEncoder.DecodeBytes(jwk.E),
            D = Base64UrlEncoder.DecodeBytes(jwk.D),
            DP = Base64UrlEncoder.DecodeBytes(jwk.DP),
            DQ = Base64UrlEncoder.DecodeBytes(jwk.DQ),
            P = Base64UrlEncoder.DecodeBytes(jwk.P),
            Q = Base64UrlEncoder.DecodeBytes(jwk.Q),
            InverseQ = Base64UrlEncoder.DecodeBytes(jwk.QI),
        };

        yield return RSA.Create(rsaParams);
    }
}
```

### Snapshot testing

- [Verify](https://github.com/VerifyTests/Verify/) a library to generate and
  verify snapshots made during unit tests

### Prometheus

- [prometheus-net.DotNetRuntime](https://github.com/djluck/prometheus-net.DotNetRuntime)
  a third-party library to expose .NET runtime metrics to Prometheus especaially
  in garbage collection and JIT compilation

### OpenTelemetry

Reference: [.NET observability with
OpenTelemetry](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/observability-with-otel)

- The .NET OpenTelemetry implementation is a little different from other
  platforms, as .NET provides logging, metrics, and activity APIs in the
  framework. That means OTel doesn't need to provide APIs for library authors to
  use.
- data types
  * logging
    + `Microsoft.Extensions.Logging.ILogger`
  * metrics
    + `System.Diagnostics.Metrics.Meter`
  * tracing
    + `System.Diagnostics.Activity` and `System.Diagnostics.ActivitySource`
- [OpenTelemetry
  packages](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/observability-with-otel#opentelemetry-packages)

### Regular Expression (regex)

See also [regex](../regex.md)

##### Ignore case

```cs
Regex r = new Regex("abc", RegexOptions.IgnoreCase);
```

##### Compiled expression

```cs
Regex r = new Regex("(a(b)c|def)", RegexOptions.Compiled);
```

Note that it takes time to compile. Thus, if it is not a hot path, the time
takes to compile may not worth it.

##### Capture groups

```cs
Regex r = new Regex("(a(b)c|def)");
var length = regex.Match(input!).Groups.Count; // 3
```

##### Compiled expression

It generates IL code from the regular expression pattern instead of being
interpreted at runtime. It is faster but it takes time to compile.

```cs
Regex r = new Regex("(a(b)c|def)", RegexOptions.Compiled);
```

##### Generate source

```cs
static partial class Example
{
  [GeneratedRegex("abc|def")]
  public static partial Regex DemoRegex();
}
```

This ignores `RegexOptions.Compiled` automatically.

### Dictionaries

- `Hashtable`
  * good read speed (no lock required)
  * about as lightweight as dictionary
  * more expensive to mutate
  * no generics
- `Dictionary`
  * as an immutable object
    + best read speed
    + lightweight to create but heavy update
      + copy and modify on mutation
- `ConcurrentDictionary`
  * good read speed even in the face of concurrency
  * it is a heavyweight object to create and slower to update
  * better than a dictionary with lock
    + poor read speed
    + lightweight to create
    + “medium” update speed
- `ImmutableDictionary`
  * poorish read speed
  * no locking required but more allocations require to update than a dictionary

### Microsoft.IO.RecyclableMemoryStream

- benefits
  * reduce the cost of garbage collection incurred by frequent large allocations
  * incur far fewer gen 2 GCs, and spend far less time paused due to GC
  * avoid memory fragmentation
  * provide excellent debuggability and logging
  * provide metrics for performance tracking
- features
  * rather than pooling the streams themselves, the underlying buffers are
    pooled; `Dispose` pattern to release the buffers back to the pool
  * thread-safe (streams themselves are inherently not thread-safe)
  * each stream can be tagged with an identifying string that is used in
    logging; helpful when finding bugs and memory leaks relating to incorrect
    pool use
- how it works
  * `RecyclableMemoryStream` improves GC performance by ensuring that the larger
    buffers used for the streams are put into the gen 2 and stay there forever;
    this should cause full colections to happen less frequently
  * `RecyclableMemoryStream` maintains two separate pools objects
    + small pool
    + large pool
      + linear (default)
        + for cases of un-predictable large buffer size
      + exponential
        + for cases of longer stream length is unlikely and a lot of streams in
          the smaller size
- to avoid accidental data leakage, set `ZeroOutBuffer` to `true`
- examples

```cs
using (var stream = manager.GetStream("Program.Main"))
{
    stream.Write(sourceBuffer, 0, sourceBuffer.Length);
}
```

```cs
// note that source buffer will be copied into a buffer owned by the pool
var stream = manager.GetStream("Program.Main", sourceBuffer, 0, sourceBuffer.Length);
```

```cs
var options =
    new RecyclableMemoryStreamManager.Options()
    {
        BlockSize = 1024,
        LargeBufferMultiple = 1024 * 1024,
        MaxBufferSize = 16* 1024 * 1024,
        GenerateCallStacks = true,
        AggressiveBufferReturn = true,
        MaximumLargePoolFreeBytes = 4 * 16 * 1024 * 1024,
        MaximumSmallPoolFreeBytes = 100 * 1024,
    };
var manager = new RecyclableMemoryStreamManager(options);
```

- best practices
  * if `MaximumLargePoolFreeBytes` and `MaximumSmallPoolFreeBytes` are not set,
    there is a possbility for unbounded memory growth
  * always dispose each stream exactly once
  * `ToArray` and `GetBuffer` should not be used
    + `GetBuffer`
      + if multiple blocks are in use, they will be converted into a single
        large pool buffer and the data copied into it
    + `ToArray`
      + it wipes out many benefits of `RecyclableMemoryStream`
        + it is implemented for completeness sake
      + its usage should be considered as a bug
      + `RecyclableMemoryStream.ThrowExceptionOnToArray = true` is recommended
    + instead
      + `GetReadOnlySequence` for reading
      + `IBufferWriter.GetSpan` and `Advance` for writing
      + `IBufferWriter.GetMemory` and `Advance` for writing
  * although it is thread-safe, concurrent use of `RecyclableMemoryStream`
    objects is not supported
- examples

```cs
// to get a span of memory from memory manager and write bytes to it
var bitInt = BigInteger.Parse("1234567890123456789012345678901234567890");
using var writeStream = manager.GetStream();
Span<byte> buffer = writeStream.GetSpan(bigInt.GetByteCount());
bigInt.TryWriteBytes(buffer, out int bytesWritten);
writeStream.Advance(bytesWritten);
```

```cs
// to get a span of memory from memory manager for zero-copy stream processing
// assuming readStream contains the data to be hashed
using var readStream = manager.GetStream();
using var sha256Hasher = IncrementalHash.CreateHash(HashAlgorithmName.SHA256);
foreach (var memory in readStream.GetReadOnlySequence())
{
    sha256Hasher.AppendData(memory.Span);
}
sha256Hasher.GetHashAndReset();
```

### Workarounds

In mixing .NET full framework with .NET Core stuff (via .NET Standard), the
following steps may be needed to get the stuff compile.

1. Set environment variable `MSBuildSDKsPath=C:\Program Files\dotnet\sdk\2.1.004771\Sdks`
2. Run `dotnet restore` on .NET Standard projects
3. Apply `<Reference include="netstandard" />`

## Libraries

### Proto.Actor

- [asynkron/protoactor-dotnet](https://github.com/asynkron/protoactor-dotnet)
  - Nuget package name as `Proto.Actor`
- [official documentation](https://proto.actor/docs/)
- an implementation which claims to have a good balance between features of
  Microsoft Orleans and Akka.NET
- an instance of actor in .NET can talk to another instance of actor written in
  another language
- it uses Protobuf for serialisation and GRPC for connections
- an actor can be setup to listen to messages in a .NET Channel; similarly
  a publisher can be attached to a channel to push messages
- actor references (PIDs) are themselves serializable, enabling remote
  communication between actors across nodes; PID is not related to an OS process
  in anyway
- channels can be used and other mediums can also be used; thus, persistence (or
  not) is an implementation choice
- messages are not durable by default
- remoting and clustering is possible
- actors can be stateful
- comparing to messages-based services on public cloud, actors has a better
  performance

### Microsoft Orleans

- sometimes known as "distributed .NET"
- [official
  documentation](https://learn.microsoft.com/en-us/dotnet/orleans/overview)
- concepts
  * actors are purely logical entities that always exist, virtually
    + an actor cannot be explicitly created nor destroyed, and its virtual
      existence is unaffected by the failure of a server that executes it; since
      actors always exist, they are always addressable
  * grain
    + it is a virtual actor
    + an entity consisting of
      + user-defined identity
        + any user-defined key
      + behaviour
        + a class inherits `Grain`
      + state
        + data either in-memory or persisted
    + state of active grains are in memeory
      + control of active/inactive of grains is done by the runtime
      + configuration can be made to persist state of a grain when it is being
        deactivated
  * silo
    + it hosts one or more grains
    + a group of silos runs as a cluster for scalability and fault tolerance
    + when run as a cluster, silos coordinate with each other to distribute work
      and detect and recover from failures
    + it provides grains with a set of runtime services such as timers,
      reminders (persistent timers), persistence, transactions, streams, etc
- features
  * multiple grains can participate in ACID transactions together regardless of
    where their state is ultimately stored

### Resilience (Polly)

- resiliance is the ability of an app to recover from transient failures and
  continue to function
- nuget packages
  * `Microsoft.Extensions.Resilience` (general usages)
  * `Microsoft.Extensions.Http.Resilience` (for `HttpClient`)
  * `Microsoft.Extensions.Http.Polly` (deprecated)
  * `Polly.Core` (core abstractions and built-in strategies)
  * `Polly.Extensions` (telemetry and dependency injection)
  * `Polly.RateLimiting` (integration with `System.Threading.RateLimiting`)
  * `Polly.Testing`
  * `Polly` (the legacy API exposed by versions of the Polly library before
    version 8)
- the APIs in namespace `Microsoft.Extensions` are built on top of `Polly`
- functionalities of Polly
  * retry
  * circuit breaker
    + stop trying if something is broken or busy
  * timeout
  * rate limiter
    + limit how many requests you make or accept
  * fallback
    + do something else if something fails
  * hedging
    + do more than one thing at the same time and take the fastest one
  * bulkhead isolation
- the concept of resilience pipeline is similar to a policy

```cs
services.AddResiliencePipeline(key, static builder =>
  {
      builder.AddRetry(
        new RetryStrategyOptions
        {
            ShouldHandle = new PredicateBuilder().Handle<TimeoutRejectedException()
        });
      builder.AddTimeout(TimeSpan.FromSeconds(5));
  }
```

- the strategy executes in order of configuration
- `builder.AddRateLimiter` allows the control of inbound load
- `builder.AddConcurrencyLimiter` allows the control of outbound load
- if enrichment has been added `services.AddResilienceEnricher()`, the following
  dimensions are added to telemetry
  * `error.type`
  * `request.name`
  * `request.dependency.name`

- to use a resilience pipeline

```cs
using ServiceProvider provider = services.BuildServiceProvider();
ResiliencePipelineProvider<string> pipelineProvider = provider.GetRequiredService<ResiliencePipelineProvider<string>>();
ResiliencePipeline pipeline = pipelineProvider.GetPipeline("key");

await pipeline.ExecuteAsync(static cancellationToken =>
{
    // do something
    // ...

    return ValueTask.CompletedTask;
});
```

- [retry strategies in
  Polly](https://github.com/App-vNext/Polly?tab=readme-ov-file#retry)


# .NET (Classic)

### To check which .NET framework versions are installed

##### For framework version 1 - 4

```ps1
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP
```

##### For framework version 4.5 and later

```ps1
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full
```

See [How to: Determine Which .NET Framework Versions Are Installed](https://msdn.microsoft.com/en-us/library/hh925568.aspx#net_d) for possible DWORD values.

# C#

### Generics

##### Convariance and Contravariance

- [Covariance and Contravariance (C#)](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/covariance-contravariance/index)
- `IEnumerable<out T>` enables `IEnumerable<string> strings = new List<string>(); IEnumerable<object> objects = strings;`
- However, `IList<string> strings = new List<string>(); IList<object> objects = strings;` would be a compilation error as IList<T> is defined without the `out` keyword
- Covariance (`out`) for arrays enables implicit conversion of an array of a more derived type to an array of a less derived type. But this operation is not type safe

### ref

- Objects in parameters are passed by reference by default. Thus, `ref` should
  be only used on primitive types.

### Span<T>, Memory<T> and Pipeline<T>

#### Span<T>

##### Example

```csharp
Span<byte> bytes = new byte[10]; // implicit cast
Span<byte> sliced = bytes.Slice(start: 5, length: 4);
bytes[5] = 43;
sliced[0] = 42;
Assert.Equal(arr[5], bytes[5]);
Assert.Equal(bytes[5], 42);
Span<int> number = sliced;   // implicit cast to a 4-byte integer

Span<byte> moreBytes = stackalloc byte[10]; // implicit cast

string str = "hello, world";
ReadOnlySpan<char> span = str.AsSpan()Slice(start: 7, length: 5);

Span<byte> bytes = length <= 128 ? stackalloc byte[length] : new byte[length];
```

##### Implementation of get method

```csharp
public ref T this[int index] { get { ... } }  // Span<T>
public ref readonly T this[int index] { get { ... } }  // ReadOnlySpan<T>
```

#### Memory<T>

##### Limitations of Span<T>

- `Span<T>` lives on stack
- Boxing cannot be applied on `Span<T>` which means reflection is impossible
- `Span<T>` cannot be fields in classes and this limits it usage in
  asynchronous functionality
- `Span<T>` cannot be used as a generic argument

##### Characteristics

- implicit cast or `AsMemory` can be used to create instance of `Memory<T>`
- there is also `ReadOnlyMemory<T>`
- it lives on heap
- it works better on un-bounded array
- it can wrap things other than array-like object

#### Good APIs

- `System.String.Create`
- `System.Buffers.Text.Utf8Parser.TryParse`
- `System.Buffers.Text.Base64.DecodeFromUtf8`
- `System.Buffers.Text.Base64.EncodeToUtf8`
- `System.Buffers.Text.Utf8Formatter.TryFormat`
- `System.Security.Cryptography.HashAlgorithm.TryComputeHash`

#### Pipeline<T>

- see "TCP server with System.IO.Pipelines" in [System.IO.Pipelines: High
  performance IO in .NET](https://devblogs.microsoft.com/dotnet/system-io-pipelines-high-performance-io-in-net/)
  - the example requires to process lines from a stream of unknown size
  - there are no explicit buffers allocated anywhere and all buffer management
    is delegated to the `PipeReader`/`PipeWriter` implementations
  - `PipeReader.Complete()` and `PipeWriter.Complete` allows the underlying
    `Pipe` to release all memory it allocated
  - `PipeReader.AdvancedTo` tells the underlying implementation to discard the
    already processed memory
  - one of the pipelines feature is the ability to peek at data in the `Pipe`
    without consuming it
  - `PipeWriter.FlushAsync` blocks when the amount of data in the `Pipe`
    crosses `PipeOptions.PauseWriterThreashold` and unblocks when it becomes
    lower than `PipeOptions.ResumeWriterThreshold`. These values allow back
    pressure and flow control.
  - Pipelines exports a `PipeScheduler` to allow fine-grained control over
    exactly what threads are used for IO
  - unit tests are easier to be written as it can now works with in-memory
    buffers instead

##### ReadOnlySequence<T>

- it can support one or more segments
- example

```csharp
string GetAsciiString(ReadOnlySequence<byte> buffer)
{
    if (buffer.IsSingleSegment)
    {
        return Encoding.ASCII.GetString(buffer.First.Span);
    }

    return string.Create((int)buffer.Length, buffer, (span, sequence) =>
    {
        foreach (var segment in sequence)
        {
            Encoding.ASCII.GetChars(segment.Span, span);

            span = span.Slice(segment.Length);
        }
    });
}
```

# ASP.NET

### Links

- [ASP.NET Community Standup](https://live.asp.net/)

### Lifecycle

-   [Understanding MVC Application Execution](https://support.microsoft.com/en-gb/help/2019689/error-message-when-you-visit-a-web-site-that-is-hosted-on-iis-7.0-http-error-404.17---not-found)
-   [Execution Order for the ApiController](http://stackoverflow.com/questions/12277293/execution-order-for-the-apicontroller)

### Web API

-   [A WebAPI Basic Authentication Authorization Filter](https://weblog.west-wind.com/posts/2013/Apr/18/A-WebAPI-Basic-Authentication-Authorization-Filter)
-   [Accepting Raw Request Body Content with ASP.NET Web API](https://weblog.west-wind.com/posts/2013/Dec/13/Accepting-Raw-Request-Body-Content-with-ASPNET-Web-API)
-   [HTTP Message Handlers in ASP.NET Web API](https://docs.microsoft.com/en-us/aspnet/web-api/overview/advanced/http-message-handlers)
-   HTTP Status 428 Precondition required [Optimistic concurrency support in HTTP and WebAPI – part 2](https://tudorturcu.wordpress.com/2012/05/17/optimistic-concurrency-support-in-http-and-webapi-part-2/)

### Error handling

-   [Bypassing IIS Error Messages in ASP.NET](https://weblog.west-wind.com/posts/2017/Jun/01/Bypassing-IIS-Error-Messages-in-ASPNET)

### CORS

-   [CORS, IIS and WebDAV](https://brockallen.com/2012/10/18/cors-iis-and-webdav/)


### Directory

```csharp
System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "bin");
System.IO.Path.Combine(System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath, "bin");
```

### Troubleshooting

##### 404.17

-   [Error message when you visit a Web site that is hosted on IIS 7.0: "HTTP Error 404.17 - Not Found"](https://support.microsoft.com/en-gb/help/2019689/error-message-when-you-visit-a-web-site-that-is-hosted-on-iis-7.0-http-error-404.17---not-found)


# Nuget

##### Re-targeting Nuget packages to another framework

```ps1
Update-Package -Reinstall
```

# IIS

-   Customer error page [HTTP Errors](https://www.iis.net/configreference/system.webserver/httperrors)
-   [App Offline with Http Errors](http://www.richrout.com/Blog/Post/6/app-offline-with-http-errors)
-   [Using Let's Encrypt with IIS on Windows - Rick Strahl's Web Log](https://weblog.west-wind.com/posts/2016/Feb/22/Using-Lets-Encrypt-with-IIS-on-Windows)

# IIS Express

### Making ASP.NET site available on port 8080 to other machines

```ps1
npm i -g iisexpress-proxy
iisexpress-proxy 51123 to 8080
```

### Making ASP.NET site running on a Windows VM on Mac (and accessing it via a web client on Mac (the host))

-   To make IIS Express to serve multiple bindings, edit`$(SolutionDir)\.vs\config\applicationhost.config` (look for configuration/system.applicationHost/sites/site/bindings) and add a binding with the Windows machine name. For instance, `<binding protocol="http" bindingInformation="*:3048:alex-windows" />`.
-   Configure `HTTP.SYS` at the kernel by makingan "URL Reservation" `netsh http add urlacl url=http://alex-windows:3048/ user=everyone`.
-   Add a firewall rule `netsh firewall add portopening TCP 3048 IISExpressWeb enable ALL`.
-   On Mac, edit `/etc/hosts` to add `172.16.120.128 alex-windows` (or any IP of the guest VM).

##### To show existing URL reservations

```sh
netsh http show urlacl
```

##### To delete an existing URL reservation

```sh
netsh http delete urlacl url=http://alex-windows:3048/
```

# MSSQL

# Azure

### SQL

- [Unable to create
  table](https://social.msdn.microsoft.com/forums/azure/en-US/259af3d5-4016-43e2-9a84-7a17d4f52673/im-unable-to-create-a-new-table-on-sql-azure)
- [Keyword not supported: “data source” initializing Entity Framework
  Context](http://stackoverflow.com/questions/6997035/keyword-not-supported-data-source-initializing-entity-framework-context)
- [Windows Azure, Entity Framework. Keyword not supported:
  'metadata'](http://stackoverflow.com/questions/13908348/windows-azure-entity-framework-keyword-not-supported-metadata)

# Monitoring

- machine level
  - CPU usage
  - memory usage
  - number of threads
  - number of open files/handles/sockets (check `ulimit`)
- CLR level
  - ThreadPool (work-items and worker threads)
  - GC CPU (`Gen0`, `Gen1` and `Gen2`) collections
    - look for pauses
  - GC (heap sizes for `Gen0`, `Gen1` and `Gen2`)
  - Locks
  - Timers
  - I/O threads
- Application level
  - `AsyncLocal` leaks
  - Inefficient buffering

# General Practices

### To increase testability (C#)

-   No object instantiation in business logics
-   Constructor - nothing more than simple assignments
-   Avoid global state - no `DateTime.Now`, no `Math.Random()`, ... etc
-   Avoid public `init()`-kind of methods
-   Avoid the use of service locator as it hides dependencies. (However, it is still better than singleton which is a share state)

### Multi-threading

-   [Threading in C#](http://www.albahari.com/threading/part4.aspx)

##### Parallel for-loop

```csharp
public class Job
{
  public void Run()
  {
    var subscriptions = GetSubscriptions();
    var maxThreadCount = 5;
    var parallelOptions = new ParallelOptions { MaxDegreeOfParallelism = maxThreadCount };
    Parallel.ForEach<Subscription>(
      subscriptions, parallelOptions, RenewSubscription);
    if (!exceptions.IsEmpty)
      throw new AggregateException(exceptions);
  }

  private void RenewSubscription(Subscription subscription)
  {
    try
    {
      RenewSubscriptionDetail(subscription);
    }
    catch (SubscriptionRenewalException subEx)
    {
      exceptions.Enqueue(subEx);
    }
  }

  var exceptions = new ConcurrentQueue<SubscriptionRenewalException>();
}
```

##### Converting a number to Enum

```csharp
public static StatusCode GetStatusCode(int statusCodeInNum)
{
  return (StatusCode)Enum.Parse(typeof(StatusCode), statusCodeInNum.ToString());
}
```

##### Updating an entity with Entity Framework

```csharp
public Blog Update(Blog blog)
{
  using (BlogContext dc = new BlogContext())
  {
    Blog b = dc.Blogs.Attach(blog);
    dc.Entry(b).State = System.Data.EntityState.Modified;
    dc.SaveChanges();
    return b;
  }
}
```

##### Updating RavenDB dynamically (that is, without entity definition) with only index specified

```csharp
var docs =
  session.Advanced.DocumentQuery<ExpandoObject>("ProductSearch")
    .WhereEquals("ProductId", productId)
    .ToList();

foreach (dynamic d in docs)
{
  d.ExtraInfo = "haha";
}
session.SaveChanges();
```

##### IDataSource

1.  If a filter is to be applied, all entries must be retrieved before any filtering.
2.  If no filtering is required, real paging can be accomplished using `ObjectDataSource`, but not `SqlDataSource`.

##### File system classes

- Separated into two types
  - informational
  - utility
- Most of the informational classes derive from the `FileSystemInfo` base class.
- `FileSystemInfo.Delete`
  - Removes the file or directory from the file system
- `FileSystemInfo.Refresh`
  - Updates with the most current information from the file system
- `FileInfo.Replace`
  - Replaces a file with the information in the current `FileInfo` object.
- `DirectoryInfo.CreateSubDirectory`
  - Creates a new directory as a child directory of the current directory in the directory hierarchy
- `DirectoryInfo.Root`
  - Gets the root part of the directory’s path as a string
    - e.g. `C:\`
- `DriveInfo.AvailableFreeSpace`
  - Gets the amount of available space on the drive. The amount might be
    different from the amount returned by `TotalFreeSpace` depending on disk
    quotas.

### Log4Net

##### Creating SQL table for log storage

```sql
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Log]') AND type in (N'U'))
  DROP TABLE [dbo].[Log]
GO

CREATE TABLE [dbo].[Log](
  [Id] [int] IDENTITY(1,1) NOT NULL,
    [Date] [datetime] NOT NULL,
    [Thread] [varchar](255) NOT NULL,
    [Level] [varchar](50) NOT NULL,
    [Logger] [varchar](255) NOT NULL,
    [Message] [nvarchar](max) NOT NULL,
    [Exception] [nvarchar](max) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
```

### .editorconfig

- Best companion with Visual Studio extension "Format Document on save"

```editorconfig
root = true

[*.{cs,vb}]
indent_size = 4
trim_trailing_whitespace = true
dotnet_style_qualification_for_field = false:warning
dotnet_style_qualification_for_property = false:warning
dotnet_style_qualification_for_method = false:warning
dotnet_style_qualification_for_event = false:warning
dotnet_style_predefined_type_for_locals_parameters_members = true:warning
dotnet_style_predefined_type_for_member_access = true:warning
dotnet_style_require_accessibility_modifiers = always:warning
dotnet_style_object_initializer = true:warning
dotnet_style_collection_initializer = true:warning
dotnet_style_explicit_tuple_names = true:warning
dotnet_style_coalesce_expression = true:warning
dotnet_style_null_propagation = true:warning
dotnet_style_prefer_inferred_tuple_names = false:warning
dotnet_style_prefer_inferred_anonymous_type_member_names = false:warning
dotnet_sort_system_directives_first = true

[*.cs]
csharp_style_var_for_built_in_types = true:warning
csharp_style_var_when_type_is_apparent = true:warning
csharp_style_var_elsewhere = true:warning
csharp_style_expression_bodied_methods = when_on_single_line:warning
csharp_style_expression_bodied_constructors = when_on_single_line:warning
csharp_style_expression_bodied_operators = when_on_single_line:warning
csharp_style_expression_bodied_properties = when_on_single_line:warning
csharp_style_expression_bodied_indexers = when_on_single_line:warning
csharp_style_expression_bodied_accessors = when_on_single_line:warning
csharp_style_pattern_matching_over_is_with_cast_check = true:warning
csharp_style_pattern_matching_over_as_with_null_check = true:warning
csharp_style_pattern_local_over_anonymous_function = true:warning
csharp_style_throw_expression = true:warning
csharp_style_conditional_delegate_call = true:warning
csharp_prefer_braces = true:none
csharp_new_line_before_open_brace = all
csharp_new_line_before_else = true
csharp_new_line_before_catch = true
csharp_new_line_before_finally = true
csharp_new_line_before_members_in_object_initializers = true
csharp_new_line_before_members_in_anonymous_types = true
csharp_new_line_between_query_expression_clauses = true
csharp_indent_case_contents = true
csharp_indent_switch_labels = true
csharp_indent_labels = flush_left
csharp_space_after_cast = false
csharp_space_after_keywords_in_control_flow_statements = true
csharp_space_between_method_declaration_parameter_list_parentheses = false
csharp_space_between_method_call_parameter_list_parentheses = false
csharp_preserve_single_line_statements = false
csharp_preserve_single_line_blocks = true
```

### Quartz.NET

##### Example on job configuration

```xml
<?xml version="1.0" encoding="utf-8"?>
  <!-- This file contains job definitions in schema version 2.0 format -->
<job-scheduling-data xmlns="http://quartznet.sourceforge.net/JobSchedulingData" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">
  <processing-directives>
    <overwrite-existing-data>true</overwrite-existing-data>
  </processing-directives>
  <schedule>
    <job>
      <name>TestJob</name>
      <group>TestJobGroup</group>
      <description>Test Job</description>
      <job-type>Namespace.Jobs, Namespace.Jobs.TestJob</job-type>
      <durable>true</durable>
      <recover>false</recover>
      <job-data-map>
        <entry>
          <key>Parameter1</key>
          <value>Value1</value>
        </entry>
      </job-data-map>
    </job>
    <trigger>
      <cron>
        <name>TestJobTrigger</name>
        <group>TestJobTriggerGroup</group>
        <description>TestJob Trigger</description>
        <job-name>TestJob</job-name>
        <job-group>TestJobGroup</job-group>
        <misfire-instruction>SmartPolicy</misfire-instruction>
        <cron-expression>0 0/5 * * * ?</cron-expression>
      </cron>
    </trigger>
    <trigger>
      <simple>
        <name>TestJobTrigger Trigger</name>
        <group>TestJobTriggerGroup</group>
        <description></description>
        <job-name>TestJob</job-name>
        <job-group>TestJobGroup</job-group>
        <misfire-instruction>SmartPolicy</misfire-instruction>
        <repeat-count>0</repeat-count>
        <repeat-interval>10000</repeat-interval>
      </simple>
    </trigger>
  </schedule>
</job-scheduling-data>
```

##### Example on service configuration

```xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <configSections>
    <section name="quartz" type="System.Configuration.NameValueSectionHandler, System, Version=1.0.5000.0,Culture=neutral, PublicKeyToken=b77a5c561934e089" />
    <section name="log4net" type="log4net.Config.Log4NetConfigurationSectionHandler, log4net" />
    <sectionGroup name="common">
      <section name="logging" type="Common.Logging.ConfigurationSectionHandler, Common.Logging" />
    </sectionGroup>
  </configSections>

  <appSettings>
  </appSettings>

  <common>
    <logging>
      <factoryAdapter type="Common.Logging.Log4Net.Log4NetLoggerFactoryAdapter, Common.Logging.Log4net1211">
        <arg key="configType" value="INLINE" />
      </factoryAdapter>
    </logging>
  </common>

  <log4net>
    <!-- see http://logging.apache.org/log4net/release/config-examples.html for examples -->
    <appender name="AdoNetAppender" type="log4net.Appender.AdoNetAppender">
      <bufferSize value="1" />
      <connectionType value="System.Data.SqlClient.SqlConnection, System.Data, Version=1.0.3300.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" />
      <connectionString value="..." />
      <commandText value="INSERT INTO Log ([Date],[Thread],[Level],[Logger],[Message],[Exception]) VALUES (@log_date, @thread, @log_level, @logger, @message, @exception)" />
      <parameter>
        <parameterName value="@log_date" />
        <dbType value="DateTime" />
        <layout type="log4net.Layout.RawTimeStampLayout" />
      </parameter>
      <parameter>
        <parameterName value="@thread" />
        <dbType value="String" />
        <size value="255" />
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%thread" />
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@log_level" />
        <dbType value="String" />
        <size value="50" />
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%level" />
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@logger" />
        <dbType value="String" />
        <size value="255" />
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%logger" />
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@message" />
        <dbType value="String" />
        <size value="8000" />
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%message" />
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@exception" />
        <dbType value="String" />
        <size value="8000" />
        <layout type="log4net.Layout.ExceptionLayout" />
      </parameter>
    </appender>
    <root>
      <level value="INFO" />
      <appender-ref ref="AdoNetAppender" />
    </root>
  </log4net>

  <!--
    We use quartz.config for this server, you can always use configuration section if you want to.
    Configuration section has precedence here.
  -->
  <!--
  <quartz >
  </quartz>
  -->
</configuration>
```

##### Example on error logging in Global.asax.cs

```cs
using System;
using System.Web;
using log4net;
using log4net.Config;


namespace Alexhokl
{
    public class Global : System.Web.HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            XmlConfigurator.Configure();
        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs
            log.Error("Exception was unhandled.", Server.GetLastError());
        }

        private static readonly ILog log = LogManager.GetLogger(typeof(Global));
    }
}
```

##### Creating SQL table for log storage

```sql
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Log]') AND type in (N'U'))
  DROP TABLE [dbo].[Log]
GO

CREATE TABLE [dbo].[Log](
  [Id] [int] IDENTITY(1,1) NOT NULL,
    [Date] [datetime] NOT NULL,
    [Thread] [varchar](255) NOT NULL,
    [Level] [varchar](50) NOT NULL,
    [Logger] [varchar](255) NOT NULL,
    [Message] [nvarchar](max) NOT NULL,
    [Exception] [nvarchar](max) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
```
