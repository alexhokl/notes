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
  * [Delete](#delete)
  * [Update](#update)
- [9. Execution Plans](#9-execution-plans)
  * [MSSQL](#mssql)
  * [PostgreSQL](#postgresql)
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

- it is one of the most powerful tuning methods of all
  * it avoids accessing the table completely if the database can find the
    selected columns in the index itself
  * queries of aggregations are good candidates
  * it has a drawback that it is highly dependent on the `SELECT` clause
  * it is better to comment this intention in the code as it might not be
    obvious to other developers

Example

```sql
CREATE INDEX sales_sub_eur
    ON sales
     ( subsidiary_id, eur_value )
```

```sql
SELECT SUM(eur_value)
FROM sales
WHERE subsidiary_id = ?
```

- creating such index may not worth it when
  * if the other index has a good clustering factor; that is, if the respective
    rows are well clustered in a few table blocks; the advantage may be
    significantly lower
  * if the number of select rows is small, the saving of table access is small
- date column as the first column in index
  *  one of the advantages is having a better clustering factor
    +  if the data grows chronologically according to the date
- an index with good clustering factor
  * the selected tables rows are stored closely together so that the database
    only needs to read a few table blocks to get all the rows
    + the query might be fast enough without an index-only scan
- non-key columns in index
  * keyword `INCLUDE`
  * it has both MSSQL and PostgreSQL support
  * the columns are stored only in leaf nodes

```sql
CREATE INDEX empsubupnam
     ON employees
       (subsidiary_id, last_name)
INCLUDE(phone_number, first_name)
```

- limit of number of bytes of index entry
  * 1700 for non-clustered index, 900 for clustered index for MSSQL
  * 2713 for PostgreSQL

## Index-Organized Table

- clustered index
  * use an index as primary table store (no heap table)
  * every access is an index-only scan
  * tables with one index only are best implemented as clustered indexes
  * drawbacks
    + when a second index is needed for the table but there is no heap table to
      refer to
      + a logical key will be created to refer to the clustered index
      + the maintenance cost is high to maintain both indexes
      + two B-tree traversal make queries inefficient
      + tables with more indexes can often benefit from heap tables
- [Figure
  5.3](https://use-the-index-luke.com/sql/clustering/index-organized-clustered-index)
- MSSQL
  * by default, it uses clustered indexes using the primary key as clustering
    key
    + to create non clustered index
      + `CONSTRAINT pk PRIMARY KEY NONCLUSTERED (id)`
    + dropping a clustered index transforms the table into a heap table
    + this default behaviour often causes performance problems when using
      secondary indexes
- PostgreSQL
  * it only uses heap tables
  * keyword `CLUSTER` can be used to align the contents of the heap table with
    an index

# 6. Sorting and Grouping

- sorting is a very resource intensive operation
  * it needs a fair amount of CPU time
  * database must temporarily buffer the results
  * sort operations (without an index) cannot be executed in a pipelined manner
- full table scan is often faster than index scan in this scenario
- an index helps
  * saving the sorting effort
  * allowing execution in pipelined manner
- execution plan keywords
  * MSSQL
    + Sort
      + it needs large amounts of memory to materialize the intermediate result
        (not pipelined)
    + Sort (Top N Sort)
      + it is used for top-N queries if pipelined execution is not possible
    + Stream Aggregate
      + aggregates a presorted set according the `GROUP BY` clause
      + this operation does not buffer the intermediate result
      + it is executed in a pipelined manner
    + Hash Match (Aggregate)
      + this operation needs large amounts of memory to materialize the
        intermediate result (not pipelined)
    + Top
      + its efficiency of depends on the execution mode of the underlying
        operations
  * PostgreSQL
    + Sort
      + it needs large amounts of memory to materialize the intermediate result
        (not pipelined)
    + GroupAggregate
      + this operation does not buffer large amounts of data (pipelined)
    + HashAggregate
      + it uses a temporary hash table to group records
      + it does not require a presorted data set, instead it uses large amounts
        of memory to materialize the intermediate result (not pipelined)
      + the output is not ordered in any meaningful way
    + WindowAgg
      + indicates the use of window functions


## Indexed Order By

Example query

```sql
SELECT sale_date, product_id, quantity
FROM sales
WHERE sale_date = TRUNC(sysdate) - INTERVAL '1' DAY
ORDER BY sale_date, product_id
```

and the correponding index

```sql
CREATE INDEX sales_date ON sales (sale_date)
```

As the index does not include `product_id`, database needs to sort the result in
memory.

By including `product_id` in the index,

```sql
CREATE INDEX sales_dt_pr ON sales (sale_date, product_id)
```

the sorting operation is avoided.

For the following query

```sql
SELECT sale_date, product_id, quantity
FROM sales
WHERE sale_date >= TRUNC(sysdate) - INTERVAL '1' DAY
ORDER BY product_id
```

although the index `sales_dt_pr` is used, the sorting is still required.

- when debugging a slow query with `ORDER BY`, it can be started by adding an
  index with all the columns appeared in the `ORDER BY` clause and study its
  execution plan

## ASC/DESC and NULL FIRST/LAST

- database can read indexes in both directions
- in composite indexes, the order of index needs to be exactly the same or
  opposite to the `ORDER BY` clause
- `NULL FIRST` and `NULL LAST` is not supported in MSSQL but PostgreSQL
- `NULL` is considered as the smallest value in MSSQL but largest value in
  PostgreSQL

## Indexed Group By

- algorithms
  * hash algorithm
    + aggregates the input records in a temporary hash table; once all input
      records are processed, the hash table is returned as the result
  * sort/group algorithm
    + sorts the input data by the grouping key so that the rows of each group
      follow each other in immediate succession
    + the database just needs to aggregate them
    + some operations can be executed in a pipelined manner as the data is
      already sorted
- total cost shown in the execution plan may not be the sole factor to consider
  * as with `ORDER BY`, the ability to execute the operation in a pipelined
    manner could be more important

Example index and query

```sql
CREATE INDEX sales_dt_pr ON sales (sale_date, product_id)
```

```sql
SELECT product_id, sum(eur_value)
FROM sales
WHERE sale_date = TRUNC(sysdate) - INTERVAL '1' DAY
GROUP BY product_id
```

even the first column of the index is not `product_id`, the index can be used
and it allows the database to aggregate the data in a pipelined manner.

By changing the query to match a range of `sale_date` (instead of a single
date), the execution plan changes significantly.

```sql
SELECT product_id, sum(eur_value)
FROM sales
WHERE sale_date >= TRUNC(sysdate) - INTERVAL '1' DAY
GROUP BY product_id
```

although the index `sales_dt_pr` is used, it only helps filtering rows with
matching `sale_date` and, thus, sorting is still required in memory and it is
done using hash algorithm.

# 7. Partial Results

- top N rows (in MSSQL terms)
- query executed in pipelined manner is very important in performance

## Selecting Top-N Rows

- to select the best execution plan, the optimizer has to know if the
  application will ultimately fetch all rows
  * if there is no suitable index to be used, database will be forced to do
    a full table scan

`FETCH FIRST` example (supported by both MSSQL and PostgreSQL)

```sql
SELECT *
FROM sales
ORDER BY sale_date DESC
FETCH FIRST 10 ROWS ONLY
```

## Fetching The Next Page

- methods
  * offset
    + numbers the rows from the beginning and uses a filter on this row number
      to discard the rows before the requested page
    * the database must count all rows from the beginning until it reaches the
      requested page
    * the pages drift when inserting new sales because the numbering is always
      done from scratch
    * the response time increases when browsing further back
  * seek
    + searches the last entry of the previous page and fetches only the
      following rows

Offset example

MSSQL syntax

```sql
SELECT *
FROM sales
ORDER BY sale_date DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY
```

PostgreSQL syntax

```sql
SELECT *
FROM sales
ORDER BY sale_date DESC
OFFSET 10
FETCH NEXT 10 ROWS ONLY
```

Note that `ROWS` keyword is not allowed in `OFFSET` clause in PostgreSQL.

- seek method
  * it is important the ordering has to be deterministic
    + if it is not, add unique column to the `ORDER BY` clause

Seek example

```sql
SELECT *
FROM sales
WHERE sale_date < ?
ORDER BY sale_date DESC
FETCH FIRST 10 ROWS ONLY
```

assuming `sale_date` is unique.

## Window-Functions

- another way to implement pagination
- support
  - MSSQL
  - PostgreSQL 15 and later

Example query

```sql
SELECT *
FROM ( SELECT sales.*
            , ROW_NUMBER() OVER (ORDER BY sale_date DESC
                                        , sale_id   DESC) rn
          FROM sales
     ) tmp
 WHERE rn between 11 and 20
 ORDER BY sale_date DESC, sale_id DESC
```

PostgreSQL execution plan

```
 Subquery Scan on tmp
    (cost=0.42..141724.98 rows=334751 width=249)
    (actual time=0.040..0.052 rows=10 loops=1)
 Filter: (tmp.rn >= 11)
 Rows Removed by Filter: 10
 Buffers: shared hit=5
 -> WindowAgg
       (cost=0.42..129171.80 rows=1004254 width=249)
       (actual time=0.028..0.049 rows=20 loops=1)
    Run Condition: (row_number() OVER (?) <= 20)
    Buffers: shared hit=5
    -> Index Scan Backward using sl_dtid on sales
           (cost=0.42..111597.36 rows=1004254 width=241)
           (actual time=0.018..0.025 rows=22 loops=1)
       Buffers: shared hit=5
```

Note that `Run Condition` is on the first `20` rows.

- efficiency is roughly the same as offset method
- `ROW_NUMBER()` is supported by both MSSQL and PostgreSQL (15 and later)
  * but `PARTITION BY` is not supported by PostgreSQL
- `RANK()`, `DENSE_RANK()` and `COUNT()` are supported by PostgreSQL
- `OVER(ORDER BY ...)` is supported by both MSSQL and PostgreSQL (15 and later)
- `OVER(PARTITION BY ... ORDER BY ...)` is supported by both MSSQL and
  PostgreSQL (15 and later)
- the major use-case is not pagination but analytical caculations

# 8. Modifying Data

## Insert

- number of indexes on a table
  * the most dominant factor for insert performance
  * it cannot directly benefit from indexing because it has no where clause
- adding a new row to a table
  * find a place to store the row; for a regular heap table, which has no
    particular row order, the database can take any table block that has enough
    free space; this is a very simple and quick process, mostly executed in main
    memory; all the database has to do afterwards is to add the new entry to the
    respective data block
  * if there are indexes on the table, the database must make sure the new entry
    is also found via these indexes
    + adding an entry to an index is much more expensive than inserting one into
      a heap structure because the database has to keep the index order and tree
      balance
    + once the correct leaf node has been identified, the database confirms that
      there is enough free space left in this node; if not, the database splits
      the leaf node and distributes the entries between the old and a new node;
      this process also affects the reference in the corresponding branch
      (parent) node as that must be duplicated as well
    + the branch node can run out of space as well so it might have to be split
      too
    + in the worst case, the database has to split all nodes up to the root
      node; this is the only case in which the tree gains an additional layer
      and grows in depth
- the performance without indexes is so good that it can make sense to
  temporarily drop all indexes while loading large amounts of data—provided the
  indexes are not needed by any other SQL statements in the meantime; this can
  unleash a dramatic speed-up which is visible in the chart and is, in fact,
  a common practice in data warehouses

## Delete

- it works like a `SELECT` statement
  * with an additional step to delete the identified rows
- the actual deletion of a row is a similar process to inserting a new one,
  especially the removal of the references from the indexes and the activities
  to keep the index trees in balance
- optimizer produces execution plan for `DELETE` statement
- `TRUNCATE TABLE table_name` is equivalent to `DELETE FROM table_name`
  * but different in that
    + both MSSQL and PostgreSQL do not implicitly commit the statement
    + it does not execute any triggers

## Update

- it does not necessarily affect all indexes on the table but only those that
  contain updated columns
- to optimize update performance, avoid updating columns with indexes (it is
  more related to ORM tools); it is a good practice to occasionally enable query
  logging in a development environment to verify the generated SQL statements

# 9. Execution Plans

## MSSQL

- presentation of execution plans
  * graphical
  * tabular
- in graphical execution plan, predicate information is only visible when the
  mouse is hovered the particular operation

To generate a tabular execution plan,

```sql
SET STATISTICS PROFILE ON
```

Once enabled, each executed statement produces an extra result set.

Once the query executed, the plan should be in the `StmtText` column.

To stop generating a tabular execution plan,

```sql
SET STATISTICS PROFILE OFF
```

## PostgreSQL

```sql
PREPARE stmt(int) AS SELECT $1
EXPLAIN EXECUTE stmt(1)
```

Note that `PREPARE` is needed due to bind parameters.

To remove a prepared statement,

```sql
DEALLOCATE stmt
```

From version 16, `PREPARE` can be skipped by using `EXPLAIN GENERIC_PLAN`.

The following plan shows startup cost of `0.01` and total cost of `8.29`.

```
Index Scan using emp_up_name on employees
   (cost=0.01..8.29 rows=1 width=17)
   Index Cond: (upper((last_name)::text) ~>=~ 'WIN'::text)
           AND (upper((last_name)::text) ~<~  'WIO'::text)
       Filter: (upper((last_name)::text) ~~ 'WIN%D'::text)
```

`EXPLAIN` does not execute the query but `EXPLAIN ANALYZE` does.

To allow rollback of the statement of interest,

```sql
BEGIN
EXPLAIN (ANALYZE, BUFFERS, SETTINGS)
EXECUTE stmt(1)
ROLLBACK
```

and the corresponding plan is

```
                   QUERY PLAN
--------------------------------------------------
 Result  (cost=0.00..0.01 rows=1 width=4)
         (actual time=0.001..0.002 rows=1 loops=1)
 Settings: random_page_cost = '1.1'
 Planning Time: 0.032 ms
 Execution Time: 0.078 ms
```

Note that `actual time` is included.

PostgreSQL execution plans do not show index access and filter predicates
separately—both show up as “Index Cond”. That means the execution plan must be
compared to the index definition to differentiate access predicates from index
filter predicates.

“Filter” are always table level filter predicates, even when shown for an Index
Scan operation.
