- [Default keybindings](#default-keybindings)
  * [Navigation (index)](#navigation-index)
  * [Reading (pager)](#reading-pager)
  * [Moving, copying, deleting](#moving%2C-copying%2C-deleting)
  * [Searching and filtering](#searching-and-filtering)
  * [Composing](#composing)
  * [Flags and misc](#flags-and-misc)
____

# Default keybindings

- `?` shows all bindings in the current menu, `:` opens the command prompt

## Navigation (index)

- `j` / `k` or `↓` / `↑`: next / previous message
- `Home` / `End`: first / last message
- `Ctrl-f` / `Ctrl-b`: page down / up (also `Space` / `-`)
- `Enter`: open message
- `c`: change folder (`Tab` completes, `?` lists folders)
- `q`: quit or back out of the current menu

## Reading (pager)

- `Space`: next page
- `-`: previous page
- `j` / `k`: next / previous line
- `n` / `p`: next / previous message
- `v`: view attachments
- `i`: return to the index

## Moving, copying, deleting

- `s`: save (move) the message to another folder
- `C`: copy the message to a folder
- `d`: delete
- `u`: undelete
- `$`: sync mailbox (apply deletes and flag changes)
- `t`: tag a message
- `T`: tag messages matching a pattern
- `Ctrl-t`: untag messages matching a pattern
- `;`: apply the next action to all tagged messages (e.g. `;s`)

## Searching and filtering

- `l`: limit the view to messages matching a pattern
- `l` then `~A`: show all messages again
- `/` / `Esc-/`: search forward / backward
- `n` / `N`: next / previous match
- pattern examples:
  - `~f alice`: from
  - `~s invoice`: subject
  - `~b text`: body
  - `~N`: new
  - `~U`: unread
  - `~F`: flagged
  - `~d <7d`: within the last 7 days
- combine patterns with `&` (and) and `|` (or)

## Composing

- `m`: new mail
- `r`: reply
- `g`: group reply
- `f`: forward
- `e`: edit the message (compose menu)
- `a`: attach a file (compose menu)
- `y`: send (compose menu)

## Flags and misc

- `F`: toggle flag
- `N`: toggle new
- `o`: sort
- `Ctrl-l`: redraw
