### Powershell

##### Show examples of a command

```ps1
Get-Help -Example dir
```

##### Look for a command with certain wording

```ps1
Get-Command "-website*
```

##### Get members (or properties, in .NET terms) of a command

```ps1
Get-Member -Input-Object(Get-Date)
```

##### Accessing a NET property

```ps1
[DateTime]::UtcNow
```

##### Piping

```ps1
ls main -Recurse -Include bin | rmdir -Recurse -Force
```

##### To dump all file paths in specified directory

```ps1
Get-ChildItem -Path C:\ -Recurse -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName
```
