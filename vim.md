### Topics

- [Basics](#basics)
- [Navigation](#navigation)
- [Editing](#editing)
- [Multicursors](#multicursors)
- [Buffers](#buffers)
- [Macro](#macro)
- [Errors](#errors)
- [ctrlp](#ctrlp)
- [Git](#git)
- [C#](#c%23)
- [Go](#go)
- [Snippets](#snippets)

The following notes is based on [this configuration](https://github.com/alexhokl/.vim/blob/master/vimrc).

##### Basics

- `esc` to normal mode
- `:wq` to save and exit
- `ctrl-p` to invoke fuzzy file search (in normal mode) or to invoke autocomplete (in edit mode)
- `V` to select a line visually
- `:map` to show all the mappings
- `:map r` to show mappings started with `r`

##### Navigation

- `gg` to go to the first line of a file
- `G` to go to the last line of a file
- `0` to jump to the beginning of the current line
- `$` to jump to the end of the current line
- `w` to jump to the beginning of the next word
- `b` to jump to the beginning of the previous word
- `}` to move cursor to the next empty line
- `{` to move cursor to the previous empty line
- `ctrl-e` to scroll down
- `ctrl-y` to scroll up
- `ctrl-f` to scroll down one page
- `ctrl-b` to scroll up one page
- `zt` to scroll the current line to the top of window
- double backticks to move cursor to previous position
- `gi` to move cursor to previous insert position
- `g;` to move the previous position in the change list
- `g,` to move the next position in the change list
- `/` to search forward
- `?` to search backward
- `*` to search the current word forward
- `#` to search the current word backward
- `w` to jump to the next word
- `b` to jump back to the last word
- `,<space>` to remove highlights from search
- `<space>` put current cursor in center of the screen
- `ctrl-n` to toggle NERDtree
- `m1` to mark the current cursor position to register `1`
- `'1` to jump to location stored in register `1`
- `[s` to jump to the previous spelling error
- `]s` to jump to the next spelling error
- `z=` on a spelling error to show a list of spelling suggestions
- `6+` to jump 6 lines below and to the head of the line
- `4-` to jump 4 lines above and to the head of the line
- `5$` to jump 5 lines below and to the end of the line
- `%` to jump to parentheses of the current line
- `ctrl-O` to jump back the to the previous position
- `ctrl-I` to jump forward to the next position (after a jump back)

##### Editing

- `a` to append
- `i` to insert
- `A` to append to the end of the current line
- `I` to insert to the beginning of the current line
- `d` to delete
- `c2w` to change 2 words
- `ysw'` to surround the current word with single quote
- `yssB` to surround the current line with curly brackets
- `yss"` to surround the current line with `"`
- `ySSB` to surround the current line with curly brackets but in different
    lines
- `ds"` to delete the surrounding `"`
- `dst` to delete the surrounding tag (XML or HMTL tags)
- `cs"'` to change the surround `"` to `'`
- `o` to open a new line in the next line and insert
- `O` to open a new line in the previous line and insert
- `[<space>` to insert a line above
- `]<space>` to insert a line below
- `[e` to move the current line up
- `]e` to move the current line down
- `:g/ASearchWord/d` to delete all lines containing `ASearchWord` (regex can be
used here)
- `:g!/ASearchWord/d` to delete all lines without containing `ASearchWord` (regex can
be used here
- `,/` or `gcc` to toggle comment
- visual selection + `gc` to toggle comment of multiple lines
- `u` to undo
- `ctrl-r` to redo
- `yy` to copy the current line
- `~` to toggle between upper case and lower case of the current character
- `gUaw` to change the current word to upper case
- `guaw` to change the current word to lower case
- `>` to add indentation to the current line
- `<` to remove indentation to the current line
- `=` to fix indentation of the current line
- ':retab' to replace all tabs with spaces

##### Multicursors

- `ctrl-i` to select the current pattern or advance to the next instance of the
    current pattern
- `ctrl-y` to select the previous instance of the current pattern
- `ctrl-b` to skip to the next instance of the current pattern
- `Esc` to remove multi-cursors

##### Buffers

- `ctrl-x` or `ctrl-z` to switch between file buffers in a direction
- `ctrl-^` to switch to a different buffer
- `ctrl-w` to change buffer
- `:vs` to split buffer vertically (the common way of splitting)
- `:vs index.html` to split buffer vertically and open `index.html`
- `:sp` to split buffer horizontally
- `,q` to close a buffer
- `,w` to write current buffer to disk
- `,W` to trim all whitespace without writing to disk
- `:only` to close all other buffers except the current one
- `:ls` to list all buffers

##### Macro

- `q1` to start recording at register `1`
- `q` in normal mode to stop recording
- `@1` to replay the recording at register `1`
- `5@1` to replay the recording at register `1` 5 times
- `:reg` to list the current registers

##### Errors

- `:clist` to list all errors
- `:cn` to advance to the next error
- `:cp` to go to the previous error

##### ctrlp

To refresh cached file list in fuzzy file search, hit `ctrl-p` and `F5` or use
command `:CtrlPClearCache`.


##### Git

- `,gs` to show un-commited files and use `-` to toggle unstage and staged
    files
- `,ga` to add the current file as staged file
- `,gb` to show blame lines (and toggle)
  - and `o` on the line in question to check the changes of that last commit
- `,gm` to commit all current staged files and put a message
- `,gco` to checkout the current file (effectively discarding current changes)
- `,gd` to show diff of the current file
  - `]c` to jump to the next diff
  - `[c` to jump back to the previous diff
- `:Gdiff origin/master` to show diff between `master` and the current branch
- `,gl` show logs of the current file in a quick-fix list
  - `]q` to jump to the next commit
  - `[q` to jump to the previous commit

##### C#

- `,fm` to list the members (methods or properties) in the current buffer
- `,fu` to find usages
- `,fi` to find implementations
- `,fs` to find symbols (pretty much like ctrl-t in ReSharper)
- `,dc` show documentation
- `,nm` to rename
- `,fx` to fix `using` statements
- `,cf` to format code
- `,ca` to invoke code actions
- `]m` to jump to the next method/property
- `[m` to jump to the previous method/property
- `:copen` to open a quickfix window
- `:cc 2` to select the second option in a quickfix window
- `ccl` to close the quickfix window


##### Go

- `,s` to show definition at bottom
- `,v` to show definition on the side
- `,b` to build
- `,rv` to run and show on the side
- `,t` to test
- `,dt` to test compile
- `,d` to show documentation
- `,e` to rename

##### Snippets

- [C#](https://github.com/honza/vim-snippets/blob/master/snippets/cs.snippets)
- [Go](https://github.com/honza/vim-snippets/blob/master/snippets/go.snippets)
- [Javascript](https://github.com/honza/vim-snippets/blob/master/snippets/javascript-es6-react.snippets)
- [HTML](https://github.com/honza/vim-snippets/blob/master/snippets/html.snippets)
- [Dart](https://github.com/honza/vim-snippets/blob/master/snippets/dart.snippets)
- [markdown](https://github.com/honza/vim-snippets/blob/master/snippets/markdown.snippets)

##### Help pages

- `:h vimtutor` - vim tutor
- `:h unimpaired` - vim-unimpaired
- `:h surround` - vim-surround
- `:h fugitive` - vim-fugitive
