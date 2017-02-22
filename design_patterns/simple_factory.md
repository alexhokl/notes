### Simple Factory

```cs
public interface IProcessor
{
    void PreProcess();
    void Process();
    void PostProcess();
    string GetResult();
}

public static class ProcessorFactory<T>
{
    public static T Create(string config)
    {
        Type type = GetType(string.Format("Processor{0}"));
        return (T)Activator.CreateInstance(type);
    }

    private static Type GetType(string key)
    {
        string className = ConfigurationManager.AppSettings[string.Format("Dynamic{0}", key)];
        if (string.IsNullOrWhiteSpace(className))
        {
            throw new ApplicationException(
                string.Format(
                    "Unable to retrieve configuration [{0}].",
                    key));
        }
        Type type = Type.GetType(className);
        if (type == null)
        {
            throw new ApplicationException(
                string.Format(
                    "Unable to get type object from name [{0}].",
                    className));
        }
        return type;
    }
}

public class RealProcessor : IProcessor
{
    public void PreProcess()
    {
        // Do something...
    }

    public void Process()
    {
        // Do something...
    }

    public void PostProcess()
    {
        // Do something...
    }

    public string GetResult()
    {
        return "Some real message.";
    }
}

public class StrategyConsumer
{
    /// This method encapsulates the strategy
    /// (which alaway stays the same and unlikely be changed).
    public string ApplyStrategeAndGetResult()
    {
        IProcessor processor = ProcessorFactory<IProcessor>.Create("Config");
        processor.PreProcess();
        processor.Process();
        processor.PostProcess();
        return processor.GetResult();
    }
}
```
