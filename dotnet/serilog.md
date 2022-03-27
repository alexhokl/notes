- [Links](#links)
- [Initialisation](#initialisation)
- [Requests Logging](#requests-logging)
- [Adding properties to logs](#adding-properties-to-logs)
- [Enrichers](#enrichers)
____
## Links

- [Serilog Best Practices](https://benfoster.io/blog/serilog-best-practices/)

## Initialisation

```csharp
public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
  WebHost
    .CreateDefaultBuilder(args)
    .UseConfiguration(new ConfigurationBuilder().AddCommandLine(args).Build())
    .ConfigureLogging(
      (hostContext, services, loggerConfig) =>
      {
        loggerConfig.ReadFrom.Configuration(hostContext.Configuration);
      })
    .UseStartup<Startup>()

public static IWebHostBuilder ConfigureLogging(
    this IWebHostBuilder builder,
    Action<WebHostBuilderContext, IServiceProvider,
    LoggerConfiguration> configureLogger)
{
    builder.ConfigureServices((context, collection) =>
    {
        var loggerConfiguration = new LoggerConfiguration();
        var serviceProvider = collection.BuildServiceProvider();
        configureLogger(context, serviceProvider, loggerConfiguration);
        var logger = loggerConfiguration.CreateLogger();
        Log.Logger = logger
        collection.AddSingleton<ILoggerFactory>(services =>
            new SerilogLoggerFactory(null, true, null));
        ConfigureServices(collection, logger);
    });

    return builder;
}

static void ConfigureServices(IServiceCollection collection, Serilog.ILogger logger)
{
    if (logger != null)
    {
        collection.AddSingleton(logger);
    }

    var diagnosticContext = new DiagnosticContext(logger);
    collection.AddSingleton(diagnosticContext);
    collection.AddSingleton<IDiagnosticContext>(diagnosticContext);
}
```

or,

```csharp
public static IHostBuilder CreateHostBuilder(string[] args) =>
  Host.CreateDefaultBuilder(args)
    .ConfigureWebHostDefaults(webBuilder =>
    {
      webBuilder.UseStartup<Startup>();
    })
    .UseSerilog((hostContext, loggerConfig) =>
      loggerConfig.ReadFrom.Configuration(hostContext.Configuration));
```

## Requests Logging

```csharp
public void Configure(IApplicationBuilder app, IHostEnvironment env)
{
  app.UseSerilogRequestLogging();
}
```

## Adding properties to logs

```csharp
public static IDisposable AddToContext(
    this Microsoft.Extensions.Logging.ILogger logger,
    IEnumerable<KeyValuePair<string, object>> properties)
{
    return logger.BeginScope(properties);
}

public static void LogError(
    this Microsoft.Extensions.Logging.ILogger logger,
    Exception ex,
    string message,
    Dictionary<string, object> logProperties)
{
    logProperties.AddExceptionToDictionary(ex);

    logger.LogError(
        ex,
        GetMessageTemplate(logProperties, message),
        logProperties.Values.ToArray());
}

private static string GetMessageTemplate(Dictionary<string, object> dic, string message)
{
  var stringBuilder = new StringBuilder(message);

  // to escape the braces in the message
  stringBuilder.Replace("{", "{{");
  stringBuilder.Replace("}", "}}");

  stringBuilder.Append(' ');

  foreach (var dicItem in dic)
  {
    stringBuilder.Append('{');

    if (dicItem.Value != null && !dicItem.Value.GetType().IsPrimitive && !(dicItem.Value is string))
    {
      // Serilog will serialise the object as JSON string
      stringBuilder.Append('@');
    }
    stringBuilder.Append(dicItem.Key);
    stringBuilder.Append('}');
  }
  return stringBuilder.ToString();
}

public static void AddExceptionToDictionary(this Dictionary<string, object> dic, Exception ex)
{
  foreach (DictionaryEntry item in ex.Data)
  {
    var key = item.Key.ToString();
    if (dic.ContainsKey(key))
    {
      dic[key] = item.Value;
    }
    else
    {
      dic.Add(key, item.Value);
    }
  }

  if (ex.InnerException != null)
  {
    AddExceptionToDictionary(dic, ex.InnerException);
  }
}
```

## Enrichers

```csharp
public class ExceptionTypeEnricher : ILogEventEnricher
{
  public void Enrich(LogEvent logEvent, ILogEventPropertyFactory propertyFactory)
  {
    if (logEvent.Exception == null)
        return;

    logEvent.AddPropertyIfAbsent(
      new LogEventProperty(
        "ExceptionType",
        new ScalarValue(logEvent.Exception.GetType().FullName)));
  }
}

public class TraceIdEnricher : ILogEventEnricher
{
  private readonly IHttpContextAccessor _httpContextAccessor;

  public UserSessionEnricher() : this(new HttpContextAccessor())
  {
  }

  internal UserSessionEnricher(IHttpContextAccessor httpContextAccessor)
  {
    _httpContextAccessor = httpContextAccessor;
  }

  public void Enrich(LogEvent logEvent, ILogEventPropertyFactory propertyFactory)
  {
    var context = _httpContextAccessor.HttpContext;
    var userNameProperty =
      new LogEventProperty(
        "trace_id", new ScalarValue(context.TraceIdentifier));
    logEvent.AddPropertyIfAbsent(userNameProperty);
  }
}

public static LoggerConfiguration WithTraceId(this LoggerEnrichmentConfiguration enrichmentConfiguration)
{
    return enrichmentConfiguration.With<TraceIdEnricher>();
}

public static LoggerConfiguration WithExceptionType(this LoggerEnrichmentConfiguration enrichmentConfiguration)
{
    return enrichmentConfiguration.With<ExceptionTypeEnricher>();
}
```

Enrichers can be configured using `appsettings.json`

```json
{
  "Serilog": {
    "Enrich": [
      "WithTraceId",
      "WithExceptionType"
    ]
  }
}
```
