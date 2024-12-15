- [qutebrowser](#qutebrowser)
  * [key bindings](#key-bindings)
  * [commands](#commands)
  * [recipes](#recipes)
____

# qutebrowser

## key bindings

### settings

- `Ss` to show settings

### URL

- `o` to open a URL
- `O` to open a URL in a new tab
- `yy` to copy the URL
- `ym` to copy the URL with title in markdown format
- `r` to reload the page
- `R` to reload the page ignoring cache
- `pp` to open the URL in the clipboard
- `Pp` to open the URL in the clipboard in a new tab
- `pP` to open the URL from selection
- `PP` to open the URL from selection in a new tab

### scrolling

- <kbd>ctrl</kbd><kbd>d</kbd> to scroll down
- <kbd>ctrl</kbd><kbd>u</kbd> to scroll up

### bookmarks

- `M` to add a bookmark
- `Sq` to show all bookmarks

### printing

- <kbd>ctrl</kbd><kbd>alt</kbd><kbd>p</kbd> to print the page

### debugging

- `wi` to show the inspector

## commands

### bookmarks

##### To add a bookmark

```
:bookmark-add https://test.com "The Site of Test.com"
```

##### To delete a bookmark

```
:bookmark-del "name of the bookmark"
```

## recipes

##### To import bookmarks from Chrome on Mac

```sh
cat $HOME/Library/Application\ Support/Google/Chrome/Default/Bookmarks |\
  jq -r '.roots.bookmark_bar.children[] | select(.name=="To Read") | .children[] | "qutebrowser :bookmark-add \(.url) \"\(.name)\""'
```

or to only import the last 5 bookmarks

```sh
cat $HOME/Library/Application\ Support/Google/Chrome/Default/Bookmarks |\
  jq -r '.roots.bookmark_bar.children[] | select(.name=="To Read") | .children[-5:][] | "qutebrowser :bookmark-add \(.url) \"\(.name)\""'
```
