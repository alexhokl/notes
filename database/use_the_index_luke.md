- [0. Preface](#0-preface)
- [1. Anatomy of an Index](#1-anatomy-of-an-index)
- [2. The Where Clause](#2-the-where-clause)
  * [The Equals Operator](#the-equals-operator)
    + [Primary Key](#primary-key)
    + [Concatenated Index](#concatenated-index)
    + [Slow Indexes, Part II](#slow-indexes-part-ii)
  * [Functions](#functions)
    + [Case-Insensitive Search](#case-insensitive-search)
    + [User-Defined Functions](#user-defined-functions)
    + [Over-Indexing](#over-indexing)
  * [Bind Variables](#bind-variables)
  * [Searching for Ranges](#searching-for-ranges)
    + [Greater, Less and BETWEEN](#greater-less-and-between)
    + [Indexing SQL LIKE Filters](#indexing-sql-like-filters)
    + [Index Combine](#index-combine)
  * [Partial Indexes](#partial-indexes)
  * [Obfuscated Conditions](#obfuscated-conditions)
    + [Dates](#dates)
    + [Numeric Strings](#numeric-strings)
    + [Combining Columns](#combining-columns)
    + [Smart Logic](#smart-logic)
- [3. Performance and Scalability](#3-performance-and-scalability)
  * [Data Volume](#data-volume)
    + [Index column order](#index-column-order)
  * [System Load](#system-load)
  * [Response Time and Throughput](#response-time-and-throughput)
- [4. The Join Operation](#4-the-join-operation)
  * [Nested Loops](#nested-loops)
  * [Hash Join](#hash-join)
  * [Sort-Merge Join](#sort-merge-join)
- [5. Clustering Data](#5-clustering-data)
  * [Index Filter Predicates Intentionally Used](#index-filter-predicates-intentionally-used)
  * [Index-Only Scan](#index-only-scan)
  * [Index-Organized Table](#index-organized-table)
- [6. Sorting and Grouping](#6-sorting-and-grouping)
  * [Indexed Order By](#indexed-order-by)
  * [ASC/DESC and NULL FIRST/LAST](#ascdesc-and-null-firstlast)
  * [Indexed Group By](#indexed-group-by)
- [7. Partial Results](#7-partial-results)
  * [Selecting Top-N Rows](#selecting-top-n-rows)
  * [Fetching The Next Page](#fetching-the-next-page)
  * [Window-Functions](#window-functions)
- [8. Modifying Data](#8-modifying-data)
  * [Insert](#insert)
  * [Update](#update)
  * [Delete](#delete)
___

Reference: [Use The Index, Luke!](https://use-the-index-luke.com/)

# 0. Preface

- B-tree index works almost identically in all databases
  * Balanced search tree

# 1. Anatomy of an Index

- index is a pure redundancy
  * creating an index does not change the table data; it just creates a new data
    structure that refers to the table
  * all entries are arranged in a well-defined order
    + it is not possible to store the data sequentially because an insert
      statement would need to move the following entries to make room for the
      new one
    + moving large amounts of data is very time-consuming so the insert
      statement would be very slow
    + the solution to the problem is to establish a logical order that is
      independent of physical order in memory
  * a combination of
    + a doubly-linked list (to establish a logical order)
      + to connect leaf nodes
        + each leaf node is stored in a database page (8k for both PostgreSQL
          and MSSQL)
        + database use space in each page to store as many the index entries as
          possible
        + each index entry consists of the indexed columns and refers to the
          corresponding table row (via RID)
      + [Figure 1.1](https://use-the-index-luke.com/sql/anatomy/the-leaf-nodes)
    + B-tree
      + [Figure 1.2](https://use-the-index-luke.com/sql/anatomy/the-tree)
      + the root and branch nodes support quick searching among the leaf nodes
      + each branch node entry corresponds to the biggest value in the
        respective leaf node
      + the tree is balanced as tree depth is equal in every entry
      + database maintains the index automatically
        + it applies every insert, delete and update to the index and keeps the
          tree in balance, thus causing maintenance overhead for write
          operations
      + tree search works almost instantly even on a huge data set
        + as the tree balanced, it accesses all elements with the same number of steps
        + due to the logarithmic growth of the tree depth, tree depth grows very
          slowly compared to the number of leaf nodes
- rebuilding an index does not improve performance on the long run
  * tree traversal is the only step that has an upper bound of the index depth
  * what is much slower is the scanning of leaf node chain and fetching the
    corresponding table rows
- index lookup
  * key lookup (MSSQL, PostgreSQL does not have this concept)
    + it is known for a fact that key has one entry in the index
  * index seek (MSSQL, or index only scan or index scan in PostgreSQL)
    + it finds all leaf nodes that contain the key
      + index scan in PostgreSQL involves retrieving the corresponding table rows
  * index scan (MSSQL)
    + reads the entire index in the index order
  * index scan (PostgreSQL)
    + effectively index seek plus RID lookup in MSSQL
  + RID lookup (MSSQL)
    + retrieving the corresponding table rows (usually after index lookup)
    + index scan in PostgreSQL included this step
  + table scan (MSSQL, or Seq Scan in PostgreSQL)
    + reads the entire table; all rows and columns
  + bitmap index scan (PostgreSQL)
    + a bitmap scan fetches all the tuple-pointers from the index in one go,
      sorts them using an in-memory “bitmap” data structure, and then visits the
      table tuples in physical tuple-location order
- MSSQL
  * clustered index
    + tables that consist of index structure only

# 2. The Where Clause

## The Equals Operator

### Primary Key

```sql
SELECT first_name, last_name
FROM employees
WHERE employee_id = 123
```

where `employee_id` is the primary key.

Thus, the query is almost independent of the table size.

MSSQL execution plan

```
|--Nested Loops(Inner Join)
   |--Index Seek(OBJECT:employees_pk,
   |               SEEK:employees.employee_id=@1
   |            ORDERED FORWARD)
   |--RID Lookup(OBJECT:employees,
                   SEEK:Bmk1000=Bmk1000
                 LOOKUP ORDERED FORWARD)
```

PostgreSQL execution plan

```
Index Scan using employees_pk on employees
   (cost=0.00..8.27 rows=1 width=14)
   Index Cond: (employee_id = 123::numeric)
```

### Concatenated Index

- the order of columns matters
- in general, a database can use a concatenated index when searching with the
  leading (leftmost) columns
- even hough the two-index solution delivers very good select performance as
  well, the single-index solution is preferable. It not only saves storage
  space, but also the maintenance overhead for the second index. The fewer
  indexes a table has, the better the insert, delete and update performance
- to define an optimal index one also need to know how the application queries
  the data
  * that is, to know the column combinations that appear in the where clause

```sql
SELECT first_name, last_name
FROM employees
WHERE subsidiary_id = 20
```

if there is no index on `subsidiary_id`, the query will result in a full table
scan and the execution time grows with the table size

A concatenated index is just a B-tree index like any other that keeps the
indexed data in a sorted list. The database considers each column according to
its position in the index definition to sort the index entries. The first column
is the primary sort criterion and the second column determines the order only if
two entries have the same value in the first column and so on.

[Figure 2.1](https://use-the-index-luke.com/sql/where-clause/the-equals-operator/concatenated-keys)

Suppose the following index has been created

```sql
CREATE UNIQUE INDEX EMPLOYEES_PK
    ON EMPLOYEES (SUBSIDIARY_ID, EMPLOYEE_ID)
```

MSSQL execution plan

```
|--Nested Loops(Inner Join)
   |--Index Seek(OBJECT:employees_pk,
   |               SEEK:subsidiary_id=20
   |            ORDERED FORWARD)
   |--RID Lookup(OBJECT:employees,
                   SEEK:Bmk1000=Bmk1000
                 LOOKUP ORDERED FORWARD)
```

Note the use of "index seek".

PostgreSQL execution plan

```
 Bitmap Heap Scan on employees
 (cost=24.63..1529.17 rows=1080 width=13)
   Recheck Cond: (subsidiary_id = 2::numeric)
   -> Bitmap Index Scan on employees_pk
      (cost=0.00..24.36 rows=1080 width=0)
      Index Cond: (subsidiary_id = 2::numeric)
```

A "Bitmap Index Scan" followed by a "Bitmap Heap Scan". They roughly correspond
to "index seek" and "RID lookup" with one important difference: it first fetches
all results from the index (Bitmap Index Scan), then sorts the rows according to
the physical storage location of the rows in the heap table and than fetches all
rows from the table (Bitmap Heap Scan). This method reduces the number of random
access IOs on the table.

### Slow Indexes, Part II

- when comparing two execution plans, if one of the plans should be in-theory
  faster but it is not, one should check the statistics (number of rows) if it
  makes sense
  * for example, if one plan uses an index while the other does a full table
    scan on a large table, the actual execution time of full table scan is faster,
    one should check the statistics in the plan of using an index is making sense
    or not
- full table scan can sometimes be faster as it can read large parts from the
  table in one shot
  * where "index seek" and "RID lookup" is in per row basis
- cost-based optimizer
  * uses statistics about tables, columns, and indexes
  * most statistics are collected on the column level: the number of distinct
    values, the smallest and largest values (data range), the number of NULL
    occurrences and the column histogram (data distribution)
  * the most important statistical value for a table is its size (in rows and
    blocks)
  * the most important index statistics are the tree depth, the number of leaf
    nodes, the number of distinct keys and the clustering factor
- a small and mostly unique index enables fast query (or a smaller estimated
  cost)

## Functions

- MSSQL supports computed columns
- PostgreSQL supports indexes on expressions

### Case-Insensitive Search

- MSSQL case-insensitive by default
- PostgreSQL case-sensitive by default

```sql
SELECT first_name, last_name, phone_number
FROM employees
WHERE UPPER(last_name) = UPPER('winand')
```

PostgreSQL execution plan

```
 Seq Scan on employees
   (cost=0.00..1722.00 rows=50 width=17)
   Filter: (upper((last_name)::text) = 'WINAND'::text)
```

Note that search is not on `LAST_NAME` but on `UPPER(LAST_NAME)` and thus the
full table scan (Seq Scan).

By adding a function-based index,

```sql
CREATE INDEX emp_up_name
    ON employees (UPPER(last_name))
```

PostgreSQL execution plan

```
Bitmap Heap Scan on employees
  (cost=4.65..178.65 rows=50 width=17)
  Recheck Cond: (upper((last_name)::text) = 'WINAND'::text)
  -> Bitmap Index Scan on emp_up_name
     (cost=0.00..4.64 rows=50 width=0)
     Index Cond: (upper((last_name)::text) = 'WINAND'::text)
```

Note the combination of "Bitmap Index Scan" and "Bitmap Heap Scan" and it
results a much lower cost.

If the query above only returns one row, it is likely that the statistics used
in the above plan is not correct (as it estimates 50 rows).

After updating the statistics, the execution plan becomes

```
 Index Scan using emp_up_name on employees
   (cost=0.00..8.28 rows=1 width=17)
   Index Cond: (upper((last_name)::text) = 'WINAND'::text)
```

Not the number of rows is estimated to be 1, the significantly lower cost, the
use of "Index Scan" (corresponds to "index seek" in MSSQL).

Noe that updating statistics does not improve the actual performance in this
case the the index in the previous plan was used properly. However, it is always
good to check to understand if a bad plan is used due to bad statistics.

In MSSQL, the similar functionality can be achieved by

```sql
ALTER TABLE employees ADD last_name_up AS UPPER(last_name)
CREATE INDEX emp_up_name ON employees (last_name_up)
```

### User-Defined Functions

- to use function with index (PostgreSQL only, not MSSQL)
  * the function must be deterministic
    + it always return the same result for the same parameters
  * keyword `IMMUTABLE` should be used in PostgreSQL
    + note that PostgreSQL trust the declarations regardless

### Over-Indexing

- comparing to function-based index, it is better to always aim to index the
  original data as that is often the most useful information you can put into an
  index

## Bind Variables

- bind parameters
  * a placeholder like `?`, `:name` or `@name`
- advantages
  * security
    + the best way to prevent SQL injection
  * performance
    + MSSQL caches execution plans and it allows reusing plans
- disadvantages
  * the optimizer has no concrete values available to determine their frequency;
    it then just assumes an equal distribution and always gets the same row
    count estimates and cost values; in the end, it will always select the same
    execution plan
    + use bind parameter most of the time, but when a value can lead to very
      different statistics avoid it at SQL generation level (for example, in C#
      code)

## Searching for Ranges

### Greater, Less and BETWEEN

- index scan can be slow (relatively) when a lot of leaf node traversals are
  needed; thus, smaller scan range should help performance
  * it also implies the order of composite index is important

```sql
SELECT first_name, last_name, date_of_birth
  FROM employees
 WHERE date_of_birth >= TO_DATE(?, 'YYYY-MM-DD')
   AND date_of_birth <= TO_DATE(?, 'YYYY-MM-DD')
   AND subsidiary_id  = ?
```

- [Figure 2.2](https://use-the-index-luke.com/sql/where-clause/searching-for-ranges/greater-less-between-tuning-sql-access-filter-predicates)
  * index with `date_of_birth`, `subsidiary_id`
  * where the scanned index range is large
- [Figure 2.3](https://use-the-index-luke.com/sql/where-clause/searching-for-ranges/greater-less-between-tuning-sql-access-filter-predicates)
  * index with `subsidiary_id`, `date_of_birth`
  * where the scanned index range is small

- rule of thumb
  * index for equality first, then for ranges
  * selective first is not correct (as `date_of_birth` would be chosen first
    in the example above)

- index range is likely visible in execution plan

With index of `date_of_birth`, `subsidiary_id`,

MSSQL execution plan

```
|--Nested Loops(Inner Join)
   |--Index Seek(OBJECT:emp_test,
   |               SEEK:       (date_of_birth, subsidiary_id)
   |                        >= ('1971-01-01', 27)
   |                    AND    (date_of_birth, subsidiary_id)
   |                        <= ('1971-01-10', 27),
   |              WHERE:subsidiary_id=27
   |            ORDERED FORWARD)
   |--RID Lookup(OBJECT:employees,
                   SEEK:Bmk1000=Bmk1000
                 LOOKUP ORDERED FORWARD)
```

Note that, although both `subsidiary_id` and `date_of_birth` are included in the
same "index seek", `WHERE` is to be applied after `SEEK`. This implies filtering
of retrieved index is required (no data table involved yet).

PostgreSQL execution plan

```
Index Scan using emp_test on employees
  (cost=0.01..8.59 rows=1 width=16)
  Index Cond: (date_of_birth >= to_date('1971-01-01','YYYY-MM-DD'))
          AND (date_of_birth <= to_date('1971-01-10','YYYY-MM-DD'))
          AND (subsidiary_id = 27::numeric)
```

Note that, although it is not clear in the execution plan, the fact that
`subsidiary_id` comes after the date range indicates `subsidiary_id` filtering
is required after the initial index retrieval.

With index of `subsidiary_id`, `date_of_birth`,

MSSQL execution plan

```
|--Nested Loops(Inner Join)
   |--Index Seek(OBJECT:emp_test,
   |               SEEK: subsidiary_id=27
   |                 AND date_of_birth >= '1971-01-01'
   |                 AND date_of_birth <= '1971-01-10'
   |            ORDERED FORWARD)
   |--RID Lookup(OBJECT:employees),
                   SEEK:Bmk1000=Bmk1000
                 LOOKUP ORDERED FORWARD)
```

Note that there is no `WHERE` in "index seek".

PostgreSQL execution plan

```
Index Scan using emp_test on employees
   (cost=0.01..8.29 rows=1 width=17)
   Index Cond: (subsidiary_id = 27::numeric)
           AND (date_of_birth >= to_date('1971-01-01', 'YYYY-MM-DD'))
           AND (date_of_birth <= to_date('1971-01-10', 'YYYY-MM-DD'))
```

Note that, although it is not clear in the execution plan, the fact that
`subsidiary_id` applied before the date range indicates index of
`subsidiary_id`, `date_of_birth` applied properly.

### Indexing SQL LIKE Filters

Example query

```sql
SELECT first_name, last_name, date_of_birth
FROM employees
WHERE UPPER(last_name) LIKE 'WIN%D'
```

PostgreSQL execution plan

```
Index Scan using emp_up_name on employees
   (cost=0.01..8.29 rows=1 width=17)
   Index Cond: (upper((last_name)::text) ~>=~ 'WIN'::text)
           AND (upper((last_name)::text) ~<~  'WIO'::text)
       Filter: (upper((last_name)::text) ~~ 'WIN%D'::text)
```

Note that index is not applied on the whole `WHERE` clause but only between
`WIN` and `WIO`. Futher filtering of index for suffix `D` is required.

- index is applied for anything comes before wildcard `%`
- most databases just assume that there is no leading wild card when optimizing
  a LIKE condition with bind parameter, but this assumption is wrong if the LIKE
  expression is used for a full-text search
- for the PostgreSQL database, the problem is different because PostgreSQL
  assumes there is a leading wild card when using bind parameters for a LIKE
  expression; PostgreSQL just does not use an index in that case; the only way
  to get an index access for a LIKE expression is to make the actual search term
  visible to the optimizer
- full-text search
  * keyword `CONTAINS` for MSSQL
  * keyword `@@` for PostgreSQL

### Index Combine

- in general, one index with multiple columns is better
- an index can only support one range condition
  * the following shows there there is no way one index can satisfy both range
    conditions

```sql
SELECT first_name, last_name, date_of_birth
FROM employees
WHERE
  UPPER(last_name) < ?
  AND date_of_birth    < ?
```

- given two range conditions, it is important the correct index can be chosen

## Partial Indexes

- filtered indexes for MSSQL
- partial indexes for PostgreSQL
- partial index allows one to specify the row to be indexed
  * usually implemented with `WHERE` clause with constant values
  * it may not make queries significantly faster but it can save a lot of disk
    space
  * MSSQL
    + neither allow functions nor the OR operator in index predicates
  * PostgreSQL
    + only deterministic functions is allowed

```sql
CREATE INDEX messages_todo
          ON messages (receiver)
       WHERE processed = 'N'
```

## Obfuscated Conditions

- `WHERE` clauses that are phrased in a way that prevents proper index
  * an anti-pattern

### Dates

Example index

```sql
CREATE INDEX index_name
          ON sales (TRUNC(sale_date))
```

the following `WHERE` clauses does not use the index

```sql
WHERE sale_date = '2020-01-01'
WHERE DATE_FORMAT(sales_date, '%Y-%M')
```

only the following `WHERE` clause uses the index

```sql
WHERE TRUNC(sale_date) = '2020-01-01'
```

Another example

Assuming the following index

```sql
CREATE INDEX index_name
          ON sales (sale_date)
```

the following `WHERE` clause does not use the index

```sql
WHERE TO_CHAR(sale_date, 'YYYY-MM-DD') = '1970-01-01'
```

only the following `WHERE` clause uses the index

```sql
WHERE sale_date = TO_DATE('1970-01-01', 'YYYY-MM-DD')
```

### Numeric Strings

Example query

```sql
SELECT first_name
FROM Users
WHERE age_in_string = 42
```

Most of the database just add an implicit type conversion (except PostgreSQL
throws an error)

```sql
SELECT first_name
FROM Users
WHERE TO_NUMBER(age_in_string) = 42
```

It is better to re-write as

```sql
SELECT first_name
FROM Users
WHERE age_in_string = CAST(42 AS VARCHAR(10))
```

### Combining Columns

#### Date and Time

```sql
SELECT first_name
FROM Users
WHERE ADDTIME(created_date, created_time) > DATE_ADD(now(), INTERVAL -1 DAY)
```

Even index `(created_date, created_time)` is created, the query filter columns
separately but as an aggregated column.

This is probably one of the reasons not to separate date and time columns.

Re-writing the query as

```sql
SELECT first_name
FROM Users
WHERE
  ADDTIME(created_date, created_time) > DATE_ADD(now(), INTERVAL -1 DAY) AND
  created_date >= DATE(DATE_ADD(now(), INTERVAL -1 DAY))
```

helps using part of the index but not the whole index.

- if string is really needed for filtering dates, it might be better to format
  the column in ISO 8601 format (YYYY-MM-DD)

#### Avoiding wildcards

With the following query, there is good chance wildcard can be at the first
character.

```sql
SELECT last_name, first_name, employee_id
  FROM employees
 WHERE subsidiary_id = ?
   AND last_name LIKE ?
```

It can be re-written as

```sql
SELECT last_name, first_name, employee_id
  FROM employees
 WHERE subsidiary_id = ?
   AND last_name || '' LIKE ?
```

to avoid the optimizier to select an index on `last_name` but `subsidiary_id`
instead.

### Smart Logic

- MSSQL uses a shared execution plan cache

Example query

```sql
SELECT first_name, last_name, subsidiary_id, employee_id
  FROM employees
 WHERE ( subsidiary_id    = :sub_id OR :sub_id IS NULL )
   AND ( employee_id      = :emp_id OR :emp_id IS NULL )
   AND ( UPPER(last_name) = :name   OR :name   IS NULL )
```

The above query is one of the worst performance anti-patterns of all.

The database cannot optimize the execution plan for a particular filter because
any of them could be canceled out at runtime. The database needs to prepare for
the worst case, if all filters are disabled. Thus, this leads to an execution
plan with a full table scan (regardless any or all the columns has an index
covered).

Although this problem can be "solved" by not using bind parameters but it is
prone to SQL injection. A better solution is to use dynamic SQL which generated
by backend such as C# (and bind parameter can be used in the query).

- MSSQL
  * parameter sniffing enables the optimizer to use the actual bind values of
    the first execution during parsing; the problem with this approach is its
    nondeterministic behavior: the values from the first execution affect all
    executions
  * query hint `RECOMPILE` bypasses the plan cache for a selected statement
  * `OPTIMIZE FOR` allows the specification of actual parameter values that are
    used for optimization only
  * hint `USE PLAN`  can be used to provide an entire execution plan
- PostgreSQL
  * plan only cached as long as `PreparedStatement` is kept open

# 3. Performance and Scalability

## Data Volume

When a query slows down as the total data volume grows, execution plan can be
check if there is any predicates depends on the data volume.

MSSQL execution plans

```
|--Compute Scalar
   |--Stream Aggregate(Count(*))
      |--Index Seek(OBJECT:scale_slow),
         SEEK:(scale_data.section=2),
         WHERE:(scale_data.id2=1234) ORDERED FORWARD)

|--Compute Scalar
   |--Stream Aggregate(Count(*))
      |--Index Seek(OBJECT:(scale_data.scale_fast),
         SEEK:(scale_data.section=1)
          AND  scale_data.id2=1234) ORDERED FORWARD)
```

Note that there is a `WHERE` predicate in the first plan and the filtering time
will grow with the data volume. Note that PostgreSQL does not diffirentiate the
predicates like in MSSQL and guesswork is needed by checking the ordering of the
predicates.

### Index column order

Example index

```sql
CREATE INDEX scale_slow ON scale_data (section, id1, id2)
```

if there is a query with `WHERE` clause

```sql
WHERE section = 2 AND id2 = 1234
```

the index cannot be used at all.

## System Load

- an execution plan using an index alone may not be good enough
  * data volume aside, concurrent queries and system load are additional factors
    affecting scalability
  * a plan without further `WHERE` clause in "index seek" is important (or just
    `SEEK` and `AND`)
- a careful execution plan inspection yields more confidence in superficial
  benchmarks

## Response Time and Throughput

- bigger hardware is not always faster but it can usually handle more load
  * that is the reason that more hardware does not automatically improve slow
    SQL queries
  * even though it allows multiple tasks to run concurrently, it does not
    improve performance if there is only one task
  * although more servers can process more requests, they do not improve the
    response time for one particular query

# 4. The Join Operation

- joining is particularly sensitive to disk seek latencies because it combines
  scattered data fragments
- the correct index however depends on which of the three common join algorithms
  is used for the query
- databases use pipelining to reduce memory usage; that means that each row from
  the intermediate result is immediately pipelined to the next join operation,
  avoiding the need to store the intermediate result set
- the optimizer will evaluate all possible join order permutations and select
  the best one
  * that means that just optimizing a complex statement might become
    a performance problem
  * the more tables to join, the more execution plan variants to evaluate

## Nested Loops

- the most fundamental join algorithm
- the driving query to fetch the results from one table and a second query for
  each row from the driving query to fetch the corresponding data from the other
  table
- delivers good performance if the driving query returns a small result set
- adding index to join columns helps performance

## Hash Join

- address weaknesses of nested loops join
  * many B-tree traversals when executing the inner query
- it loads candidate records from one side of the join into a hash table
- tuning a hash join requires an entirely different indexing approach than the
  nested loops join
  * there is no need to index the join columns
  * only indexes for independent `WHERE` predicates improve hash join
    performance
    + independent means it refers to one table and does not belong to the join
      predicates
- it is also possible to improve hash join performance by selecting fewer
  columns
- hash table uses join predicates as key
- hash table works best if the entire hash table fits into memory
  * the optimizer will use the smaller side of the join for the hash table
  * independent `WHERE` clauses can reduce the size of hash table (even if the
    column in the `WHERE` clause is not indexed)
  * the size of the hash table is also affected by the number of columns in the
    hash table
    + that is, number of columns in `SELECT` clause
- it cannot perform joins that have range conditions in the join predicates

Example query

```sql
SELECT *
  FROM sales s
  JOIN employees e ON (s.subsidiary_id = e.subsidiary_id
                  AND  s.employee_id   = e.employee_id  )
 WHERE s.sale_date > trunc(sysdate) - INTERVAL '6' MONTH
```

- the join starts with a full table scan on `employees` and loads all data into
  a hash table
- the join then performs an index seek on `sales` and corresponding RID lookup
  to load data and check if it satisfies the join condition
- the remaining rows of `sales` are then loaded into the hash table

## Sort-Merge Join

- it combines two sorted lists like a zipper
  * both sides of the join must be sorted by the join predicates
- [Figure 4.1](https://use-the-index-luke.com/sql/join/sort-merge-join)
- tuning a sort-merge join requires an entirely different indexing approach than
  the nested loops join
  * there is no need to index the join columns
  * only indexes for independent `WHERE` predicates improve hash join
    performance
    + independent means it refers to one table and does not belong to the join
      predicates
- although the sort-merge join performs very well once the inputs are sorted, it
  is hardly used because sorting both sides is very expensive; hash join, on the
  other hand, needs to preprocess only one side
  * although by exploiting the index order, there is a chance to avoid the sort
    operations entirely, the hash join algorithm is superior in many cases

# 5. Clustering Data

- clustering data means to store consecutively accessed data closely together so
  that accessing it requires fewer IO operations

## Index Filter Predicates Intentionally Used

Example query

```sql
SELECT first_name, last_name, subsidiary_id, phone_number
  FROM employees
 WHERE subsidiary_id = ?
   AND UPPER(last_name) LIKE '%INA%'
```

- the execution plans for index of `subsidiary_id` and for index of
  (`subsidiary_id`, `UPPER(last_name)`) would look very similar as clause
  `UPPER(last_name)` requires scanning all the rows with the `subsidiary_id`.
  * however, the cost of plan with index of (`subsidiary_id`, `UPPER(last_name)`)
    would be much lower as the filtering is done on the index itself

## Index-Only Scan

## Index-Organized Table

# 6. Sorting and Grouping

## Indexed Order By

## ASC/DESC and NULL FIRST/LAST

## Indexed Group By

# 7. Partial Results

## Selecting Top-N Rows

## Fetching The Next Page

## Window-Functions

# 8. Modifying Data

## Insert

## Update

## Delete

