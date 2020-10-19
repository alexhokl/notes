- [Commands](#commands)
- [CLI](#cli)
____

Reference: [.tmux.conf](https://github.com/alexhokl/dotfiles/blob/master/.tmux.conf)

### Commands

Note that the prefix key is <kbd>ctrl</kbd><kbd>z</kbd>.

| Key | Functionality |
| --- | --- |
| ? | to show all the current key bindings |
| d | detach the current session |
| ; | switch to the previous pane |
| c | create a new window |
| - | split the current window vertically |
| pipe | split the current window horizontally |
| , | rename the current window |
| arrow keys | switch pane |
| alt + arrow keys | resize pane |
| alt-F | fullscreen |
| alt-f | exit fullscreen |
| [ | to enter copy mode |
| ] | to paste the current buffer |
| = | to select a buffer and paste its content |
| r | to reload configuration |

### CLI

##### To list sessions

```sh
tmux list-sessions
```

##### To attach to a session

```sh
tmux attach -t 0
```

##### To kill a session

```sh
tmux kill-session -t 0
```

##### To create a new session with a session name and a window name

```sh
tmux new-session -d -s your-session-name -n your-window-name
```
