- [Entity Framework Core](#entity-framework-core)
  * [Useful Libraries](#useful-libraries)
  * [Links](#links)
  * [What's new in EF Core 7](#whats-new-in-ef-core-7)
  * [Data Context](#data-context)
  * [Modeling](#modeling)
    + [Concepts](#concepts)
    + [Adding models](#adding-models)
    + [To exclude models](#to-exclude-models)
    + [Properties](#properties)
    + [Auto-generated values](#auto-generated-values)
    + [Non-nullable columns](#non-nullable-columns)
    + [Maximum length](#maximum-length)
    + [Concurrency](#concurrency)
    + [Shadow properties](#shadow-properties)
    + [Inheritance](#inheritance)
    + [Backing fields](#backing-fields)
    + [Value conversion](#value-conversion)
    + [Seeding](#seeding)
    + [Entity type constructors](#entity-type-constructors)
    + [Relational database - table mapping](#relational-database---table-mapping)
    + [Relational database - data types](#relational-database---data-types)
    + [Relational database - data types](#relational-database---data-types-1)
    + [Relational database - default schema](#relational-database---default-schema)
    + [Relational database - computed columns](#relational-database---computed-columns)
    + [Relational database - sequences](#relational-database---sequences)
    + [Indexes](#indexes)
    + [Relational database - indexes](#relational-database---indexes)
    + [Keys](#keys)
    + [Alternate key](#alternate-key)
    + [Relational database - foreign key](#relational-database---foreign-key)
    + [Cascade Delete](#cascade-delete)
    + [Transactions](#transactions)
    + [Disconnected Entities](#disconnected-entities)
    + [Relationships](#relationships)
    + [Loading](#loading)
    + [Cyclic navigation properties](#cyclic-navigation-properties)
  * [Migration](#migration)
    + [Creation](#creation)
    + [Applying migration](#applying-migration)
    + [Generating migration scripts](#generating-migration-scripts)
  * [Logging](#logging)
  * [Pagination](#pagination)
  * [Anti-patterns](#anti-patterns)
  * [Upgrade from version 2.1](#upgrade-from-version-21)
- [Entity Framework (Classic)](#entity-framework-classic)
    + [Improving performance](#improving-performance)
    + [Building SQL deployment package](#building-sql-deployment-package)
    + [Generate SQL scripts from deployment package](#generate-sql-scripts-from-deployment-package)
    + [Running SQL deployment scripts](#running-sql-deployment-scripts)
____

# Entity Framework Core

## Useful Libraries

- [borisdj/EFCore.BulkExtensions](https://github.com/borisdj/EFCore.BulkExtensions)
- [Arch/AutoHistory](https://github.com/Arch/AutoHistory/)
- [Arch/UnitOfWork](https://github.com/Arch/UnitOfWork)
- [zzzprojects/EntityFramework-Plus](https://github.com/zzzprojects/EntityFramework-Plus)
- [Dapper](https://github.com/StackExchange/Dapper)
- [SqlKata](https://sqlkata.com/)

## Links

- [Breaking changes in EF Core 7.0
  (EF7)](https://learn.microsoft.com/en-gb/ef/core/what-is-new/ef-core-7.0/breaking-changes)
- [Breaking changes in EF Core
  8 (EF8)](https://learn.microsoft.com/en-gb/ef/core/what-is-new/ef-core-8.0/breaking-changes)
- [What's New in EF Core
  8](https://learn.microsoft.com/en-gb/ef/core/what-is-new/ef-core-8.0/whatsnew)
- [Compare EF Core & EF6](https://docs.microsoft.com/en-us/ef/efcore-and-ef6/)
- [Logging - EF Core](https://docs.microsoft.com/en-us/ef/core/miscellaneous/logging)
- [Common LINQ mistakes](https://github.com/SanderSade/common-linq-mistakes/blob/master/readme.md)
- [SQLException
  Numbers](https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/cc645603(v=sql.105))

## What's new in EF Core 7

##### To avoid fetching a lot of data for EF to update some columns

```cs
await context.Blogs
  .Where(b => b.Rating == 1)
  .ExecuteUpdateAsync(updates => updates.SetProperty(b => b.IsActive, false);
```

```cs
await context.Blogs
  .Where(b => b.Posts.Any(p => p.Views > 0)
  .ExecuteUpdateAsync(updates => updates.SetProperty(b => b.IsActive, false);
```

```cs
await context.Posts
  .Where(p => p.Blog.Rating == 1)
  .ExecuteUpdateAsync(updates => updates.SetProperty(p => p.Views, p => p.Views + 1));
```

```cs
await context.Blogs
  .Where(b => b.Rating == 1)
  .ExecuteDeleteAsync();
```

The above examples avoid heavy operation (in terms of both time to complete and
memory consumption) of `.SaveChanges()`. This also does not wait for
`.SaveChanges()` and it breaks values of tracked entities.

##### Aggregated functions (and bring things to old EF6 feature parity)

```cs
var categories =
  await context.Blogs
    .GroupBy(b => b.Category)
    .Select(g => New
      {
        Category = g.Key,
        StddevViews = EF.Functions.StandardDeviationPopulation(g.Select(b => b.Views)),
      });
```

where `EF.Functions` is a way to apply database engine specific (SQL server,
PostgreSQL) functions.

```cs
var categories =
  await context.Blogs
    .GroupBy(b => b.Category)
    .Select(g => New
      {
        Category = g.Key,
        Names = string.Join(", ", g.Where(b => b.Views > 2).OrderBy(b => b.Views).Select(b => b.Name)),
      });
```

##### JSON columns

There is a chance that an indexed computed JSON property can be faster than
a table join. For instance, table `Company` joining `CompanyAddress` compared to
`Company.Address.Country`.

## Data Context

- an instance of `DbContext` does not support concurrent accesses
- `InvalidOperationException` will be thrown if there is concurrent accesses or
  `await` keyword is not used for asynchronous calls
- `AddDbContext` registers instantiation of `DbContext` instances with `Scoped`
  and this implies it is instantiated on per HTTP request basis

## Modeling

### Concepts

There are 3 ways of setting up models.

1. by convention
2. data annotation
3. fluent API (`DbContext.OnModelCreating()` and it has highest priority over
   others)

### Adding models

- by convention, declaring `DbSet<TEntity>` in `DbContext`, or
- invoking `modelBuilder.Entity<TEntity>` in `DbContext.OnModelCreating()`

### To exclude models

- adding attribute `[NotMapped]` to a class, or
- invoking `modelBuilder.Ignore<TEntity>` in `DbContext.OnModelCreating()`

### Properties

By convention, all `get` and `set` methods will be included.

To exclude a property,

- apply attribute `[NotMapped]`, or
- use `modelBuilder.Entity<TEntity>().Ignore(b => b.YourPropertyName)`

### Auto-generated values

- if the value is generated on DB, EF will assign a temporary value to the
  property. The value will be replaced by a real value from database when
  `SaveChanges()` is invoked
- `modelBuilder.Entity<TEntity>().Property(b => b.YourPropertyName).HasDefaultValue(3)`
- `modelBuilder.Entity<TEntity>().Property(b => b.YourPropertyName).HasDefaultValueSql("getdate()")`
- by convention, primary keys of type `short`, `int`, or `Guid`, an
  auto-generated value will be assigned upon creation
- to avoid auto-generated value
  - apply attribute `[DatabaseGenerated(DatabaseGeneratedOption.None)]`, or
  - `modelBuilder.Entity<TEntity>().Property(b => b.YourPropertyName).ValueGeneratedNever()`
- for identity columns
  - apply attribute `[DatabaseGenerated(DatabaseGeneratedOption.Identity)]`, or
  - `modelBuilder.Entity<TEntity>().Property(b => b.YourPropertyName).ValueGeneratedOnAdd()`
- for computed columns
  - apply attribute `[DatabaseGenerated(DatabaseGeneratedOption.Computed)]`, or
  - `modelBuilder.Entity<TEntity>().Property(b => b.YourPropertyName).ValueGeneratedOnAddOrUpdate()`

### Non-nullable columns

- use non-nullable types, or
- apply attribute `[Required]`, or
- `modelBuilder.Entity<TEntity>().Property(b => b.YourPropertyName).IsRequired()`

### Maximum length

This applies to types of `string` and `byte[]`. However, there is no validation
from EF.

To apply the limit

- apply attribute `[MaxLength(100)]`, or
- `modelBuilder.Entity<TEntity>().Property(b => b.YourPropertyName).HasMaxLength(100)`

### Concurrency

Reference: [Handling Concurrency Conflicts](https://docs.microsoft.com/en-us/ef/core/saving/concurrency)

EF Core implements optimistic concurrency control, meaning that it will let
multiple processes or users make changes independently without the overhead of
synchronization or locking. In the ideal situation, these changes will not
interfere with each other and therefore will be able to succeed. In the worst
case scenario, two or more processes will attempt to make conflicting changes,
and only one of them should succeed.

Properties configured as concurrency tokens are used to implement optimistic
concurrency control: whenever an update or delete operation is performed during
`SaveChanges`, the value of the concurrency token on the database is compared
against the original value read by EF Core.

- If the values match, the operation can complete.
- If the values do not match, EF Core assumes that another user has performed
  a conflicting operation and aborts the current transaction and throws
  `DbUpdateConcurrencyException`

Database providers are responsible for implementing the comparison of
concurrency token values.

Resolving concurrency conflicts is possible with methods and properties
available in `DbUpdateConcurrencyException` (see reference above).

To mark a property as concurrency token

- apply attribute `[ConcurrencyCheck]`, or
- `modelBuilder.Entity<TEntity>().Property(b => b.YourPropertyName).IsConcurrencyToken()`

Timestamp property is also considered as concurrency token. To make a property
as timestamp

- apply attribute `[Timestamp]` to a property of `byte[]`, or
- `modelBuilder.Entity<TEntity>().Property(b => b.YourPropertyName).IsRowVersion()`

Note that the implementation of timestamp depends on the underlying data
provider.

### Shadow properties

Shadow properties are properties that are not defined in an entity class but
are defined for that entity type in the EF Core model. The value and state of
these properties is maintained purely in the Change Tracker. An example is
foreign key property.

For example, shadow property `Post.BlogId` will be generated.

```csharp
public class Blog
{
    public int BlogId { get; set; }
    public string Url { get; set; }
    public List<Post> Posts { get; set; }
}

public class Post
{
    public int PostId { get; set; }
    public string Title { get; set; }
    public string Content { get; set; }
    public Blog Blog { get; set; } // results in shadow property
}
```

Customised shadow property can be added by

```csharp
modelBuilder.Entity<TEntity>().Property(b => b.YourPropertyName)
```

The value of a shadow property can be retrieved by

```csharp
context.Entry<TEntity>().Property("YourPropertyName").CurrentValue
```

To reference a shadow property

```csharp
context.YourEntity.OrderBy(e => EF.Property<DateTime>(e, "YourPropertyName"))
```

### Inheritance

By default, it is up to the database provider to determine how inheritance will
be represented in the database.

EF will only setup inheritance if two or more inherited types are explicitly
included in the model (that is, via `DbSet` declarations). EF will not scan
for base or derived types that were not otherwise included in the model.

- To explicitly declaring a parent
  `modelBuilder.Entity<TEntity>().HasBaseType<TParentEntity>()`
- To remove a parent from a child
  `modelBuilder.Entity<TEntity>().HasBaseType((Type)null)`

#### Relational databases

The base type of the provider is `Microsoft.EntityFrameworkCore.Relational`.

Currently, only the table-per-hierarchy (TPH) pattern is implemented in EF
Core. Other common patterns like table-per-type (TPT) and
table-per-concrete-type (TPC) are not yet available.

TPH uses a single table to store the data for all types in the hierarchy.
A discriminator column is used to identify which type each row represents.

The discriminator column will be made nullable.

#### Example

```csharp
public class YourContext : DbContext
{
    public DbSet<Blog> Blogs { get; set; }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.Entity<Blog>()
            .HasDiscriminator<string>("blog_type")
            .HasValue<Blog>("blog_base")
            .HasValue<RssBlog>("blog_rss")
    }
}

public class Blog
{
    public int BlogId { get; set; }
    public int Url { get; set; }
}

public class RssBlog : Blog
{
    public int RssUrl { get; set; }
}
```

Note that the discriminator is created as a shadow property.

To have a column created explicitly,

```csharp
public class YourContext : DbContext
{
    public DbSet<Blog> Blogs { get; set; }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.Entity<Blog>()
            .HasDiscriminator(b => b.BlogType);

        builder.Entity<Blog>()
            .Property(e => e.BlogType)
            .HasLength(200)
            .HasColumnName("blog_type");
    }
}

public class Blog
{
    public int BlogId { get; set; }
    public int Url { get; set; }
    public int BlogType { get; set; }
}

public class RssBlog : Blog
{
    public int RssUrl { get; set; }
}
```

### Backing fields

When a backing field is configured, EF will write directly to that field when
materialising entity instances from the database (rather than using the
property setter). If EF needs to read or write the value at other times, it
will use the property if possible.

#### Convention

The field names are processed in this order

1. `_camelCaseOfProprtyName`
2. `_PropertyName`
3. `m_camelCaseOfPropertyName`
4. `m_PropertyName`

#### Fluent API

```csharp
modelBuilder.Entity<Blog>().Property(b => b.Url).HasField("_validatedUrl")
```

### Value conversion

Value converters are specified in terms of a `ModelClrType` and
a `ProviderClrType`. The model type is the .NET type of the property in the
entity type. The provider type is the .NET type understood by the database
provider. Conversion are defined using two `Func` expression trees: one from
`MoModelClrType` to `ProviderClrType` and the other for the opposite way.
Expression trees are used so that they can be compiled into the database access
code for efficient conversions. For complex conversions, the expression tree
may be a simple call to a method that performs the conversion.

```csharp
modelBuilder
  .Entity<Rider>()
  .Property(e => e.Mount)
  .HasConversion(
      v => v.ToString(),
      v => (EquineBeast)Enum.Parse(typeof(EquineBeast), v));
```

or, the converter can be written as an object,

```csharp
var converter =
    new ValueConverter<EquineBeast, string>(
        v => v.ToString(),
        v => (EquineBeast)Enum.Parse(typeof(EquineBeast), v));

modelBuilder.Entity<Rider>().Property(e => e.Mount).HasConversion(converter);
```

Note that null values would not trigger any conversion.

Built-in conversion classes in EF Core

- `BoolToZeroOneConverter` - boolean to 0/1
- `BoolToStringConverter` - boolean to Y/N
- `BoolToTwoValuesConverter`
- `BytesToStringConverter` - Base64 conversion
- `CastingConverter` - conversion to special types
- `CharToStringConverter`
- `DateTimeOffsetToBinaryConverter`
- `DateTimeOffsetToBytesConverter`
- `DateTimeOffsetToStringConverter`
- `DateTimeToBinaryConverter`
- `DateTimeToTicksConverter`
- `EnumToNumberConverter`
- `EnumToStringConverter`
- `GuidToBytesConverter`
- `GuidToStringConverter`
- `NumberToBytesConverter`
- `NumberToStringConverter`
- `StringToBytesConverter`
- `TimeSpanToStringConverter`
- `TimeSpanToTicksConverter`

For common conversion, using attributes may work. For example,

```csharp
public class Rider
{
    public int Id { get; set; }

    [Column(TypeName = "nvarchar(24)")]
    public EquineBeast Mount { get; set; }
}
```

#### Fluent API

```csharp
modelBuilder.Entity<TEntity>().Property(e => e.SomeEnumProperty).HasConversion<string>()
```

Note that adding conversion could affect LINQ translation and it may result in
process being executed in memory rather than within database server.

### Seeding

There are 3 ways to seed data:

1. model seed data
2. manual migration customisation
3. custom initialisation logic

#### Model Seed Data

```csharp
modelBuilder
    .Entity<Blog>()
    .HasData(new Blog {BlogId = 1, Url = "http://sample.com"});
```

Invoking `yourDataContext.Database.EnsureCreated()` will write outstanding seed
data to database. This can be used in non-relational database or testing
databases. This should **not** be invoked when migration is being used.

Note that primary key should be assigned; or the data would be duplicated or
removed, otherwise.

#### Manual migration customisation

In life-cycle method `OnModelCreating()`, use methods like `InsertData()`,
`UpdateData()` or `DeleteData()` to create seed data.

Note that `HasData()` in model seed data described above is using these calls to
manage data behind the scene. Thus, using these calls directly is to get around
the problem of values or keys cannot be determined at compile time.

#### Custom initialisation logic

```csharp
using (var context = new YourDataContext())
{
    context.Database.EnsureCreated();

    var testBlog = context.Blogs.FirstOrDefault(b => b.Url == "http://test.com");
    if (testBlog == null)
    {
        context.Blogs.Add(new Blog { Url = "http://test.com" });
    }
    context.SaveChanges();
}
```

### Entity type constructors

When a parameter name (camel-cased) of a constructor matches a property name
(Pascal-cased), EF will try to use that constructor to set the property and
will not use the setter of that property. For properties not covered by the
constructor, the normal assignments will be made after the application of the
constructor.

The usage of constructors should be limited as this increases the coupling.

Services available for injection via constructor

1. `DbContext`
2. `ILazyLoader`
3. `Action<object, string>` - used as a lazy-loading delegate
4. `IEntityType` - to retrieve metadata


### Relational database - table mapping

- `[Table("blogs", Schema = "blogging")]`
- `modelBuilder.Entity<Blog>().ToTable("blogs", schema: "blogging")`

### Relational database - data types

- `[Column(TypeName = "varchar(200)")]`
- `modelBuilder.Entity<Blog>().Property(b => b.PropName).HasColumnType("decimal(5,2)")`

### Relational database - data types

- `modelBuilder.Entity<Blog>().HasKey(b => b.KeyName).HasName("PK_KeyName")`

### Relational database - default schema

```csharp
class MyContext : DbContext
{
    public DbSet<Blog> Blogs { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("blogging");
    }
}
```

### Relational database - computed columns

```csharp
modelBuilder
    .Entity<Person>()
    .Property(p => p.DisplayName)
    .HasComputedColumnSql("[LastName] + ', ' + [FirstName]");
```

### Relational database - sequences

```csharp
class MyContext : DbContext
{
    public DbSet<Blog> Blogs { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasSequence<int>("OrderNumbers")
            .StartsAt(1000)
            .IncrementsBy(5);

        modelBuilder.Entity<Order>()
            .Property(o => o.OrderNo)
            .HasDefaultValueSql("NEXT VALUE FOR dbo.OrderNumbers")
    }
}
```

### Indexes

- by convention, EF Core will create an index for foreign keys.
- to add an index, `modelBuilder.Entity<TEntity>().HasIndex(b => b.YourPropertyName)`
- to add an unique index, `modelBuilder.Entity<TEntity>().HasIndex(b => b.YourPropertyName).IsUnique()`
- to add a complex index, `modelBuilder.Entity<TEntity>().HasIndex(b => new { b.YourPropertyName, b.YourPropertyName2 })`

Note that there is only one index per distinct set of properties. Indexes
defined by Fluent API will override other declarations or convention.

### Relational database - indexes

```csharp
modelBuilder.Entity<Blog>()
    .HasIndex(b => b.Url)
    .HasName("Index_Url");
```

```csharp
modelBuilder.Entity<Blog>()
    .HasIndex(b => b.Url)
    .HasFilter("[Url] IS NOT NULL");
```

```csharp
modelBuilder.Entity<Blog>()
    .HasIndex(b => b.Url)
    .IsUnique()
    .HasFilter(null);
```

### Keys

- by convention, any property named as `Id` will be become the primary key, or
- applying attribute `[Key]` to a property, or
- use `modelBuilder.Entity<TEntity>().HasKey(c => c.YourPropertyName)`

For complex key,

```csharp
modelBuilder.Entity<TEntity>().HasKey(c => new { c.YourPropertyName, c.YourPropertyName2 });
```

### Alternate key

An alternate key serves as an alternate unique identifier for each entity
instance in addition to the primary key. Alternate keys can be used as the
target of a relationship. When using a relational database this maps to the
concept of a unique index/constraint on the alternate key column(s) and one or
more foreign key constraints that reference the column(s).

Reference: [Alternate Keys](https://docs.microsoft.com/en-us/ef/core/modeling/alternate-keys)

```csharp
class MyContext : DbContext
{
    public DbSet<Blog> Blogs { get; set; }
    public DbSet<Post> Posts { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Post>()
            .HasOne(p => p.Blog)
            .WithMany(b => b.Posts)
            .HasForeignKey(p => p.BlogUrl)
            .HasPrincipalKey(b => b.Url);
    }
}

public class Blog
{
    public int BlogId { get; set; }
    public string Url { get; set; }

    public List<Post> Posts { get; set; }
}

public class Post
{
    public int PostId { get; set; }
    public string Title { get; set; }
    public string Content { get; set; }

    public string BlogUrl { get; set; }
    public Blog Blog { get; set; }
}
```

To customize the column name

```csharp
class MyContext : DbContext
{
    public DbSet<Car> Cars { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Car>()
            .HasAlternateKey(c => c.LicensePlate);
            .HasName("AlternateKey_LicensePlate")
    }
}

class Car
{
    public int CarId { get; set; }
    public string LicensePlate { get; set; }
    public string Make { get; set; }
    public string Model { get; set; }
}
```

Note that complex key (key involving multiple columns) is also supported.

### Relational database - foreign key

```csharp
modelBuilder.Entity<Post>()
    .HasOne(p => p.Blog)
    .WithMany(b => b.Posts)
    .HasForeignKey(p => p.BlogId)
    .HasConstraintName("ForeignKey_Post_Blog");
```

When properties of an entity cannot be mapped to data types of database
directly, EF Core will consider those properties as navigation properties.

If two entities have navigation referencing each other, it will be considered
as reverse navigation property.

EF Core will create foreign key according to the property names. For example,
if any of the following property names are used in entity `Post` (assumning
primary key of blog is `BlogId`)

1. `BlogId`
2. `PostBlogId`
3. `BlogBlogId`

If there is a navigation property not being declared as foreign key, EF Core
will add it as a shadow property. But it is best to declare it explicitly via
Fluent API. Note that if there are multiple navigation properties, EF Core will
not try to create the foreign key and explicit declaration is necessary.

Customised foreign key name can be used by applying `ForeignKeyAttribute`.
`InversePropertyAttribute` can be used to indicate inverse navigation property.

```csharp
public class Blog
{
   public int BlogId { get; set; }

   [ForeignKey("FK_Custom_Blog_Posts")]
   public ICollection<Post> Posts { get; set; }
}

public class Post
{
    public int PostId { get; set; }
    public string Title { get; set; }
    public string Content { get; set; }
    public int AuthorUserId { get; set; }
    public User Author { get; set; }
    public int ContributorUserId { get; set; }
    public User Contributor { get; set; }
}

public class User
{
    public string UserId { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }

    [InverseProperty("Author")]
    public List<Post> AuthoredPosts { get; set; }

    [InverseProperty("Contributor")]
    public List<Post> ContributedToPosts { get; set; }
}
```

### Cascade Delete

The delete behavior configured in the EF Core model is only applied when the
principal entity is deleted using EF Core and the dependent entities are loaded
in memory (that is, for tracked dependents). A corresponding cascade behavior
needs to be setup in the database to ensure data that is not being tracked by
the context has the necessary action applied. If you use EF Core to create the
database, this cascade behavior will be setup for you.

Note that, in EF Core, unlike EF6, cascading effects do not happen immediately,
but instead only when `SaveChanges` is called.

#### Optional relationships

Behaviour name | child in memory | child in database
--- | --- | ---
`Cascade` | deleted | deleted
`ClientSetNull` (default) | foreign key properties are set to null | none
`SetNull` | foreign key properties are set to null | foreign key properties are set to null
`Restrict` | none | none

#### Required relationships

Behaviour name | child in memory | child in database
--- | --- | ---
`Cascade` (default) | deleted | deleted
`ClientSetNull` | `SaveChanges` throws | none
`SetNull` | `SaveChanges` throws | `SaveChanges` throws
`Restrict` | none | none

### Transactions

By default, if the database provider supports transactions, all changes in a
single call to `SaveChanges()` are applied in a transaction. If any of the
changes fail, then the transaction is rolled back and none of the changes are
applied to the database. Tis means that `SaveChanges()` is guaranteed to either
completely succeed, or leave the database unmodified if an error occurs.

#### Syntax

```csharp
using (var context = new BloggingContext())
{
    using (var transaction = context.Database.BeginTransaction())
    {
        try
        {
            context.Blogs.Add(new Blog { Url = "http://blogs.msdn.com/dotnet" });
            context.SaveChanges();

            context.Blogs.Add(new Blog { Url = "http://blogs.msdn.com/visualstudio" });
            context.SaveChanges();

            var blogs = context.Blogs
                .OrderBy(b => b.Url)
                .ToList();

            // Commit transaction if all commands succeed, transaction will auto-rollback
            // when disposed if either commands fails
            transaction.Commit();
        }
        catch (Exception)
        {
            // TODO: Handle failure
        }
    }
}
```

An example on external transaction

```csharp
using (var connection = new SqlConnection(connectionString))
{
    connection.Open();

    using (var transaction = connection.BeginTransaction())
    {
        try
        {
            // Run raw ADO.NET command in the transaction
            var command = connection.CreateCommand();
            command.Transaction = transaction;
            command.CommandText = "DELETE FROM dbo.Blogs";
            command.ExecuteNonQuery();

            // Run an EF Core command in the transaction
            var options = new DbContextOptionsBuilder<BloggingContext>()
                .UseSqlServer(connection)
                .Options;

            using (var context = new BloggingContext(options))
            {
                context.Database.UseTransaction(transaction);
                context.Blogs.Add(new Blog { Url = "http://blogs.msdn.com/dotnet" });
                context.SaveChanges();
            }

            // Commit transaction if all commands succeed, transaction will auto-rollback
            // when disposed if either commands fails
            transaction.Commit();
        }
        catch (System.Exception)
        {
            // TODO: Handle failure
        }
    }
}
```

Note that EF Core relies on database providers to implement support for
`System.Transactions`. Although support is quite common among ADO.NET providers
for .NET Framework, the API has only been recently added to .NET Core and hence
support is not as widespread. If a provider does not implement support for
`System.Transactions`, it is possible that calls to these APIs will be
completely ignored.

Also note that, as of version 2.1, the `System.Transactions` implementation in
.NET Core does not include support for distributed transactions, therefore you
cannot use `TransactionScope` or `CommittableTransaction` to coordinate
transactions across multiple resource managers.

### Disconnected Entities

EF Core can only track one instance of any entity with a given primary key
value. The best way to avoid this being an issue is to use a short-lived
context for each unit-of-work such that the context starts empty, has entities
attached to it, saves those entities, and then the context is disposed and
discarded.

Keys are set as soon as entities are tracked by the context, even if the entity
is in the `Added` state. This helps when traversing a graph of entities and
deciding what to do with each, such as when using the TrackGraph API.

`Update` method normally marks the entity for update, not insert. However, if
the entity has a auto-generated key, and no key value has been set, then the
entity is instead automatically marked for insert.

#### To check an entity has a key set

```csharp
context.Entity(entity).IsKeySet
```

#### To update an entity

```csharp
var blogParameter;
var existingBlog = context.Blogs.Find(blogParameter.Id);
context.Entry(existingBlog).CurrentValues.SetValues(blogParameter);
context.SaveChanges();
```

`SetValues` will only mark as modified the properties that have different
values to those in the tracked entity. This means that when the update is sent,
only those columns that have actually changed will be updated. (And if nothing
has changed, then no update will be sent at all.)

### Relationships

#### One-to-many

```csharp
modelBuilder
    .Entity<Post>()
    .HasOne(p => p.Blog)
    .WithMany(b => b.Posts)
    .HasForeignKey(p => p.BlogId);
```

To setup the same relationship with one way navigation.

```csharp
modelBuilder
    .Entity<Blog>()
    .HasMany(b => b.Posts)
    .WithOne();
```

Foreign key does not have to be primary key of the principal entity. Alternate
key can be used as foreign key as well. (see example in [alternate
key](#alternate-key))

To indicate a required relationship (a child must have a parent),

```csharp
modelBuilder
    .Entity<Post>()
    .HasOne(p => p.Blog)
    .WithMany(b => b.Posts)
    .IsRequired();
```

#### One-to-one

```csharp
modelBuilder
    .Entity<Blog>()
    .HasOne(p => p.BlogImage)
    .WithOne(b => b.Blog);
```

### Loading

There are three types of loading.

1. Eager loading
2. Explicit loading
3. Lazy loading

#### Eager loading

Using `.Include()` (or `.ThenInclude()`) with a navigation property.

Note that, if the `.Select()` does not include fields from the included
navigation properties, the `.Include()` statement will be ignored. To enable
warning for this scenario, use

```csharp
optionsBuilder.ConfigureWarnings(w =>
    w.Throw(CoreEventId.IncludeIgnoredWarning));
```

Since version 3.0.0, each `Include` will cause an additional `JOIN` to be added
to SQL queries produced by relational providers, whereas previous versions
generated additional SQL queries. This can significantly change the performance
of your queries, for better or worse. In particular, LINQ queries with an
exceedingly high number of Include operators may need to be broken down into
multiple separate LINQ queries in order to avoid the Cartesian explosion
problem.

#### Explicit loading

```csharp
using (var context = new BloggingContext())
{
    var blog = context.Blogs.Single(b => b.BlogId == 1);
    context.Entry(blog)
        .Collection(b => b.Posts)
        .Load();
    context.Entry(blog)
        .Reference(b => b.Owner)
        .Load();
}
```

Loading with filters on is also supported.

```csharp
using (var context = new BloggingContext())
{
    var blog = context.Blogs.Single(b => b.BlogId == 1);
    var goodPosts = context.Entry(blog)
        .Collection(b => b.Posts)
        .Query()
        .Where(p => p.Rating > 3)
        .ToList();
}
```

#### Lazy loading

Nuget package `Microsoft.EntityFrameworkCore.Proxies` is required.

```csharp
protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    => optionsBuilder
        .UseLazyLoadingProxies()
        .UseSqlServer(myConnectionString);
```

and marking the navigation property as `virtual`

```csharp
public class Blog
{
    public int Id { get; set; }
    public string Name { get; set; }
    public virtual ICollection<Post> Posts { get; set; }
}

public class Post
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string Content { get; set; }
    public virtual Blog Blog { get; set; }
}
```

If proxies are not used in configuring a data context, constructor of a model
could be used.

```csharp
public class Blog
{
    private ICollection<Post> _posts;
    public Blog() {}
    private Blog(ILazyLoader lazyLoader)
    {
        LazyLoader = lazyLoader;
    }
    private ILazyLoader LazyLoader { get; set; }
    public int Id { get; set; }
    public string Name { get; set; }
    public ICollection<Post> Posts
    {
        get => LazyLoader.Load(this, ref _posts);
        set => _posts = value;
    }
}

public class Post
{
    private Blog _blog;
    public Post() {}
    private Post(ILazyLoader lazyLoader)
    {
        LazyLoader = lazyLoader;
    }
    private ILazyLoader LazyLoader { get; set; }
    public int Id { get; set; }
    public string Title { get; set; }
    public string Content { get; set; }
    public Blog Blog
    {
        get => LazyLoader.Load(this, ref _blog);
        set => _blog = value;
    }
}
```

Or, without `ILazyLoader`,

```csharp
public class Blog
{
    private ICollection<Post> _posts;

    public Blog() {}

    private Blog(Action<object, string> lazyLoader)
    {
        LazyLoader = lazyLoader;
    }

    private Action<object, string> LazyLoader { get; set; }

    public int Id { get; set; }

    public string Name { get; set; }

    public ICollection<Post> Posts
    {
        get => LazyLoader.Load(this, ref _posts);
        set => _posts = value;
    }
}

public class Post
{
    private Blog _blog;

    public Post() {}

    private Post(Action<object, string> lazyLoader)
    {
        LazyLoader = lazyLoader;
    }

    private Action<object, string> LazyLoader { get; set; }

    public int Id { get; set; }

    public string Title { get; set; }

    public string Content { get; set; }

    public Blog Blog
    {
        get => LazyLoader.Load(this, ref _blog);
        set => _blog = value;
    }
}

public static class PocoLoadingExtensions
{
    public static TRelated Load<TRelated>(this Action<object, string> loader,
        object entity,
        ref TRelated navigationField,
        [CallerMemberName] string navigationName = null)
        where TRelated : class
    {
        loader?.Invoke(entity, navigationName);
        return navigationField;
    }
}
```

### Cyclic navigation properties

For instance, `Blog` has a collection of `Post` and `Post` has a reference to
`Blog`. Exception could be thrown when `Json.NET` tries to serialize the
models. `Newtonsoft.Json.JsonSerializationException: Self referencing loop detected for property 'Blog' with type 'MyApplication.Models.Blog'`

To avoid the above exception,

```csharp
public void ConfigureServices(IServiceCollection services)
{
    //...

    services.AddMvc()
        .AddJsonOptions(
            options => options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
        );
    //...
}
```
Or adding `[JsonIgnore]` to one of the navigation properties.

## Migration

### Creation

Migration can be triggered by either using PowerShell or dotnet CLI.

```powershell
Add-Migration InitialCreate
```
or

```sh
dotnet ef migrations add InitialCreate
```

The abobve commands will create a snapshot of current models in
`MyContextModelSnapshot.cs` and `XXXXXXXXXXXXXX_InitialCreate.cs`

### Applying migration

```powershell
Update-Database
```

or

```sh
dotnet ef database update
```

or

```csharp
dataConext.Database.Migrate();
```

### Generating migration scripts

```powershell
Script-Migration
```

or

```sh
dotnet ef migrations script
```

Note that the support of migration is depending on the underlying provider. For
example, provider of SQLite cannot `AddPrimaryKey`, `AlterColumn` or
`DropColumn`.

## Logging

To dump parameter values into logs,
`DbContextOptionsBuilder.EnableSensitiveDataLogging()` can be used.

For example,

```csharp
options.UseSqlServer(Configuration.GetConnectionString("LocalDB"))
    .UseLoggerFactory(LoggerFactory.Create(builder =>
    {
        builder.AddConsole().AddDebug();
    }))
    .EnableSensitiveDataLogging();
```

## Pagination

Performance of `Skip` and `Take` is bad when the number of rows is large. For
example,

```cs
var blogs =
  dataContext.Blogs
    .Skip(20)
    .Take(10)
    .ToList();
```

The above could be better if it is written as

```cs
var lastUpdated = new DateTime(2022, 5, 6);
var lastId = 345;
var blogs =
  dataContext.Blogs
    .Where(b =>
      b.LastUpdated > lastUpdated ||
      (b.LastUpdated == lastUpdated && b.Id > lastId)
    .Take(10)
    .ToList();
```

Library
[mrahhal/MR.EntityFrameworkCore.KeysetPagination](https://github.com/mrahhal/MR.EntityFrameworkCore.KeysetPagination)
can be used to allow the above keyset pagination to be defined.

## Anti-patterns

- `.Where().First()`
- `.SingleOrDefault()` instead of `.FirstOrDefault()`
  - effectively `SELECT TOP 2` instead of `SELECT TOP 1`
- `.Count()` instead of `.All()` or `.Any()`
- `.Count()` instead of `.Count` or `.Length`
  - the alternatives can prevent `O(n)` operations
- `.Where().Where()`
- `.OrderBy().OrderBy()` instead of `.OrderBy().ThenBy()`
  - the logic of double `.OrderBy()` is simply incorrect
- `.Select(x => x)` instead of `AsEnumerable()`
  - If remote execution is not desired, for example because the predicate
    invokes a local method, the `AsEnumerable` method can be used to hide the
    custom methods and instead make the standard query operators available
- Inheritance of entities should be based on `abstract` class instead of
  concrete class to avoid un-necessary joins

## Upgrade from version 2.1

- Replace `DbQuery` with `DbSet` and configure it as `.HasNoKey()`
- Use `.FromSqlRaw` or `.FromSqlInterpolated` to enable filtering on joins
- `dotnet ef database update 0` to remove all migrations but keeping the
  database

# Entity Framework (Classic)

#### To log SQL queries executed

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

#### To log the duration of SQL queries

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

### Improving performance

See [Entity Framework Performance and What You Can Do About It](https://www.red-gate.com/simple-talk/dotnet/net-tools/entity-framework-performance-and-what-you-can-do-about-it/)

-   Avoid being too greedy with Rows
-   The ‘N+1 Select’ problem: Minimising the trips to the database
    -   Use of `.Include()`
-   Avoid being too greedy with columns
    -   use less network bandwidth
    -   a good indexing strategy involves considering what columns you frequently match against and what columns are returned when searching against them, along with judgements about disk space requirements and the additional performance penalty indexes incur on writing
-   Avoid mismatched data types
    -   for instance, database definition of `VARCHAR` in database where EF consider the value as `NVARCHAR` and this results a `CONVERT`. To solve this, either change database definition to `NVARCHAR` or applying attribute `[Column(TypeName =  "varchar")]`.
-   Add missing indexes
    -   `CREATE NONCLUSTERED INDEX [NonClusteredIndex_City] ON [dbo].[Pupils] ([City]) INCLUDE ([FirstName], [LastName]) ON [PRIMARY]` creates a non-clustered index for queries filtering against city and serves first and last names
-   Avoid overly-generic queries

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

-   Avoid bloating the plan cache
    -   in order for a plan to be reused, the statement text must be identical which is the case for parameterised queries
    -   but there is a case when this doesn’t happen – when we use `.Skip()` or `.Take()`
    -   use lambda function in `IQueryable.Skip()` and `IQueryable.Take()`
    -   enable a SQL Server setting called 'optimise for ad-hoc workloads' (see also [optimize for ad hoc workloads Server Configuration Option](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/optimize-for-ad-hoc-workloads-server-configuration-option)\)
    -   this makes SQL Server less aggressive at caching plans, and is generally a good thing to enable
    -   to find the one-off ad-hoc plans (see query below)
    -   To enable "optimise for ad-hoc workloads" (see stored procedure below)
    -   on AWS, change of the setting can be done in parameter groups. A new parameter group will be required if no prior custom parameter group is setup. After changing the value of the option in the parameter group, the group should be applied to the RDS instance.

```sql
SELECT objtype, cacheobjtype,
  AVG(usecounts) AS Avg_UseCount,
  SUM(refcounts) AS AllRefObjects,
  SUM(CAST(size_in_bytes AS bigint))/1024/1024 AS Size_MB
FROM sys.dm_exec_cached_plans
WHERE objtype = 'Adhoc' AND usecounts = 1
GROUP BY objtype, cacheobjtype;
```

```sql
EXEC sys.sp_configure N'optimize for ad hoc workloads', N'1'
RECONFIGURE WITH OVERRIDE
GO
```

-   Using bulk insert
    -   `EF.BulkInsert()`
    -   this will be supported out of the box in EF 7.0
-   Disable tracking in read-only queries

```csharp
string city =  "New York";
var schools =
  db.Schools
    .AsNoTracking()
    .Where(s => s.City == city)
    .Take(100)
    .ToList();
```

-   Allowing EF to make and receive multiple requests to SQL Server over a single connection, reducing the number of roundtrips
    -   `MultipleActiveResultSets=True;`

### Building SQL deployment package

To build SQL projects

```ps1
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

### Generate SQL scripts from deployment package

```ps1
SqlPackage.exe `
    /sf:Assets.Database.dacpac `
    /a:Script /op:create.sql /p:CommentOutSetVarDeclarations=true `
    /tsn:.\SQLEXPRESS /tdn:AssetsDB /tu:sa /tp:$sa_password
```

### Running SQL deployment scripts

```ps1
$SqlCmdVars = "DatabaseName=AssetsDB", "DefaultFilePrefix=AssetsDB", "DefaultDataPath=c:\database\", "DefaultLogPath=c:\database\"
Invoke-Sqlcmd -InputFile create.sql -Variable $SqlCmdVars -Verbose
```


