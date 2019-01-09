select ind.[name], t.[name] from sys.indexes ind
INNER JOIN sys.tables t ON ind.object_id = t.object_id
where fill_factor <> 100
order by ind.object_id desc