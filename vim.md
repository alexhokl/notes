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
  * [Macro](#macro)
  * [Errors](#errors)
  * [Folding](#folding)
  * [File search](#file-search)
  * [File explorer](#file-explorer)
  * [Terminal](#terminal)
  * [Git](#git)
  * [C#](#c%23)
  * [Go](#go)
  * [Snippets](#snippets)
  * [vimrc](#vimrc)
  * [Help pages](#help-pages)
- [Scripting](#scripting)
  * [References](#references)
____

The following notes is based on my
[vimrc](https://github.com/alexhokl/.vim/blob/master/vimrc) and [these
configuration
files](https://github.com/alexhokl/vim-alexhokl/tree/master/plugin)

### Basics

- <kbd>esc</kbd> to normal mode
- `:wq` to save and exit
- <kbd>ctrl</kbd><kbd>p</kbd> to invoke fuzzy file search (in normal mode)
- <kbd>V</kbd> to select a line visually
- `:Maps` to search for a configured mapping

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
- <kbd>{</kbd> to move cursor to the previous empty line
- <kbd>ctrl</kbd><kbd>e</kbd> to scroll down
- <kbd>ctrl</kbd><kbd>y</kbd> to scroll up
- <kbd>ctrl</kbd><kbd>f</kbd> to scroll down one page
- <kbd>ctrl</kbd><kbd>b</kbd> to scroll up one page
- <kbd>z</kbd><kbd>t</kbd> to scroll the current line to the top of window
- <kbd>\`</kbd><kbd>\`</kbd> to move cursor to previous position
- <kbd>g</kbd><kbd>i</kbd> to move cursor to previous insert position
- <kbd>g</kbd><kbd>;</kbd> to move the previous position in the change list
- <kbd>g</kbd><kbd>,</kbd> to move the next position in the change list
- <kbd>g</kbd><kbd>v</kbd> to select the previous visual
- <kbd>w</kbd> to jump to the next word
- <kbd>b</kbd> to jump back to the last word
- <kbd>space</kbd> put current cursor in center of the screen
- <kbd>m</kbd><kbd>a</kbd> to mark the current cursor position to register `a`
- <kbd>m</kbd><kbd>A</kbd> to mark the current cursor position to register `A`
  and it can be used in a different buffer
- <kbd>'</kbd><kbd>a</kbd> to jump to location stored in register `a`
- <kbd>[</kbd><kbd>s</kbd> to jump to the previous spelling error
- <kbd>]</kbd><kbd>s</kbd> to jump to the next spelling error
- <kbd>z</kbd><kbd>=</kbd> on a spelling error to show a list of spelling suggestions
- <kbd>6</kbd><kbd>+</kbd> to jump 6 lines below and to the head of the line
- <kbd>4</kbd><kbd>-</kbd> to jump 4 lines above and to the head of the line
- <kbd>5</kbd><kbd>\$</kbd> to jump 4 (not 5) lines below and to the end of the
  line
- <kbd>8</kbd><kbd>0</kbd><kbd>\|</kbd> to jump to character 80 in the current
  line
- <kbd>%</kbd> to jump between the start and end of parentheses of the current
  line
- <kbd>[</kbd><kbd>{</kbd> to jump to the opening of the current curly brackets
- <kbd>]</kbd><kbd>}</kbd> to jump to the closing of the current curly brackets
- <kbd>ctrl</kbd><kbd>o</kbd> to jump back the to the previous position (in the
  jump list)
- <kbd>ctrl</kbd><kbd>i</kbd> to jump forward to the next position (after a jump
  back)(in the jump list)
- `:jumps` to show the current jump list
- <kbd>g</kbd><kbd>x</kbd> in a (proper) link to open a browser
- <kbd>g</kbd><kbd>f</kbd> in a file page to open the file in a buffer
- `:echo expand('%:p')` to show current path

### Editing

- <kbd>a</kbd> to append
- <kbd>i</kbd> to insert
- <kbd>A</kbd> to append to the end of the current line
- <kbd>I</kbd> to insert to the beginning of the current line
- <kbd>d</kbd> to delete
- <kbd>c</kbd><kbd>2</kbd><kbd>w</kbd> to change 2 words
- <kbd>o</kbd> to open a new line in the next line and insert
- <kbd>O</kbd> to open a new line in the previous line and insert
- <kbd>S</kbd> to start insert in a blank line with correct indentation
- <kbd>[</kbd><kbd>space</kbd> to insert a line above
- <kbd>]</kbd><kbd>space</kbd> to insert a line below
- <kbd>[</kbd><kbd>e</kbd> to move the current line up
- <kbd>]</kbd><kbd>e</kbd> to move the current line down
- <kbd>g</kbd><kbd>s</kbd> to swap function/method arguments (use <kbd>h</kbd>
  and <kbd>l</kbd> to swap and <kbd>j</kbd> and <kbd>k</kbd> to select)
- <kbd>g</kbd><kbd>s</kbd> to swap a visually selected list (use <kbd>h</kbd>
  and <kbd>l</kbd> to swap and <kbd>j</kbd> and <kbd>k</kbd> to select)
- <kbd>y</kbd><kbd>y</kbd> to copy the current line
- <kbd>c</kbd><kbd>2</kbd><kbd>i</kbd><kbd>(</kbd> to change all words in the
  outer brackets. `a(b(c))` &rarr; `a()`

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
- `:&&` to repeat the last replacement with flags
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
- <kbd>ctrl</kbd><kbd>f</kbd> to search in the current repository
- <kbd>,</kbd><kbd>F</kbd> to search for the current word in the current
  repository

### Indentation

- <kbd>></kbd> to add indentation in visual mode
- <kbd><</kbd> to remove indentation in visual mode
- <kbd>></kbd><kbd>></kbd> to add indentation to the current line
- <kbd>></kbd><kbd><</kbd> to remove indentation to the current line
- <kbd>4</kbd><kbd>></kbd><kbd>></kbd> to add indentation to the current line
  and the 3 lines below
- <kbd>=</kbd> to fix indentation of the current line
- <kbd>g</kbd><kbd>g</kbd><kbd>=</kbd><kbd>G</kbd> to fix indentation of the current file
- `:retab` to replace all tabs with spaces
- visually select lines and <kbd>g</kbd><kbd>q</kbd> to format those lines

### Uppercases/Lowercases

- <kbd>~</kbd> to toggle between upper case and lower case of the current character
- <kbd>g</kbd><kbd>U</kbd><kbd>a</kbd><kbd>w</kbd> to change the current word to upper case
- <kbd>g</kbd><kbd>u</kbd><kbd>a</kbd><kbd>w</kbd> to change the current word to lower case

### Undo/Redo

- <kbd>u</kbd> to undo
- <kbd>ctrl</kbd><kbd>r</kbd> to redo

### Surround

- <kbd>s</kbd><kbd>a</kbd><kbd>2</kbd><kbd>w</kbd><kbd>"</kbd> to surround two words with `"`
- <kbd>s</kbd><kbd>a</kbd><kbd>{</kbd> to surround a visually select block with `{}`
- <kbd>s</kbd><kbd>d</kbd><kbd>"</kbd> to delete the surrounding `"`
- <kbd>s</kbd><kbd>r</kbd><kbd>"</kbd><kbd>'</kbd> to replace the surrounding `"` with `'`
- <kbd>s</kbd><kbd>a</kbd><kbd>2</kbd><kbd>w</kbd><kbd>f</kbd> to surround two words with a function name and `()`
- <kbd>s</kbd><kbd>a</kbd><kbd>2</kbd><kbd>w</kbd><kbd>i</kbd> to surround two words with two texts (prefix and suffix could be
  different)
- <kbd>s</kbd><kbd>a</kbd><kbd>2</kbd><kbd>w</kbd><kbd>t</kbd> to surround two words with a tag
- <kbd>s</kbd><kbd>r</kbd><kbd>"</kbd><kbd>'</kbd> to replace surrounded double quotes with single quote

### Commenting

- <kbd>g</kbd><kbd>c</kbd><kbd>c</kbd> to toggle comment
- visual selection + <kbd>g</kbd><kbd>c</kbd> to toggle comment of multiple lines

### Multicursors

- <kbd>ctrl</kbd><kbd>i</kbd> to select the current pattern or advance to the
  next instance of the current pattern
- <kbd>ctrl</kbd><kbd>y</kbd> to select the previous instance of the current
  pattern
- <kbd>ctrl</kbd><kbd>b</kbd> to skip to the next instance of the current pattern
- <kbd>esc</kbd> to remove multi-cursors

### Buffers

- <kbd>ctrl</kbd><kbd>b</kbd> to select buffers
- <kbd>ctrl</kbd><kbd>x</kbd> or <kbd>ctrl</kbd><kbd>z</kbd> to switch between
  file buffers in a direction
- <kbd>ctrl</kbd><kbd>^</kbd> to jump to the previous buffer
- <kbd>ctrl</kbd><kbd>w</kbd> to change buffer
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
- <kbd>,</kbd><kbd>W</kbd> to trim all whitespace without writing to disk
- `:only` to close all other buffers except the current one
- `:ls` to list all buffers
- `:b 2` to change to second buffer
- `:b doc`<kbd>tab</kbd> to change to a buffer with file prefixed with `doc`
- <kbd>,</kbd><kbd>↑</kbd> to increase vertical size of the current buffer
- <kbd>,</kbd><kbd>↓</kbd> to decrease vertical size of the current buffer
- <kbd>,</kbd><kbd>←</kbd> to decrease horizontal size of the current buffer
- <kbd>,</kbd><kbd>→</kbd> to increase horizontal size of the current buffer
- `:mksession layout.vim` to save the current layout to `layout.vim` (to open
  the layout again, use `vim -s layout.vim`)

### Macro

- <kbd>q</kbd><kbd>1</kbd> to start recording at register `1`
- <kbd>q</kbd> in normal mode to stop recording
- <kbd>@</kbd><kbd>1</kbd> to replay the recording at register `1`
- <kbd>5</kbd><kbd>@</kbd><kbd>1</kbd> to replay the recording at register `1`
  5 times
- `:reg` to list the current registers

### Errors

- `:clist` to list all errors
- `:cn` to advance to the next error
- `:cp` to go to the previous error

### Folding

- <kbd>z</kbd><kbd>a</kbd> to toggle a folding
- <kbd>z</kbd><kbd>c</kbd> to close a folding
- <kbd>z</kbd><kbd>o</kbd> to open a folding
- `:set foldlevel=1` to fold up level 2 and deeper

### File search

<kbd>ctrl</kbd><kbd>p</kbd> to search a file in the current repository

### File explorer

- `:Vex` to open a file explorer (netrw)

### Terminal

- `:!ls` to run command `ls`
- `:read !git rev-parse HEAD` to run command `git rev-parse HEAD` and paste it
  into the current buffer
- `:!jq` with a visually selected text to format it with `jq`

### Git

- <kbd>,</kbd><kbd>g</kbd><kbd>s</kbd> to show un-committed files and use `-` to
  toggle un-staged and staged files
- <kbd>,</kbd><kbd>g</kbd><kbd>a</kbd> to add the current file as staged file
- <kbd>,</kbd><kbd>g</kbd><kbd>b</kbd> to show blame lines (and toggle)
  - and <kbd>o</kbd> on the line in question to check the changes of that last commit
- <kbd>,</kbd><kbd>g</kbd><kbd>m</kbd> to commit all current staged files and put a message
- <kbd>,</kbd><kbd>g</kbd><kbd>c</kbd><kbd>o</kbd> to checkout the current file (effectively discarding current changes)
- <kbd>,</kbd><kbd>g</kbd><kbd>d</kbd> to show diff of the current file
  - <kbd>]</kbd><kbd>c</kbd> to jump to the next diff
  - <kbd>[</kbd><kbd>c</kbd> to jump back to the previous diff
- `:Gdiff origin/master` to show diff between `master` and the current branch
- <kbd>,</kbd><kbd>g</kbd><kbd>l</kbd> show logs of the current file in a quick-fix list
  - <kbd>]</kbd><kbd>q</kbd> to jump to the next commit
  - <kbd>[</kbd><kbd>q</kbd> to jump to the previous commit
- <kbd>g</kbd><kbd>w</kbd> to open the current file in a browser

### C#

- <kbd>,</kbd><kbd>f</kbd><kbd>m</kbd> to list the members (methods or properties) in the current buffer
- <kbd>g</kbd><kbd>r</kbd> to find usages
- <kbd>,</kbd><kbd>g</kbd><kbd>i</kbd> to find implementations
- <kbd>,</kbd><kbd>f</kbd><kbd>s</kbd> to find symbols (pretty much like <kbd>ctrl</kbd><kbd>t</kbd> in ReSharper)
- <kbd>K</kbd> show documentation
- <kbd>,</kbd><kbd>r</kbd><kbd>n</kbd> to rename
- <kbd>,</kbd><kbd>f</kbd><kbd>x</kbd> to fix `using` statements
- <kbd>,</kbd><kbd>c</kbd><kbd>f</kbd> to format code
- <kbd>,</kbd><kbd>f</kbd> to format visually selected code
- <kbd>,</kbd><kbd>c</kbd><kbd>a</kbd> to invoke code actions
- <kbd>]</kbd><kbd>m</kbd> to jump to the next method/property
- <kbd>[</kbd><kbd>m</kbd> to jump to the previous method/property
- `:copen` to open a quickfix window
- `:cc 2` to select the second option in a quickfix window
- `:ccl` to close the quickfix window
- `:OmniSharpRunTest` to run unit test of the test method containing the
  current cursor
- `:OmniSharpRunTestsInFile` to run unit tests in the current file

### Go

- <kbd>,</kbd><kbd>s</kbd> to show definition at bottom
- <kbd>,</kbd><kbd>v</kbd> to show definition on the side
- <kbd>,</kbd><kbd>b</kbd> to build
- <kbd>,</kbd><kbd>r</kbd><kbd>v</kbd> to run and show on the side
- <kbd>,</kbd><kbd>t</kbd> to test
- <kbd>,</kbd><kbd>d</kbd><kbd>t</kbd> to test compile
- <kbd>,</kbd><kbd>d</kbd> to show documentation
- <kbd>[</kbd><kbd>[</kbd> jump to the previous function
- <kbd>]</kbd><kbd>]</kbd> jump to the next function
- <kbd>,</kbd><kbd>e</kbd> to rename
- <kbd>v</kbd><kbd>i</kbd><kbd>f</kbd> to visually select body of a function (not including function signature)
- <kbd>v</kbd><kbd>a</kbd><kbd>f</kbd> to visually select the whole function including its comments
- `:GoCoverage` to start code coverage
- `:GoCoverageClear` to remove highlights of code coverage
- `:GoCoverageToggle` to toggle highlights of code coverage
- `:GoAddTags json` to add json field tags to a model `struct`

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

### Help pages

- `:h vimtutor` - vim tutor
- `:h unimpaired` - vim-unimpaired
- `:h surround` - vim-surround
- `:h fugitive` - vim-fugitive
- `:h v_something` to check command `something` in visual mode
- `:h i_something` to check command `something` in insert mode
- `:helpgrep searchWord` to look for `searchWord` in all help files

## Scripting

### References

- [Vim scripting cheatsheet](https://devhints.io/vimscript)
- [Learn X (Vimscript) in Y minutes](https://learnxinyminutes.com/docs/vimscript/)
