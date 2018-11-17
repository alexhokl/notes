The following notes is based on [this configuration](https://github.com/alexhokl/.vim/blob/master/vimrc).

- `esc` to normal mode
- `:wq` to save and exit
- `ctrl-n` to toggle NERDtree
- `,gs` to view git status
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
- `ctrl-W` to change buffer
- `:vs` to split buffer vertically (the common way of splitting)
- `:vs index.html` to split buffer vertically and open `index.html`
- `:sp` to split buffer horizontally

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


##### ctrlp

To refresh cached file list in fuzzy file search, hit `ctrl-p` and `F5` or use
command `:CtrlPClearCache`.
