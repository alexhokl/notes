- [C# 12](#c%23-12)
  * [Primary constructor](#primary-constructor)
  * [Inline arrays](#inline-arrays)
    + [Array](#array)
    + [List](#list)
    + [Immutable array](#immutable-array)
    + [Default values](#default-values)
____

# C# 12

## Primary constructor

```csharp
public class Person(string Name, int age)
{
    public string Name { get; set; } = name ?? throw new ArgumentNullException(nameof(name));
}
```

is equivalent to

```csharp
public class Person
{
    public Person(string name, int age)
    {
        this.Name = name ?? throw new ArgumentNullException(nameof(name));
        _age = age;
    }

    public string Name { get; set; }
    private int _age = age;
}
```

## Inline arrays

### Array

```csharp
int[] x = [1, 2, 3, 4, 5];
```

is equivalent to

```csharp
int[] x = new int[] { 1, 2, 3, 4, 5 };
```

### List

```csharp
List<int> x = [1, 2, 3, 4, 5];
```

is equivalent to

```csharp
List<int> x = new List<int>{ 1, 2, 3, 4, 5 };
```

### Immutable array

```csharp
ImmutableArray<int> x = [1, 2, 3, 4, 5];
```

is equivalent to

```csharp
ImmutableArray<int> x = ImmutableArray.Create(1, 2, 3, 4, 5);
```

### Default values

```csharp
var people = await GetPeople() ?? [];

Task<List<Person>?> GetPeople()
{
    return
        Task.FromResult(
            new List<Person>
            {
                new Person("John", 25),
                new Person("Jane", 30)
            });
}
```
