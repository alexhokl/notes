### To increase testability (C#)
- No object instantiation in business logics
- Constructor - nothing more than simple assignments
- Avoid global state - no `DateTime.Now`,  no `Math.Random()`, ... etc
- Avoid public `init()`-kind of methods
- Avoid the use of service locator as it hides dependencies. (However, it is still better than singleton which is a share state)

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


##### File system classes

- Separated into two types
  - informational
  - utility
- Most of the informational classes derive from the FileSystemInfo base class.
- FileSystemInfo.Delete
  - Removes the file or directory from the file system
- FileSystemInfo.Refresh
  - Updates the data in the class with the most current information from the file system
- FileInfo.Replace
  - Replaces a file with the information in the current FileInfo object.
- DirectoryInfo.CreateSubDirectory
  - Creates a new directory as a child directory of the current directory in the directory hierarchy
- DirectoryInfo.Root
  - Gets the root part of the directory’s path as a string
    - e.g. C:\
- DriveInfo.AvailableFreeSpace
  - Gets the amount of available space on the drive. The amount might be different from the amount returned by TotalFreeSpace (described later in this table), depending on disk quotas.

