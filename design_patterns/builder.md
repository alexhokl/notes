- [Builder](#builder)
____

### Builder

##### Intent

- Seaparate the constrcution of a complex object from its representation so that the same construction process can create different representations.

##### Example

- Building an export functionality for a word-processing application.

##### Applicability

- the algorithm for creating a complex object should be independent of the parts that make up the object and how they are assembled.
- the construction process must allow different representations for the object that is constructed.

##### Characteristics

- the concrete builder maintains a represetation of the product.
- in the end, the client will have to retrieve the final product from builder directly.
- there is usally no common interface for the final product as it could be very different for each builder.
- it allows step-by-step construction of a product.

```cs
public interface IDocumentBuilder
{
    void AddText(string text, string style);
    void AddLink(string link, string text, string style);
    void AddPicture(string link, string style);
}

public class PdfBuilder : IDocumentBuilder
{
    public PdfBuilder()
    {
        this.document = new object();
    }

    public void AddText(string text, string style)
    {
        // some work on the document object
    }

    public void AddLink(string link, string text, string style)
    {
        // some work on the document object
    }

    public void AddPicture(string link, string style)
    {
        // some work on the document object
    }

    public object GetDocument()
    {
        return document;
    }

    private object document;
}

public class WordBuilder : IDocumentBuilder
{
    public WordBuilder()
    {
        this.document = new object();
    }

    public void AddText(string text, string style)
    {
        // some work on the document object
    }

    public void AddLink(string link, string text, string style)
    {
        // some work on the document object
    }

    public void AddPicture(string link, string style)
    {
        // some work on the document object
    }

    public object GetDocument()
    {
        return document;
    }

    private object document;
}

public class XmlBuilder : IDocumentBuilder
{
    public XmlBuilder()
    {
        this.document = new object();
    }

    public void AddText(string text, string style)
    {
        // some work on the document object
    }

    public void AddLink(string link, string text, string style)
    {
        // some work on the document object
    }

    public void AddPicture(string link, string style)
    {
        // some work on the document object
    }

    public object GetDocument()
    {
        return document;
    }

    private object document;
}

public class CountBuilder : IDocumentBuilder
{
    public void AddText(string text, string style)
    {
        this.countText++;
    }

    public void AddLink(string link, string text, string style)
    {
        this.countLink++;
    }

    public void AddPicture(string link, string style)
    {
        this.countPicture++;
    }

    public int GetTextCount()
    {
        return this.countText;
    }

    public int GetLinkCount()
    {
        return this.countLink;
    }

    public int GetPictureCount()
    {
        return this.countPicture;
    }

    private int countPicture = 0;
    private int countLink = 0;
    private int countText = 0;
}

public class HtmlParser
{
    public void Parse(string htmlDocument, ref IDocumentBuilder builder)
    {
        var components = GetComponents(htmlDocument);
        foreach (var c in components)
        {
            var type = GetComponentType(c);
            var style = GetStyle(c);
            var link = GetLink(c);
            var text = GetText(c);
            switch (type)
            {
                case ComponentType.Text:
                    builder.AddText(text, style);
                    break;
                case ComponentType.Link:
                    builder.AddLink(link, text, style);
                    break;
                case ComponentType.Image:
                    builder.AddPicture(link, style);
                    break;
                default:
                    throw new NotSupportedException(
                        string.Format(
                            "Component type [{0}] is not supported.",
                            type));
            }
        }
    }

    private IEnumerable<string> GetComponents(string htmlDocument)
    {
        yield return "part of the document";
    }

    private ComponentType GetComponentType(string component)
    {
        if (component.StartsWith("<a "))
            return ComponentType.Link;
        if (component.StartsWith("<img "))
            return ComponentType.Image;
        return ComponentType.Text;
    }

    private string GetStyle(string component)
    {
        return "Bold";
    }

    private string GetLink(string component)
    {
        return "http://www.google.com";
    }

    private string GetText(string component)
    {
        return "some text";
    }
}

public enum ComponentType
{
    Text,
    Link,
    Image
}

public class Client
{
    public object Export(string htmlDocument)
    {
        string config = "DesignPatterns.Builder.XmlBuilder, DesignPatterns";
        Type type = Type.GetType(config);
        IDocumentBuilder builder = Activator.CreateInstance(type) as IDocumentBuilder;
        HtmlParser parser = new HtmlParser();
        parser.Parse(htmlDocument, ref builder);

        // the builder interface does not usually contains a method for
        // retrieving the final product as the final product can be
        // very different for each builder
        XmlBuilder xmlBuilder = builder as XmlBuilder;
        return xmlBuilder.GetDocument();
    }
}
```
