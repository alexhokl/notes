- [SQLite](#sqlite)
  * [Json](#json)
____

# SQLite

## Json

- it has both JSON and JSONB support

##### To filter data with string array stored as JSON array

```sql
SELECT e.* FROM Entries e, json_each(e.labels) ll
WHERE ll.atom = 'noun'
```

where `labels` is a JSON array column in `Entries` table and stored as `["noun",
"verb"]`.

