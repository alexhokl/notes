- [Abstract Factory](#abstract-factory)
____

### Abstract Factory

##### Intent

- Provide an interface for creating families of relaed or dependent objects without specifying their concrete classes.

##### Examples

- ToolKit classes in Java.

##### Applicability

- a system should be independent of how its products are created, composed, and represented.
- a system should be configured with one of multiple families of products.
- a family of related product objects is designed to be used together, and you need to enforce this constraint.

##### Drawbacks

- Supporting new kinds of products means changing the code in AbstractFactory.


```cs
public interface IProcessor
{
    void PreProcess();
    void Process();
    void PostProcess();
    string GetResult();
}

/// Concept of abstract factory: like a set of factories creating different managers.
/// Thus, whenever a new manager is needed, the code of abstract factory needs to be changed.
public interface IFactory
{
    IRequirementManager CreateRequirementManager();
    IProcessor CreateProcessor();
    IResultManager CreateResultManager();
}

public interface IRequirementManager
{
    void EnsureHardware();
    void EnsureSoftware();
}

public interface IResultManager
{
    void PresentResult(string result);
}

public class Processor : IProcessor
{
    public void PreProcess()
    {
        // some pre-processing
    }

    public void Process()
    {
        // some processing
    }

    public void PostProcess()
    {
        // some post-processing
    }

    public string GetResult()
    {
        return "A text result";
    }
}

public class RequirementManager : IRequirementManager
{
    public void EnsureHardware()
    {
        // checks the hardware
    }

    public void EnsureSoftware()
    {
        // checks the software
    }
}

public class ResultManager : IResultManager
{
    public void PresentResult(string result)
    {
        // code displays the text
    }
}

public class Client
{
    public void Main()
    {
        string config = "DesignPatterns.AbstractFactory.Factories.TextFactory, DesignPatterns";
        Type type = Type.GetType(config);
        IFactory factory = Activator.CreateInstance(type) as IFactory;
        this.Process(factory);
    }

    private void Process(IFactory factory)
    {
        IRequirementManager requirementManager = factory.CreateRequirementManager();
        requirementManager.EnsureHardware();
        requirementManager.EnsureSoftware();

        IProcessor processor = factory.CreateProcessor();
        processor.PreProcess();
        processor.Process();
        processor.PostProcess();
        string result = processor.GetResult();

        IResultManager resultManager = factory.CreateResultManager();
        resultManager.PresentResult(result);
    }
}
```
