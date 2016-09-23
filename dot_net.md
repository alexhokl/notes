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
