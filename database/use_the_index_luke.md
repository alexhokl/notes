- [0. Preface](#0-preface)
- [1. Anatomy of an Index](#1-anatomy-of-an-index)
- [2. The Where Clause](#2-the-where-clause)
  * [Primary Key](#primary-key)
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

## Primary Key

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
