### Singleton

Note that a pure static class cannot be used as a singleton as it is not thread
safe. Also note that `IDisposable` is a nice-to-have.

```cs
public sealed class SingletonClass : IDisposable
{
    /// Prevents a default instance of the class from being created.
    /// Things coded in this constructor must be thread-safe so that
    /// this implementation as a whole is thread-safe.
    private SingletonClass()
    {
    }

    /// Returns the singleton instance.
    public static SingletonClass Instance
    {
        get
        {
            // this double-check locking approach solves
            // the thread concurrency problems while
            // avoiding an exclusive lock in every call to the Instance property method.
            if (instance == null)
            {
                lock (synRoot)
                {
                    if (instance == null)
                        instance = new SingletonClass();
                }
            }
            return instance;
        }
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    private void Dispose(bool disposing)
    {
        if (_disposed) return;
        if (disposing)
        {
            _instance = null;
            // dispose whatever managed resources this instance claimed below
        }
        _disposed = true;
    }

    /// volatile is used to ensure that
    /// assignment to the instance variable completes before
    /// the instance variable can be accessed.
    private static volatile SingletonClass instance;

    /// The reason that this is used by the lock instead of the type of instance is to avoid deadlock.
    private static object synRoot = new object();

    private bool _disposed;
}
```

See also [Design Patterns: Singleton](https://www.youtube.com/watch?v=sbML3xFHRbI)
