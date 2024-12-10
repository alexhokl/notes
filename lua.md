- [Syntax](#syntax)
  * [Strings](#strings)
  * [Functions](#functions)
  * [Tables](#tables)
  * [Loops](#loops)
  * [Modules](#modules)
  * [Function calling](#function-calling)
  * [Colon functions](#colon-functions)
  * [Metatables](#metatables)
____

# Syntax

## Strings

```lua
local a = "Hello"
local b = 'World'
local c = [[
    Hello
    World
]]
```

## Functions

```lua
local function add(a, b)
    return a + b
end

local multiply = function(a, b)
    return a * b
end
```

## Tables

```lua
local list = { "first", 2, false, function() print("Fourth!") end }
```

```lua
local map = {
  literal_key = "a string",
  ["an expression"] = "also works",
  [function() end] = true,
}

print(map.literal_key)
print(map["an expression"])
print(map[function() end])

--- Output:
--- a string
--- also works
---
```

## Loops

```lua
local names = { "Alice", "Bob", "Charlie" }

for i = 1, #names do
    print(i, names[i])
end

for i, name in ipairs(names) do
    print(i, name)
end
```

```lua
local map = {
    alice = 1,
    bob = "two",
    charlie = 3,
}

for key, value in pairs(map) do
    print(key, value)
end
```

## Modules

`foo.lua`

```lua
local M = {}
M.my_function = function() end
return M
```

```lua
-- assuming foo.lua is in the same directory
local foo = require("foo")
foo.my_function()
```

## Function calling

```lua
local setup = function(opts)
  if opts.default == nil then
    opts.default = 42
  end

  print(opts.default, opts.other)
end

setup { default = 100, other = 24 }
setup { other = 24 }


--- Output:
--- 100 24
--- 42 24
```

## Colon functions

```lua
local MyTable = {}

function MyTable.something(self, ...) end
function MyTable:something(...) end
```

## Metatables

```lua
local vector_mt = {}
vector_mt.__add = function(left, right)
    return setmetatable({
      left[1] + right[1],
      left[2] + right[2],
      left[3] + right[3],
    }, vector_mt)
end

local v1 = setmetatable({3,1,5}, vector_mt)
local v2 = setmetatable({-3,2,2}, vector_mt)
local v3 = v1 + v2
print(v3[1], v3[2], v3[3])
print(v3 + v3)
```

Function `__index` is used when the key supplied by user is not found in a table
to return a value

Function  `__newindex` is used when the key supplied by user is not found in
a table and the value is being set
