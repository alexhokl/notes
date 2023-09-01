  * [Links](#links)
  * [Basics](#basics)
  * [Navigation](#navigation)
  * [Editing](#editing)
  * [Search and replace](#search-and-replace)
  * [Indentation](#indentation)
  * [Uppercases/Lowercases](#uppercaseslowercases)
  * [Undo/Redo](#undoredo)
  * [Surround](#surround)
  * [Commenting](#commenting)
  * [Multicursors](#multicursors)
  * [Buffers](#buffers)
  * [Macro and registers](#macro-and-registers)
  * [LSP](#lsp)
  * [Treesitter](#treesitter)
  * [C#](#c%23)
  * [Go](#go)
  * [Markdown](#markdown)
  * [SQL](#sql)
  * [Git](#git)
  * [Scripting](#scripting)
  * [Folding](#folding)
  * [File search](#file-search)
  * [File explorer (nvim-tree.lua)](#file-explorer-nvim-treelua)
  * [Terminal](#terminal)
  * [Quickfix list](#quickfix-list)
  * [Location list](#location-list)
  * [Errors](#errors)
  * [Twilight](#twilight)
  * [Debugging](#debugging)
  * [Snippets](#snippets)
  * [vimrc](#vimrc)
  * [Help pages](#help-pages)
  * [Starting vim](#starting-vim)
- [Scripting](#scripting-1)
  * [References](#references)
____

The following notes is based on my
[vimrc](https://github.com/alexhokl/.vim/blob/master/vimrc) and [these
configuration
files](https://github.com/alexhokl/vim-alexhokl/tree/master/plugin)

### Links

- [rockerBOO/awesome-neovim](https://github.com/rockerBOO/awesome-neovim) - a
  collections of awesome Neovim plugins

### Basics

- <kbd>esc</kbd> to normal mode
- `:wq` to save and exit
- `:xa` to save all files and exit
- <kbd>ctrl</kbd><kbd>p</kbd> to invoke fuzzy file search (in normal mode)
- <kbd>V</kbd> to select a line visually
- <kbd>,</kbd><kbd>m</kbd> to search for a configured mapping

### Navigation

- <kbd>g</kbd><kbd>g</kbd> to go to the first line of a file
- <kbd>G</kbd> to go to the last line of a file
- <kbd>0</kbd> to jump to the beginning of the current line
- <kbd>^</kbd> to jump to the first character of the current line
- <kbd>\$</kbd> to jump to the end of the current line
- <kbd>w</kbd> to jump to the beginning of the next word
- <kbd>b</kbd> to jump to the beginning of the previous word
- <kbd>e</kbd> to jump to the end of the current word
- <kbd>}</kbd> to move cursor to the next empty line
- <kbd>{</kbd> to move cursor to the empty line above
- <kbd>ctrl</kbd><kbd>e</kbd> to scroll down
- <kbd>ctrl</kbd><kbd>y</kbd> to scroll up
- <kbd>ctrl</kbd><kbd>f</kbd> to scroll down one page
- <kbd>ctrl</kbd><kbd>b</kbd> to scroll up one page
- <kbd>z</kbd><kbd>t</kbd> to move cursor to the top of window
- <kbd>z</kbd><kbd>z</kbd> to move cursor to the middle of window
- <kbd>z</kbd><kbd>b</kbd> to move cursor to the bottom of window
- <kbd>\`</kbd><kbd>\`</kbd> to move cursor to previous position
- <kbd>\`</kbd><kbd>.</kbd> to move cursor to previous edited position
- <kbd>ctrl</kbd><kbd>o</kbd> to jump back the to the previous position (in the
  jump list)
- <kbd>ctrl</kbd><kbd>i</kbd> to jump forward to the next position (after a jump
  back)(in the jump list)
- <kbd>,</kbd><kbd>j</kbd> to show the current jump list
- <kbd>g</kbd><kbd>i</kbd> to move cursor to previous insert position
- <kbd>g</kbd><kbd>;</kbd> to move the previous position in the change list
- <kbd>g</kbd><kbd>,</kbd> to move the next position in the change list
- <kbd>g</kbd><kbd>v</kbd> to select the previous visual selection
- <kbd>m</kbd><kbd>a</kbd> to mark the current cursor position to register `a`
- <kbd>m</kbd><kbd>A</kbd> to mark the current cursor position to register `A`
  and it can be used in a different buffer
- <kbd>'</kbd><kbd>a</kbd> to jump to location stored in register `a`
- <kbd>[</kbd><kbd>s</kbd> to jump to the previous spelling error
- <kbd>]</kbd><kbd>s</kbd> to jump to the next spelling error
- <kbd>z</kbd><kbd>=</kbd> on a spelling error to show a list of spelling
  suggestions
- <kbd>z</kbd><kbd>g</kbd> to add the current spelling to dictionary
- <kbd>6</kbd><kbd>+</kbd> to jump 6 lines below and to the head of the line
- <kbd>4</kbd><kbd>-</kbd> to jump 4 lines above and to the head of the line
- <kbd>5</kbd><kbd>\$</kbd> to jump 4 (not 5) lines below and to the end of the
  line
- <kbd>8</kbd><kbd>0</kbd><kbd>\|</kbd> to jump to character 80 in the current
  line
- <kbd>%</kbd> to jump between any closures (such as `()` or `{}`)
- <kbd>[</kbd><kbd>{</kbd> to jump to the opening of the current curly brackets
- <kbd>]</kbd><kbd>}</kbd> to jump to the closing of the current curly brackets
- <kbd>g</kbd><kbd>x</kbd> in a (proper) link to open a browser
- <kbd>g</kbd><kbd>f</kbd> in a file page to open the file in a buffer
- `:echo expand('%:p')` to show current path

### Editing

- <kbd>a</kbd> to append
- <kbd>i</kbd> to insert
- <kbd>A</kbd> to append to the end of the current line
- <kbd>I</kbd> to insert to the beginning of the current line
- <kbd>d</kbd> to delete
- `d/searchWord` to delete until the first occurrence of `searchWord`
- <kbd>d</kbd><kbd>i</kbd><kbd>t</kbd> to delete contents in a tag
- <kbd>c</kbd><kbd>2</kbd><kbd>w</kbd> to change 2 words
- <kbd>o</kbd> to open a new line in the next line and insert
- <kbd>O</kbd> to open a new line in the previous line and insert
- <kbd>S</kbd> to start insert in a blank line with correct indentation
- <kbd>[</kbd><kbd>space</kbd> to insert a line above
- <kbd>]</kbd><kbd>space</kbd> to insert a line below
- <kbd>[</kbd><kbd>e</kbd> to move the current line up
- <kbd>]</kbd><kbd>e</kbd> to move the current line down
- <kbd>K</kbd> to move the current visually selected block up by one line
- <kbd>J</kbd> to move the current visually selected block down by one line
- <kbd>,</kbd><kbd>a</kbd> to swap the current function/method arguments with
  the next
- <kbd>,</kbd><kbd>A</kbd> to swap the current function/method arguments with
  the previous
- <kbd>y</kbd><kbd>y</kbd> to copy the current line
- <kbd>c</kbd><kbd>2</kbd><kbd>i</kbd><kbd>(</kbd> to change all words in the
  outer brackets. `a(b(c))` &rarr; `a()`
- <kbd>J</kbd> to append a space and move and append content of the next line to
  the current line

### Search and replace

- <kbd>/</kbd> to search forward
- `/sign/;/searchWord` to search `searchWord` comes after `sign`
- `2/searchWord` to search for the second appearance of `searchWord`
- `/searchWord/+1` to jump to the line after `searchWord`
- `/searchWord/-1` to jump to the line before `searchWord`
- <kbd>?</kbd> to search backward
- <kbd>*</kbd> to search the current word forward
- <kbd>#</kbd> to search the current word backward
- <kbd>q</kbd><kbd>/</kbd> to show search history
- <kbd>,</kbd><kbd>space</kbd> to remove highlights from search
- `:%s/SearchWord/Replacement/g` to replace all `SearchWord` with `Replacement`
  in the current file
- `:%s/SearchWord|Something/Replacement/g` to replace all `SearchWord` or
  `Something` with `Replacement` in the current file
- <kbd>&</kbd> to repeat the last replacement without flags (like `/g`)
- <kbd>:</kbd><kbd>&</kbd><kbd>&</kbd> to repeat the last replacement with flags
- <kbd>g</kbd><kbd>&</kbd> to repeat the last replacement with flags to the
  current buffer
- `:1,5s/\v(\d+)$/\=submatch(1)+3` to add 3 to the second number in each line
  from line 1 to line 5
- `:%s/SearchWord/&Append/g` to append `Append` to `SearchWord` in the current
  file
- `:g/ASearchWord/d` to delete all lines containing `ASearchWord` (regex can be
  used here)
- `:g!/ASearchWord/d` to delete all lines without containing `ASearchWord`
  (regex can be used here)
- `:g/ASearchWord/y A` to yank all lines containing `ASearchWord` to register A
  (<kbd>ctrl</kbd><kbd>r</kbd><kbd>A</kbd> to paste the content of register A)
- `:g/ASearchWord/m$` to move all lines containing `ASearchWord` to the end of
  the current file
- `:g/ASearchWord/norm @q` to apply macro stored in register `q` to all lines
  containing `ASearchWord`
- `:g/^\s*$/d` to delete all empty lines
- <kbd>ctrl</kbd><kbd>t</kbd> to search in the current repository
- <kbd>,</kbd><kbd>F</kbd> to search for the current word in the current
  repository
- <kbd>,</kbd><kbd>f</kbd><kbd>s</kbd> to search for symbols in the current
  buffer
- <kbd>,</kbd><kbd>t</kbd><kbd>o</kbd><kbd>d</kbd><kbd>o</kbd> to search for
  `TODO`, `FIX`, `HACK`, `WARN`, `PERF` and `NOTE`

### Indentation

- <kbd>></kbd> to add indentation in visual mode
- <kbd><</kbd> to remove indentation in visual mode
- <kbd>></kbd><kbd>></kbd> to add indentation to the current line
- <kbd>></kbd><kbd><</kbd> to remove indentation to the current line
- <kbd>4</kbd><kbd>></kbd><kbd>></kbd> to add indentation to the current line
  and the 3 lines below
- <kbd>=</kbd> to fix indentation of the current line
- <kbd>g</kbd><kbd>g</kbd><kbd>=</kbd><kbd>G</kbd> to fix indentation of the
  current file
- `:retab` to replace all tabs with spaces
- visually select lines and <kbd>g</kbd><kbd>q</kbd> to format those lines
- visually select table and <kbd>,</kbd><kbd>t</kbd> to align `|` in the
  table

### Uppercases/Lowercases

- <kbd>~</kbd> to toggle between upper case and lower case of the current
  character
- <kbd>g</kbd><kbd>U</kbd><kbd>2</kbd><kbd>w</kbd> to change the current word
  and the next to upper case
- <kbd>g</kbd><kbd>u</kbd><kbd>a</kbd><kbd>w</kbd> to change the current word
  to lower case

### Undo/Redo

- <kbd>u</kbd> to undo
- <kbd>ctrl</kbd><kbd>r</kbd> to redo

### Surround

- <kbd>s</kbd><kbd>a</kbd><kbd>2</kbd><kbd>w</kbd><kbd>"</kbd> to surround two
  words with `"`
- <kbd>s</kbd><kbd>a</kbd><kbd>{</kbd> to surround a visually select block with
  `{}`
- <kbd>s</kbd><kbd>d</kbd><kbd>"</kbd> to delete the surrounding `"`
- <kbd>s</kbd><kbd>r</kbd><kbd>"</kbd><kbd>'</kbd> to replace the surrounding
  `"` with `'`
- <kbd>s</kbd><kbd>a</kbd><kbd>2</kbd><kbd>w</kbd><kbd>f</kbd> to surround two
  words with a function name and `()`
- <kbd>s</kbd><kbd>a</kbd><kbd>2</kbd><kbd>w</kbd><kbd>i</kbd> to surround two
  words with two texts (prefix and suffix could be different)
- <kbd>s</kbd><kbd>a</kbd><kbd>2</kbd><kbd>w</kbd><kbd>t</kbd> to surround two
  words with a tag

### Commenting

- <kbd>g</kbd><kbd>c</kbd><kbd>c</kbd> to toggle comment
- visual selection + <kbd>g</kbd><kbd>c</kbd> to toggle comment of multiple
  lines

### Multicursors

- <kbd>ctrl</kbd><kbd>d</kbd> to select the current pattern or advance to the
  next instance of the current pattern
- <kbd>q</kbd> to skip to the next instance of the current
  pattern
- <kbd>Q</kbd> to remove multi-cursors
- <kbd>alt</kbd><kbd>down</kbd> to move cursor down
- <kbd>alt</kbd><kbd>up</kbd> to move cursor up

### Buffers

- <kbd>,</kbd><kbd>b</kbd> to select buffers
- <kbd>ctrl</kbd><kbd>x</kbd> or <kbd>ctrl</kbd><kbd>z</kbd> to switch between
  file buffers in a direction
- <kbd>ctrl</kbd><kbd>^</kbd> to jump to the previous buffer
- <kbd>ctrl</kbd><kbd>w</kbd> to jump to the next buffer
- <kbd>ctrl</kbd><kbd>w</kbd><kbd>ctrl</kbd><kbd>^</kbd> to open previous
  buffer in a split
- <kbd>ctrl</kbd><kbd>h</kbd> to jump to the split on the left
- <kbd>ctrl</kbd><kbd>j</kbd> to jump to the split below
- <kbd>ctrl</kbd><kbd>k</kbd> to jump to the split above
- <kbd>ctrl</kbd><kbd>l</kbd> to jump to the split on the right
- <kbd>ctrl</kbd><kbd>w</kbd><kbd>R</kbd> to swap buffer
- `:vs` to split buffer vertically (the common way of splitting)
- `:vs index.html` to split buffer vertically and open `index.html`
- `:20vs index.html` to split buffer vertically with 20 characters wide and open
  `index.html`
- `:sp` to split buffer horizontally
- `:e test.txt` to open file `test.txt` in the same buffer
- `:e +100 test.txt` to open file `test.txt` in the same buffer and advance to
  line 100
- `:e %:s?I?Base?` to edit a file with the current filename but with `I`
  replaced by `Base`
- <kbd>,</kbd><kbd>q</kbd> to close a buffer
- <kbd>,</kbd><kbd>w</kbd> to write current buffer to disk
- `:only` to close all other splits except the current one
- `:ls` to list all buffers
- `:b 2` to change to second buffer
- `:b doc`<kbd>tab</kbd> to change to a buffer with file prefixed with `doc`
- <kbd>,</kbd><kbd>↑</kbd> to increase vertical size of the current buffer
- <kbd>,</kbd><kbd>↓</kbd> to decrease vertical size of the current buffer
- <kbd>,</kbd><kbd>←</kbd> to decrease horizontal size of the current buffer
- <kbd>,</kbd><kbd>→</kbd> to increase horizontal size of the current buffer
- `:mksession layout.vim` to save the current layout to `layout.vim` (to open
  the layout again, use `vim -s layout.vim`)

### Macro and registers

- <kbd>q</kbd><kbd>1</kbd> to start recording at register `1`
- <kbd>q</kbd> in normal mode to stop recording
- <kbd>@</kbd><kbd>1</kbd> to replay the recording at register `1`
- <kbd>5</kbd><kbd>@</kbd><kbd>1</kbd> to replay the recording at register `1`
  5 times
- `:reg` to list the current registers
- By default, yank use register `0`, `"` and `-`; change and delete use register
  `"` and `-`; system clipboard use register `*`
- yank and replace can be done by yanking first, delete the words to be
  replaced, and `"0p`. It works because register `0` always stores the last
  yanked content.
- <kbd>V</kbd><kbd>"</kbd><kbd>a</kbd><kbd>y</kbd> yanks the current line to
  register `a` (and the default register `"`)
- <kbd>"</kbd><kbd>a</kbd><kbd>p</kbd> paste from register `a`

### LSP

- <kbd>g</kbd><kbd>r</kbd> to find usages
- <kbd>g</kbd><kbd>i</kbd> to find implementations
- <kbd>K</kbd> show documentation
- <kbd>g</kbd><kbd>d</kbd> go to definition
- <kbd>g</kbd><kbd>D</kbd> go to declaration
- <kbd>,</kbd><kbd>D</kbd> show type definition
- <kbd>,</kbd><kbd>r</kbd><kbd>n</kbd> to rename
- <kbd>,</kbd><kbd>f</kbd><kbd>f</kbd> to format code
- <kbd>,</kbd><kbd>c</kbd><kbd>a</kbd> to invoke code actions
- <kbd>,</kbd><kbd>l</kbd><kbd>e</kbd> to show line diagnostics
- <kbd>,</kbd><kbd>e</kbd><kbd>r</kbd> to show all diagnostics
- <kbd>,</kbd><kbd>e</kbd><kbd>d</kbd> to show diagnostics of the current buffer

### Treesitter

- `:InspectTree` to open the tree (formerly known as playground)
- `:PreviewQuery` to open query editor
- `:TSConfigInfo` to list current configuration
- text objects
  - `f` function or method
  - `c` call of function or method
  - `i` condition
  - `l` loop
  - `p` parameter
  - `na` next argument (parameter)
  - `la` last argument (parameter)
  - `a` current argument (parameter)
- <kbd>m</kbd> on a visual selection to select a bigger scope of visual
  selection
- `:TSHighlightCapturesUnderCursor` show highlight groups under the current
  cursor
- `:TSNodeUnderCursor` show node under the current cursor
- `vn` to select the current node
- in visual mode
  - `H` to increase the scope of selection
  - `L` to reduce the scope of selection
  - `J` to select the next tree node on the same level
  - `K` to select the previous tree node on the same level
  - <kbd>ctrl</kbd><kbd>j</kbd> to swap with the next node on the same level
  - <kbd>ctrl</kbd><kbd>k</kbd> to swap with the previous node on the same level
- `gif` to jump to if-statements
- `gfo` to jump to for loops
- `gj` to jump to other tree nodes

### C#

- <kbd>,</kbd><kbd>/</kbd> at signature to add XML comments
- <kbd>ctrl</kbd><kbd>b</kbd> to build

### Go

- <kbd>ctrl</kbd><kbd>b</kbd> to install

### Markdown

- <kbd>,</kbd><kbd>t</kbd> to align table cells
- <kbd>,</kbd><kbd>c</kbd><kbd>o</kbd> to start a code block
- <kbd>,</kbd><kbd>k</kbd> to wrap the current character with `<kbd></kbd>`
- <kbd>,</kbd><kbd>h</kbd><kbd>3</kbd> to mark the current line as header `###`

### SQL

- <kbd>F5</kbd> to execute query in buffer or visually selected query
- <kbd>ctrl</kbd><kbd>t</kbd> to switch database connection
  - connections are configured in `$HOME/.config/sqls/config.yml`

### Git

- <kbd>,</kbd><kbd>g</kbd><kbd>s</kbd> to show un-committed files and use `-` to
  toggle un-staged and staged files
- <kbd>,</kbd><kbd>g</kbd><kbd>a</kbd> to add the current file as staged file
- <kbd>,</kbd><kbd>g</kbd><kbd>b</kbd> to show blame lines (and toggle)
  - and <kbd>o</kbd> on the line in question to check the changes of that last
    commit
- <kbd>,</kbd><kbd>t</kbd><kbd>b</kbd> to show blame of the current line
- <kbd>,</kbd><kbd>g</kbd><kbd>c</kbd><kbd>c</kbd> to last change of the current
  line
- <kbd>,</kbd><kbd>g</kbd><kbd>c</kbd><kbd>o</kbd> to checkout the current file
  (effectively discarding current changes)
- <kbd>,</kbd><kbd>g</kbd><kbd>d</kbd> to show diff of the current file
  - <kbd>]</kbd><kbd>c</kbd> to jump to the next diff
  - <kbd>[</kbd><kbd>c</kbd> to jump back to the previous diff
- `:Gdiff origin/master` to show diff between `master` and the current branch
- <kbd>,</kbd><kbd>g</kbd><kbd>l</kbd><kbd>l</kbd> show logs of the current file
- <kbd>,</kbd><kbd>g</kbd><kbd>l</kbd><kbd>r</kbd>show logs of the current
  repository
- <kbd>,</kbd><kbd>g</kbd><kbd>w</kbd> to open the current file in a browser
- <kbd>,</kbd><kbd>g</kbd><kbd>y</kbd> to copy link to the current selected
  line(s)

### Scripting

- `:lua vim.pretty_print(1);` to print `1`
- `:lua vim.pretty_print(vim.fn.getpid());` to print process ID

### Folding

- <kbd>z</kbd><kbd>a</kbd> to toggle a folding
- <kbd>z</kbd><kbd>c</kbd> to close a folding
- <kbd>z</kbd><kbd>o</kbd> to open a folding
- `:set foldlevel=1` to fold up level 2 and deeper
  (equivalent to <kbd>,</kbd><kbd>c</kbd><kbd>2</kbd>)
- <kbd>,</kbd><kbd>c</kbd><kbd>0</kbd> to collapse all
- <kbd>,</kbd><kbd>c</kbd><kbd>9</kbd> to expand all

### File search

<kbd>ctrl</kbd><kbd>p</kbd> to search a file in the current repository

### File explorer (nvim-tree.lua)

- <kbd>,</kbd><kbd>n</kbd> to toggle file explorer
- <kbd>?</kbd> to toggle help
- <kbd>m</kbd> to rename
- <kbd>d</kbd> to remove
- <kbd>H</kbd> to toggle hidden files

#### Sorting

`:sort` to sort
`:sort!` to sort in descending order

### Terminal

- `:!ls` to run command `ls`
- `:read !git rev-parse HEAD` to run command `git rev-parse HEAD` and paste it
  into the current buffer
- `:!jq` with a visually selected text to format it with `jq`
- `:term` to enter terminal mode
  - <kbd>i</kbd> to change to interactive mode
  - <kbd>ctrl</kbd><kbd>\\</kbd><kbd>ctrl</kbd><kbd>n</kbd> to exit interactive
    mode

### Quickfix list

- <kbd>]</kbd><kbd>q</kbd> to jump to the next item
- <kbd>[</kbd><kbd>q</kbd> to jump to the previous item
- `:copen` to open a quickfix list
- `:cc2` to select the second option in a quickfix list
- `:ccl` to close the quickfix list

### Location list

- <kbd>]</kbd><kbd>l</kbd> to jump to the next item
- <kbd>[</kbd><kbd>l</kbd> to jump to the previous item
- `:lopen` to open a quickfix list
- `:ll2` to select the second option in a quickfix list
- `:lcl` to close the quickfix list

### Errors

- `:clist` to list all errors
- `:cn` to advance to the next error
- `:cp` to go to the previous error

### Twilight

- <kbd>,</kbd><kbd>l</kbd><kbd>l</kbd> to toggle twilight highlight

### Debugging

- <kbd>F5</kbd> to start debugging
- `:DapTerminate` to stop debugging
- <kbd>F9</kbd> to toggle a breakpoint
- <kbd>F10</kbd> to step over
- <kbd>F11</kbd> to step into
- <kbd>F12</kbd> to step out
- debugging adapters installation are needed beforehand
  - configuration of adapters for a DAP client can be configured as
    `dap.adapter`
  - launch or attach configuration can be configured via
    `$PROJECT_DIR/.vscode/launch.json`

##### Links of debug adapter

- [Debug
  Adapters](https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/)
- [debug adapter of
  flutter](https://github.com/flutter/flutter/blob/master/packages/flutter_tools/lib/src/debug_adapters/README.md)
- [Multi device debugging in VS
  Code](https://github.com/flutter/flutter/wiki/Multi-device-debugging-in-VS-Code)

##### Configuration for Go

`$PROJECT_DIR/.vscode/launch.json`

```json
{
  "configurations": {
    "run": {
      "adapter": "delve",
      "filetypes": [ "go" ],
      "configuration": {
        "request": "launch",
        "program": "${fileDirname}",
        "args": [],
        "mode": "debug"
      }
    },
    "run": {
      "adapter": "delve",
      "filetypes": [ "go" ],
      "configuration": {
        "request": "launch",
        "program": "${fileDirname}",
        "mode": "debug"
      }
    }
  }
}
```

##### Configuration for .NET

`$PROJECT_DIR/.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": ".NET Core Launch (web)",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${workspaceFolder}/Alex.Namespace.Web/bin/Debug/net6.0/Alex.Namespace.Web.dll",
      "args": [],
      "cwd": "${workspaceFolder}/Alex.Namespace.Web",
      "stopAtEntry": false,
      "env": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    },
    {
      "name": ".NET Core Attach",
      "type": "coreclr",
      "request": "attach",
      "processId": "${command:pickProcess}"
    }
  ]
}
```

`$PROJECT_DIR/.vscode/tasks.json`

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "rebuild",
      "command": "dotnet",
      "type": "process",
      "args": [
        "build",
        "--no-incremental",
        "${workspaceFolder}/Alex.Namespace.sln",
        "/property:GenerateFullPaths=true"
      ]
    },
    {
      "label": "build",
      "command": "dotnet",
      "type": "process",
      "args": [
        "build",
        "${workspaceFolder}/Alex.Namespace.sln",
        "/property:GenerateFullPaths=true"
      ],
      "problemMatcher": "$msCompile"
    }
  ]
}
```

##### Configuration for Rust

`$PROJECT_DIR/.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch",
      "type": "codelldb",
      "request": "launch",
      "program": "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
      "args": [],
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false
    }
  ]
}
```

##### Configuration for C/C++

`$PROJECT_DIR/.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch",
      "type": "codelldb",
      "request": "launch",
      "program": "${workspaceFolder}/output",
      "args": [],
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false
    }
  ]
}
```

##### Configuration for Flutter

`$PROJECT_DIR/.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch MacOS",
      "type": "dart",
      "request": "launch",
      "program": "${workspaceFolder}/lib/main.dart",
      "dartSdkPath": "{env:HOME}/git/flutter/bin/cache/dart-sdk",
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false,
      "deviceId": "macos"
    },
    {
      "name": "Launch Chrome",
      "type": "dart",
      "request": "launch",
      "program": "${workspaceFolder}/lib/main.dart",
      "dartSdkPath": "{env:HOME}/git/flutter/bin/cache/dart-sdk",
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false,
      "deviceId": "chrome"
    }
  ]
}
```

### Snippets

- [C#](https://github.com/honza/vim-snippets/blob/master/snippets/cs.snippets)
- [Go](https://github.com/honza/vim-snippets/blob/master/snippets/go.snippets)
- [Javascript](https://github.com/honza/vim-snippets/blob/master/snippets/javascript-es6-react.snippets)
- [HTML](https://github.com/honza/vim-snippets/blob/master/snippets/html.snippets)
- [Dart](https://github.com/honza/vim-snippets/blob/master/snippets/dart.snippets)
- [markdown](https://github.com/honza/vim-snippets/blob/master/snippets/markdown.snippets)

### vimrc

- `:map` maps recursively
- `:noremap` maps non-recursively
- `:nnoremap` maps non-recursively in normal mode
- `:e $MYVIMRC` to open `vimrc` in the current buffer
- `:so $MYVIMRC` to reload `vimrc`
- `:so %` to reload the current file into vim configuration

### Help pages

- <kbd>,</kbd><kbd>f</kbd><kbd>h</kbd> to search help

### Starting vim

##### To start without configuration and plugins

```sh
vim -u NONE src/hello.js
```

##### Open multiple files and split horizontally

```sh
vim -o src/hello.js src/world.js
```

##### Open multiple files and split virtically

```sh
vim -O src/hello.js src/world.js
```

##### To check which scripts are loaded (and in what order)

```sh
:scriptnames
```

## Scripting

### References

- [Vim scripting cheatsheet](https://devhints.io/vimscript)
- [Learn X (Vimscript) in Y minutes](https://learnxinyminutes.com/docs/vimscript/)
- [Vim Keyboard Shortcuts](https://keycombiner.com/collections/vim/)
  a visualisation of key combinations
- [rockerBOO/awesome-neovim](https://github.com/rockerBOO/awesome-neovim)
  a collections of awesome Neovim plugins
- [Getting started using Lua in
  Neovim](https://github.com/nanotee/nvim-lua-guide)
