The following notes is based on [this configuration](https://github.com/alexhokl/.vim/blob/master/vimrc).

- `esc` to normal mode
- `:wq` to save and exit
- `ctrl-p` to invoke fuzzy file search (in normal mode) or to invoke autocomplete (in edit mode)
- `shift-v` to select a line

##### Editing

- `a` to append
- `i` to insert
- `A` to append to the end of the current line
- `I` to insert to the beginning of the current line
- `d` to delete
- `c2w` to change 2 words
- `o` to open a new line in the next line and insert
- `O` to open a new line in the previous line and insert
- `:g/ASearchWord/d` to delete all lines containing `ASearchWord` (regex can be
    used here)
- `:g!/ASearchWord/d` to delete all lines without containing `ASearchWord` (regex can
    be used here

##### Buffers

- `ctrl-x` or `ctrl-z` to switch between file tabs (buffers)
- `ctrl-w` to change buffer
- `:vs` to split buffer vertically (the common way of splitting)
- `:vs index.html` to split buffer vertically and open `index.html`
- `:sp` to split buffer horizontally
- `,q` to close a buffer

##### Navigation

- `gg` to go to the first line of a file
- `shift-g` to go to the last line of a file
- `}` to move cursor to the next empty line
- `{` to move cursor to the previous empty line
- `ctrl-F` to move cursor to the next page
- double backticks to move cursor to previous position
- `gi` to move cursor to previous insert position
- `g;` to move the previous position in the change list
- `g,` to move the next position in the change list
- `/` to search forward
- `?` to search backward
- `space` put current cursor in center of the screen
- `ctrl-n` to toggle NERDtree

##### Errors

- `:clist` to list all errors
- `:cn` to advance to the next error
- `:cp` to go to the previous error

##### ctrlp

To refresh cached file list in fuzzy file search, hit `ctrl-p` and `F5` or use
command `:CtrlPClearCache`.


##### Git

- `,gs` or `:Gstatus` to show un-commited files and use `-` to toggle unstage and staged
    files
- `,ga` to add the current file as staged file
- `,gb` to show blame lines (and toggle)
- `,gm` to commit all current staged files and put a message

##### Omnisharp

- `,fm` to list the members (methods or properties) in the current buffer
- `,fu` to find usages
- `,fi` to find implementations
- `,fs` to gind symbols (pretty much like ctrl-t in ReSharper)
- `,dc` show documentation
- `,nm` to rename
- `,fx` to fix `using` statements
- `,cf` to format code
