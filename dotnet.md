- [.NET Core](#net-core)
    + [Porting](#porting)
    + [.NET CLI](#net-cli)
    + [Nuget](#nuget)
    + [ASP.NET Core](#aspnet-core)
    + [Entity Framework (EF)](#entity-framework-ef)
    + [Mac Installation](#mac-installation)
    + [Workarounds](#workarounds)
- [.NET (Classic)](#net-classic)
    + [dotnet/codeformatter](#dotnetcodeformatter)
    + [Libraries](#libraries)
    + [Software](#software)
    + [To check which .NET framework versions are installed](#to-check-which-net-framework-versions-are-installed)
    + [Generics](#generics)
    + [Language](#language)
- [ASP.NET](#aspnet)
    + [Links](#links)
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
    + [Libraries](#libraries-1)
    + [Entity Framework](#entity-framework)
- [Azure](#azure)
    + [SQL](#sql)
- [General Practices](#general-practices)
    + [To increase testability (C#)](#to-increase-testability-c%23)
    + [Multi-threading](#multi-threading)
    + [Log4Net](#log4net)
    + [.editorconfig](#editorconfig)
    + [Quartz.NET](#quartznet)
____

# .NET Core

### Porting

-	[GitHub issues: port-to-core](https://github.com/dotnet/corefx/issues?q=is%3Aopen+is%3Aissue+label%3Aport-to-core)
-	[Porting to .NET Core from .NET Framework](https://docs.microsoft.com/en-us/dotnet/articles/core/porting/)
-	[Microsoft/dotnet-apiport](https://github.com/Microsoft/dotnet-apiport/) (by running `.\apiport.exe analyze -f C:\work\solution\project\bin\ `)
-	[Can I port my application to .NET Core?](https://icanhasdot.net/)
-	[PackageSeach](http://packagesearch.azurewebsites.net/)
-	[Multi-Targeting and Porting a .NET Library to .NET Core 2.0](https://weblog.west-wind.com/posts/2017/Jun/22/MultiTargeting-and-Porting-a-NET-Library-to-NET-Core-20)
-	[Conditional TargetFrameworks for Multi-Targeted .NET SDK Projects on Cross-Platform Builds](https://weblog.west-wind.com/posts/2017/Sep/18/Conditional-TargetFrameworks-for-MultiTargeted-NET-SDK-Projects-on-CrossPlatform-Builds)

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
dotnet new classlib -n Name.Space.Library
dotnet sln add Name.Space.Library/Name.Space.Library.csproj
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

### Nuget

##### To install Nuget on macOS/Linux [link](https://docs.microsoft.com/en-us/nuget/install-nuget-client-tools#macoslinux)

```sh
sudo curl -o /usr/local/bin/nuget.exe https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
```

Add alias `alias nuget="mono /usr/local/bin/nuget.exe"`

Note that Mono 4.4.2 or later is required.

See also [feature availability](https://docs.microsoft.com/en-us/nuget/install-nuget-client-tools#feature-availability)


### ASP.NET Core

- [Writing Custom Middleware in ASP.NET Core 1.0](https://www.exceptionnotfound.net/writing-custom-middleware-in-asp-net-core-1-0)
- [ASP.NET Core Logging with NLog AND ElasticSearch](https://damienbod.com/2016/08/20/asp-net-core-logging-with-nlog-and-elasticsearch)
- [Accepting Raw Request Body Content in ASP.NET Core API Controllers](https://weblog.west-wind.com/posts/2017/Sep/14/Accepting-Raw-Request-Body-Content-in-ASPNET-Core-API-Controllers)
- [A few notes on creating Class Libraries for ASP.NET Core](https://weblog.west-wind.com/posts/2017/Sep/26/A-few-notes-on-creating-Class-Libraries-for-ASPNET-Core) (mostly about not including a kitchen sink of dependencies)
- [Dependency injection in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection)
- [Create instance from ASP.NET Core dependency injection](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection?view=aspnetcore-2.1#call-services-from-main)
- [Services available in `ConfigureServices`](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection?view=aspnetcore-2.1#framework-provided-services)


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

##### Environment variables

- Environment variables are available in `IConfiguration` objects
- Setting environment variable `Logging:LogLevel:Default` to `INFO` can change
  log level of an application

##### Authentication

- CSRF (Cross-site Request Forgery) applies only in cookie-based authentication
    and it is not a concern in token-based authentication even the token could
    be saved in local storage

##### Paths

- `IHostingEnvironment.ContentRootPath` points to the directory of the web
    deployment
  - `${IHostingEnvironment.ContentRootPath}/bin` points to the directory of
      containing DLLs
- `IHostingEnvironment.WebRootPath` generally points to `wwwroot` directory and
    may not available in every application

### Entity Framework (EF)

##### Useful Libraries

- [borisdj/EFCore.BulkExtensions](https://github.com/borisdj/EFCore.BulkExtensions)
- [Arch/AutoHistory](https://github.com/Arch/AutoHistory/)
- [Arch/UnitOfWork](https://github.com/Arch/UnitOfWork)

##### Update database to a specified migration

```sh
dotnet ef database update
```

##### To generate SQL scripts from migration

```ps1
Script-Migration
```

### Mac Installation

The SDK installations are located at

```console
/usr/local/share/dotnet/sdk/
```

### Workarounds

In mixing .NET full framework with .NET Core stuff (via .NET Standard), the
following steps may be needed to get the stuff compile.

1. Set environment variable `MSBuildSDKsPath=C:\Program Files\dotnet\sdk\2.1.004771\Sdks`
2. Run `dotnet restore` on .NET Standard projects
3. Apply `<Reference include="netstandard" />`

# .NET (Classic)

### [dotnet/codeformatter](https://github.com/dotnet/codeformatter)

To run the formatter, download the zip from release page and run

```ps1
codeformatter.exe /nocopyright C:\work\solution.sln
```

### Libraries

-	[StackExchange/NetGain](https://github.com/StackExchange/NetGain) A high performance websocket server library powering Stack Overflow
-	[Dapper](https://github.com/StackExchange/Dapper)
-	[StackExchange.Exceptional](https://github.com/NickCraver/StackExchange.Exceptional)
-	[Audit.NET](https://github.com/thepirat000/Audit.NET) An extensible framework to audit executing operations in .NET and .NET Core
-	[bilal-fazlani/tracker-enabled-dbcontext](https://github.com/bilal-fazlani/tracker-enabled-dbcontext) Tracker-enabled DbContext offers you to implement full auditing in your database

### Software

-	[NCrunch](http://www.ncrunch.net/) an automated concurrent testing tool for Visual Studio

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

### Generics

##### Convariance and Contravariance

- [Covariance and Contravariance (C#)](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/covariance-contravariance/index)
- `IEnumerable<out T>` enables `IEnumerable<string> strings = new List<string>(); IEnumerable<object> objects = strings;`
- However, `IList<string> strings = new List<string>(); IList<object> objects = strings;` would be a compilation error as IList<T> is defined without the `out` keyword
- Covariance (`out`) for arrays enables implicit conversion of an array of a more derived type to an array of a less derived type. But this operation is not type safe

### Language

- Objects in parameters are passed by reference by default. Thus, `ref` should
  be only used on primitive types.

# ASP.NET

### Links

- [ASP.NET Community Standup](https://live.asp.net/)

### Lifecycle

-	[Understanding MVC Application Execution](https://support.microsoft.com/en-gb/help/2019689/error-message-when-you-visit-a-web-site-that-is-hosted-on-iis-7.0-http-error-404.17---not-found)
-	[Execution Order for the ApiController](http://stackoverflow.com/questions/12277293/execution-order-for-the-apicontroller)

### Web API

-	[A WebAPI Basic Authentication Authorization Filter](https://weblog.west-wind.com/posts/2013/Apr/18/A-WebAPI-Basic-Authentication-Authorization-Filter)
-	[Accepting Raw Request Body Content with ASP.NET Web API](https://weblog.west-wind.com/posts/2013/Dec/13/Accepting-Raw-Request-Body-Content-with-ASPNET-Web-API)
-	[HTTP Message Handlers in ASP.NET Web API](https://docs.microsoft.com/en-us/aspnet/web-api/overview/advanced/http-message-handlers)
-	HTTP Status 428 Precondition required [Optimistic concurrency support in HTTP and WebAPI – part 2](https://tudorturcu.wordpress.com/2012/05/17/optimistic-concurrency-support-in-http-and-webapi-part-2/)

### Error handling

-	[Bypassing IIS Error Messages in ASP.NET](https://weblog.west-wind.com/posts/2017/Jun/01/Bypassing-IIS-Error-Messages-in-ASPNET)

### CORS

-	[CORS, IIS and WebDAV](https://brockallen.com/2012/10/18/cors-iis-and-webdav/)


### Directory

```csharp
System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "bin");
System.IO.Path.Combine(System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath, "bin");
```

### Troubleshooting

##### 404.17

-	[Error message when you visit a Web site that is hosted on IIS 7.0: "HTTP Error 404.17 - Not Found"](https://support.microsoft.com/en-gb/help/2019689/error-message-when-you-visit-a-web-site-that-is-hosted-on-iis-7.0-http-error-404.17---not-found)


# Nuget

##### Re-targeting Nuget packages to another framework

```ps1
Update-Package -Reinstall
```

# IIS

-	Customer error page [HTTP Errors](https://www.iis.net/configreference/system.webserver/httperrors)
-	[App Offline with Http Errors](http://www.richrout.com/Blog/Post/6/app-offline-with-http-errors)
-	[Using Let's Encrypt with IIS on Windows - Rick Strahl's Web Log](https://weblog.west-wind.com/posts/2016/Feb/22/Using-Lets-Encrypt-with-IIS-on-Windows)

# IIS Express

### Making ASP.NET site available on port 8080 to other machines 

```ps1
npm i -g iisexpress-proxy
iisexpress-proxy 51123 to 8080
```

### Making ASP.NET site running on a Windows VM on Mac (and accessing it via a web client on Mac (the host))

-	To make IIS Express to serve multiple bindings, edit`$(SolutionDir)\.vs\config\applicationhost.config` (look for configuration/system.applicationHost/sites/site/bindings) and add a binding with the Windows machine name. For instance, `<binding protocol="http" bindingInformation="*:3048:alex-windows" />`.
-	Configure `HTTP.SYS` at the kernel by makingan "URL Reservation" `netsh http add urlacl url=http://alex-windows:3048/ user=everyone`.
-	Add a firewall rule `netsh firewall add portopening TCP 3048 IISExpressWeb enable ALL`.
-	On Mac, edit `/etc/hosts` to add `172.16.120.128 alex-windows` (or any IP of the guest VM).

##### To show existing URL reservations

```sh
netsh http show urlacl
```

##### To delete an existing URL reservation

```sh
netsh http delete urlacl url=http://alex-windows:3048/
```

# MSSQL

### Libraries

- [Dapper](https://github.com/StackExchange/Dapper)
- [SqlKata](https://sqlkata.com/)

### Entity Framework

###### To log SQL queries executed

```csharp
public class LogInterceptor : DbCommandInterceptor
{
    public override void ReaderExecuting(DbCommand command,
        DbCommandInterceptionContext<DbDataReader> interceptionContext)
    {
        s_logger.Debug($"About to execute SQL command [{command.CommandText}]");
    }

    public override void ReaderExecuted(DbCommand command, DbCommandInterceptionContext<DbDataReader> interceptionContext)
    {
        if (interceptionContext.Exception == null)
            return;

        s_logger.Error(
            $"Unable to complete a SQL query [{command.CommandText}]",
            interceptionContext.Exception);
    }

    private static readonly ILog s_logger = LogManager.GetLogger(typeof(LogInterceptor));
}
```

###### To log the duration of SQL queries

```csharp
public class QueryTimingInterceptor : DbCommandInterceptor
{
    public override void ReaderExecuting(DbCommand command,
        DbCommandInterceptionContext<DbDataReader> interceptionContext)
    {
        interceptionContext.UserState = GetStartedStopWatch();
    }

    public override void ScalarExecuting(DbCommand command, DbCommandInterceptionContext<object> interceptionContext)
    {
        interceptionContext.UserState = GetStartedStopWatch();
    }

    public override void ReaderExecuted(DbCommand command, DbCommandInterceptionContext<DbDataReader> interceptionContext)
    {
        OnCompletion(command, interceptionContext.UserState as Stopwatch);
    }

    public override void ScalarExecuted(DbCommand command, DbCommandInterceptionContext<object> interceptionContext)
    {
        OnCompletion(command, interceptionContext.UserState as Stopwatch);
    }

    private void OnCompletion(DbCommand command, Stopwatch stopwatch)
    {
        if (stopwatch == null)
        {
            s_logger.Error("Unable to retrieve stop watch from interceptionContext");
            return;
        }

        stopwatch.Stop();
        var duration = stopwatch.Elapsed.TotalSeconds;
        var logLine =
            $"It took {duration:F} seconds to complete the following query: {command.CommandText}";
        s_logger.Info(logLine);
    }

    private static Stopwatch GetStartedStopWatch()
    {
        var stopWatch = new Stopwatch();
        stopWatch.Start();
        return stopWatch;
    }

    private static readonly ILog s_logger = LogManager.GetLogger(typeof(QueryTimingInterceptor));
}
```

##### Improving performance

See [Entity Framework Performance and What You Can Do About It](https://www.red-gate.com/simple-talk/dotnet/net-tools/entity-framework-performance-and-what-you-can-do-about-it/)

-	Avoid being too greedy with Rows
-	The ‘N+1 Select’ problem: Minimising the trips to the database
	-	Use of `.Include()`
-	Avoid being too greedy with columns
	-	use less network bandwidth
	-	a good indexing strategy involves considering what columns you frequently match against and what columns are returned when searching against them, along with judgements about disk space requirements and the additional performance penalty indexes incur on writing
-	Avoid mismatched data types
	-	for instance, database definition of `VARCHAR` in database where EF consider the value as `NVARCHAR` and this results a `CONVERT`. To solve this, either change database definition to `NVARCHAR` or applying attribute `[Column(TypeName =  "varchar")]`.
-	Add missing indexes
	-	`CREATE NONCLUSTERED INDEX [NonClusteredIndex_City] ON [dbo].[Pupils] ([City]) INCLUDE ([FirstName], [LastName]) ON [PRIMARY]` creates a non-clustered index for queries filtering against city and serves first and last names
-	Avoid overly-generic queries

```csharp
public class QueryPlanRecompileInterceptor : DbCommandInterceptor
{
    public override void ReaderExecuting(
        DbCommand command,
        DbCommandInterceptionContext<DbDataReader> interceptionContext)
    {
        if (!command.CommandText.StartsWith("EXEC ") &&
            !command.CommandText.EndsWith(" option(recompile)"))
        {
            command.CommandText += " option(recompile)";
        }
    }
}
```

```csharp
var interceptor = new QueryPlanRecompileInterceptor();
DbInterception.Add(interceptor);
var pupils = db.Pupils.Where(p => p.City = city).ToList();
DbInterception.Remove(interceptor);
```

-	Avoid bloating the plan cache
	-	in order for a plan to be reused, the statement text must be identical which is the case for parameterised queries
	-	but there is a case when this doesn’t happen – when we use `.Skip()` or `.Take()`
	-	use lambda function in `IQueryable.Skip()` and `IQueryable.Take()`
	-	enable a SQL Server setting called 'optimise for ad-hoc workloads' (see also [optimize for ad hoc workloads Server Configuration Option](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/optimize-for-ad-hoc-workloads-server-configuration-option)\)
	-	this makes SQL Server less aggressive at caching plans, and is generally a good thing to enable
	-	to find the one-off ad-hoc plans (see query below)
	-	To enable "optimise for ad-hoc workloads" (see stored procedure below)
	-	on AWS, change of the setting can be done in parameter groups. A new parameter group will be required if no prior custom parameter group is setup. After changing the value of the option in the parameter group, the group should be applied to the RDS instance.

```sql
SELECT objtype, cacheobjtype,
  AVG(usecounts) AS Avg_UseCount,
  SUM(refcounts) AS AllRefObjects,
  SUM(CAST(size_in_bytes AS bigint))/1024/1024 AS Size_MB
FROM sys.dm_exec_cached_plans
WHERE objtype = 'Adhoc' AND usecounts = 1
GROUP BY objtype, cacheobjtype;
```

```sql
EXEC sys.sp_configure N'optimize for ad hoc workloads', N'1'
RECONFIGURE WITH OVERRIDE
GO
```

-	Using bulk insert
	-	`EF.BulkInsert()`
	-	this will be supported out of the box in EF 7.0
-	Disable tracking in read-only queries

```csharp
string city =  "New York";
var schools =
  db.Schools
    .AsNoTracking()
    .Where(s => s.City == city)
    .Take(100)
    .ToList();
```

-	Allowing EF to make and receive multiple requests to SQL Server over a single connection, reducing the number of roundtrips
	-	`MultipleActiveResultSets=True;`

##### Anti-patterns

-	`.Where().First()`
-	`.SingleOrDefault()` instead of `.FirstOrDefault()`
	-	effectively `SELECT TOP 2` instead of `SELECT TOP 1`
-	`.Count()` instead of `.All()` or `.Any()`
-	`.Where().Where()`
-	`.OrderBy().OrderBy()` instead of `.OrderBy().ThenBy()`
	-	the logic of double `.OrderBy()` is simply incorrect
-	`.Select(x => x)` instead of `AsEnumerable()`
	-	If remote execution is not desired, for example because the predicate invokes a local method, the `AsEnumerable` method can be used to hide the custom methods and instead make the standard query operators available
-	`.Count()` instead of `.Count` or `.Length`
	-	the alternatives can prevent `O(n)` operations
- Inheritance of entities should be based on `abstract` class instead of concrete class to avoid un-necessary joins

##### Building SQL deployment package

To build SQL projects

```ps1
Install-PackageProvider -Name chocolatey -Force;
Install-Package -Name microsoft-build-tools -RequiredVersion 14.0.25420.1 -Force;
Install-Package dotnet4.6-targetpack -Force;
Install-Package nuget.commandline -Force;
C:\Chocolatey\bin\nuget install Microsoft.Data.Tools.Msbuild
cd 'C:\Program Files (x86)\MSBuild\14.0\Bin'; `
    .\msbuild C:\src\Assets.Database\Assets.Database.sqlproj `
    /p:SQLDBExtensionsRefPath="C:\Microsoft.Data.Tools.Msbuild.10.0.61026\lib\net40" `
    /p:SqlServerRedistPath="C:\Microsoft.Data.Tools.Msbuild.10.0.61026\lib\net40"; `
    cp 'C:\src\Assets.Database\bin\Debug\Assets.Database.dacpac' 'c:\bin'
```

##### Generate SQL scripts from deployment package

```ps1
SqlPackage.exe `
    /sf:Assets.Database.dacpac `
    /a:Script /op:create.sql /p:CommentOutSetVarDeclarations=true `
    /tsn:.\SQLEXPRESS /tdn:AssetsDB /tu:sa /tp:$sa_password
```

##### Running SQL deployment scripts

```ps1
$SqlCmdVars = "DatabaseName=AssetsDB", "DefaultFilePrefix=AssetsDB", "DefaultDataPath=c:\database\", "DefaultLogPath=c:\database\"
Invoke-Sqlcmd -InputFile create.sql -Variable $SqlCmdVars -Verbose
```

##### Links

-	[Common LINQ mistakes](https://github.com/SanderSade/common-linq-mistakes/blob/master/readme.md)

# Azure

### SQL

-	[Unable to create table](https://social.msdn.microsoft.com/forums/azure/en-US/259af3d5-4016-43e2-9a84-7a17d4f52673/im-unable-to-create-a-new-table-on-sql-azure)
-	[Keyword not supported: “data source” initializing Entity Framework Context](http://stackoverflow.com/questions/6997035/keyword-not-supported-data-source-initializing-entity-framework-context)
-	[Windows Azure, Entity Framework. Keyword not supported: 'metadata'](http://stackoverflow.com/questions/13908348/windows-azure-entity-framework-keyword-not-supported-metadata)

# General Practices

### To increase testability (C#)

-	No object instantiation in business logics
-	Constructor - nothing more than simple assignments
-	Avoid global state - no `DateTime.Now`, no `Math.Random()`, ... etc
-	Avoid public `init()`-kind of methods
-	Avoid the use of service locator as it hides dependencies. (However, it is still better than singleton which is a share state)

### Multi-threading

-	[Threading in C#](http://www.albahari.com/threading/part4.aspx)

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

1.	If a filter is to be applied, all entries must be retrieved before any filtering.
2.	If no filtering is required, real paging can be accomplished using ObjectDataSource, but not SqlDataSource.

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
