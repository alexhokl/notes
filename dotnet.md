# .NET Core

### Porting

- [GitHub issues: port-to-core](https://github.com/dotnet/corefx/issues?q=is%3Aopen+is%3Aissue+label%3Aport-to-core)
- [Porting to .NET Core from .NET Framework](https://docs.microsoft.com/en-us/dotnet/articles/core/porting/)
- [Microsoft/dotnet-apiport](https://github.com/Microsoft/dotnet-apiport/) (by running `.\apiport.exe analyze -f C:\work\solution\project\bin\`)
- [Can I port my application to .NET Core?](https://icanhasdot.net/)
- [PackageSeach](http://packagesearch.azurewebsites.net/)
- [Multi-Targeting and Porting a .NET Library to .NET Core 2.0](https://weblog.west-wind.com/posts/2017/Jun/22/MultiTargeting-and-Porting-a-NET-Library-to-NET-Core-20)
- [Conditional TargetFrameworks for Multi-Targeted .NET SDK Projects on Cross-Platform Builds](https://weblog.west-wind.com/posts/2017/Sep/18/Conditional-TargetFrameworks-for-MultiTargeted-NET-SDK-Projects-on-CrossPlatform-Builds)

### .NET CLI

To create a new solution file

```console
dotnet new sln -n Name.Space
```

To create a new class library project from a solution

```console
dotnet new classlib -n Name.Space.Library
dotnet sln add Name.Space.Library/Name.Space.Library.csproj
```

### ASP.NET Core

- [Writing Custom Middleware in ASP.NET Core 1.0](https://www.exceptionnotfound.net/writing-custom-middleware-in-asp-net-core-1-0)
- [ASP.NET Core Logging with NLog AND ElasticSearch](https://damienbod.com/2016/08/20/asp-net-core-logging-with-nlog-and-elasticsearch)
- [Accepting Raw Request Body Content in ASP.NET Core API Controllers](https://weblog.west-wind.com/posts/2017/Sep/14/Accepting-Raw-Request-Body-Content-in-ASPNET-Core-API-Controllers)
- Porting of `HttpContext` and `HttpRequest` is almost impossible.
- [A few notes on creating Class Libraries for ASP.NET Core](https://weblog.west-wind.com/posts/2017/Sep/26/A-few-notes-on-creating-Class-Libraries-for-ASPNET-Core) (mostly about not including a kitchen sink of dependencies)

### Mac Installation

The SDK installations are located at
```console
/usr/local/share/dotnet/sdk/
```

# .NET (Classic)

### [dotnet/codeformatter](https://github.com/dotnet/codeformatter)

To run the formatter, download the zip from release page and run

```console
codeformatter.exe /nocopyright C:\work\solution.sln
```

### To check which .NET framework versions are installed

##### For framework version 1 - 4

1. Open `regedit.exe`.
2. Look for key `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP`

##### For framework version 4.5 and later

1. Open `regedit.exe`.
2. Look for key `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full`.
3. See [How to: Determine Which .NET Framework Versions Are Installed](https://msdn.microsoft.com/en-us/library/hh925568.aspx#net_d) for possible DWORD values.

# ASP.NET

### Lifecycle

- [Understanding MVC Application Execution](https://support.microsoft.com/en-gb/help/2019689/error-message-when-you-visit-a-web-site-that-is-hosted-on-iis-7.0-http-error-404.17---not-found)
- [Execution Order for the ApiController](http://stackoverflow.com/questions/12277293/execution-order-for-the-apicontroller)

### Web API

- [A WebAPI Basic Authentication Authorization Filter](https://weblog.west-wind.com/posts/2013/Apr/18/A-WebAPI-Basic-Authentication-Authorization-Filter)
- [Accepting Raw Request Body Content with ASP.NET Web API](https://weblog.west-wind.com/posts/2013/Dec/13/Accepting-Raw-Request-Body-Content-with-ASPNET-Web-API)
- [HTTP Message Handlers in ASP.NET Web API](https://docs.microsoft.com/en-us/aspnet/web-api/overview/advanced/http-message-handlers)
- HTTP Status 428 Precondition required [Optimistic concurrency support in HTTP and WebAPI – part 2](https://tudorturcu.wordpress.com/2012/05/17/optimistic-concurrency-support-in-http-and-webapi-part-2/)

### Error handling

- [Bypassing IIS Error Messages in ASP.NET](https://weblog.west-wind.com/posts/2017/Jun/01/Bypassing-IIS-Error-Messages-in-ASPNET)

### CORS

- [CORS, IIS and WebDAV](https://brockallen.com/2012/10/18/cors-iis-and-webdav/)

### Troubleshooting

##### 404.17

- [Error message when you visit a Web site that is hosted on IIS 7.0: "HTTP Error 404.17 - Not Found"](https://support.microsoft.com/en-gb/help/2019689/error-message-when-you-visit-a-web-site-that-is-hosted-on-iis-7.0-http-error-404.17---not-found)

# IIS

- Customer error page [HTTP Errors](https://www.iis.net/configreference/system.webserver/httperrors)
- [App Offline with Http Errors](http://www.richrout.com/Blog/Post/6/app-offline-with-http-errors)
- [Using Let's Encrypt with IIS on Windows - Rick Strahl's Web Log](https://weblog.west-wind.com/posts/2016/Feb/22/Using-Lets-Encrypt-with-IIS-on-Windows)

# IIS Express

### Making ASP.NET site running on a Windows VM on Mac (and accessing it via a web client on Mac (the host))

- To make IIS Express to serve multiple bindings, edit
 `$(SolutionDir)\.vs\config\applicationhost.config`
  (look for configuration/system.applicationHost/sites/site/bindings) and add
  a binding with the Windows machine name. For instance, `<binding protocol="http" bindingInformation="*:3048:alex-windows" />`.
- Configure `HTTP.SYS` at the kernel by makingan "URL Reservation" `netsh http add urlacl url=http://alex-windows:3048/ user=everyone`.
- Add a firewall rule `netsh firewall add portopening TCP 3048 IISExpressWeb enable ALL`.
- On Mac, edit `/etc/hosts` to add `172.16.120.128 alex-windows` (or any IP of the guest VM).

##### To show existing URL reservations

```sh
netsh http show urlacl
```

##### To delete an existing URL reservation

```sh
netsh http delete urlacl url=http://alex-windows:3048/
```

# MSSQL

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

- Avoid being too greedy with Rows
- The ‘N+1 Select’ problem: Minimising the trips to the database
  - Use of `.Include()`
- Avoid being too greedy with columns
  - use less network bandwidth
  - a good indexing strategy involves considering what columns you frequently match against and what columns are returned when searching against them, along with judgements about disk space requirements and the additional performance penalty indexes incur on writing
- Avoid mismatched data types
  - for instance, database definition of `VARCHAR` in database where EF consider the value as `NVARCHAR` and this results a `CONVERT`. To solve this, either change database definition to `NVARCHAR` or applying attribute `[Column(TypeName =  "varchar")]`.
- Add missing indexes
  - `CREATE NONCLUSTERED INDEX [NonClusteredIndex_City] ON [dbo].[Pupils] ([City]) INCLUDE ([FirstName], [LastName]) ON [PRIMARY]` creates a non-clustered index for queries filtering against city and serves first and last names
- Avoid overly-generic queries

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

- Avoid bloating the plan cache
  - in order for a plan to be reused, the statement text must be identical which is the case for parameterised queries
    - but there is a case when this doesn’t happen – when we use `.Skip()` or `.Take()`
    - use lambda function in `IQueryable.Skip()` and `IQueryable.Take()`
  - enable a SQL Server setting called 'optimise for ad-hoc workloads'
    - this makes SQL Server less aggressive at caching plans, and is generally a good thing to enable, but it doesn’t address the underlying issue
- Using bulk insert
  - `EF.BulkInsert()`
    - this will be supported out of the box in EF 7.0
- Disable tracking in read-only queries

```csharp
string city =  "New York";
var schools =
  db.Schools
    .AsNoTracking()
    .Where(s => s.City == city)
    .Take(100)
    .ToList();
```

- Allowing EF to make and receive multiple requests to SQL Server over a single connection, reducing the number of roundtrips
  - `MultipleActiveResultSets=True;`

##### Building SQL deployment package

To build SQL projects

```powershell
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

```console
SqlPackage.exe `
    /sf:Assets.Database.dacpac `
    /a:Script /op:create.sql /p:CommentOutSetVarDeclarations=true `
    /tsn:.\SQLEXPRESS /tdn:AssetsDB /tu:sa /tp:$sa_password
```

##### Running SQL deployment scripts

```powershell
$SqlCmdVars = "DatabaseName=AssetsDB", "DefaultFilePrefix=AssetsDB", "DefaultDataPath=c:\database\", "DefaultLogPath=c:\database\"
Invoke-Sqlcmd -InputFile create.sql -Variable $SqlCmdVars -Verbose
```

##### Links

- [Common LINQ mistakes](https://github.com/SanderSade/common-linq-mistakes/blob/master/readme.md)

# Azure

### SQL

- [Unable to create table](https://social.msdn.microsoft.com/forums/azure/en-US/259af3d5-4016-43e2-9a84-7a17d4f52673/im-unable-to-create-a-new-table-on-sql-azure)
- [Keyword not supported: “data source” initializing Entity Framework Context](http://stackoverflow.com/questions/6997035/keyword-not-supported-data-source-initializing-entity-framework-context)
- [Windows Azure, Entity Framework. Keyword not supported: 'metadata'](http://stackoverflow.com/questions/13908348/windows-azure-entity-framework-keyword-not-supported-metadata)

# General Practices

### To increase testability (C#)
- No object instantiation in business logics
- Constructor - nothing more than simple assignments
- Avoid global state - no `DateTime.Now`,  no `Math.Random()`, ... etc
- Avoid public `init()`-kind of methods
- Avoid the use of service locator as it hides dependencies. (However, it is still better than singleton which is a share state)

### Multi-threading

- [Threading in C#](http://www.albahari.com/threading/part4.aspx)

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
1. If a filter is to be applied, all entries must be retrieved before any filtering.
2. If no filtering is required, real paging can be accomplished using ObjectDataSource, but not SqlDataSource.

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
