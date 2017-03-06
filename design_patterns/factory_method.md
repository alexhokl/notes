### Factory method

```cs
public interface IProcessor
{
    void PreProcess();
    void Process();
    void PostProcess();
    string GetResult();
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

/// The advantage of this abstract implementation over the static implementation (see SimpleFactory)
/// is that it further decouples the IProcessor creation logics from the strategy. It essentially means
/// you can have one factory creating IProcessor objects based on XML configuration and another factory
/// creating IProcessor objects based on database configuration, for example.
/// Any other methods implemented in this abstract creator are written to operate on
/// products created by the factory method.
public abstract class ProcessorFactoryBase
{
    /// Factory method does not have to be abstract as this can allow default creation.
    public abstract IProcessor Create(string config);

    public string ApplyStrategeAndGetResult(string config)
    {
        IProcessor processor = this.Create(config);
        processor.PreProcess();
        processor.Process();
        processor.PostProcess();
        return processor.GetResult();
    }
}

public class RealProcessorFactory : ProcessorFactoryBase
{
    public override IProcessor Create(string config)
    {
        Type type = GetType(string.Format("Processor{0}"));
        return Activator.CreateInstance(type) as IProcessor;
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

public class StrategyConsumer
{
    public string ApplyStrategeAndGetResult()
    {
        ProcessorFactoryBase factory = new RealProcessorFactory() as ProcessorFactoryBase;
        return factory.ApplyStrategeAndGetResult("config");
    }
}
```
