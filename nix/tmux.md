- [Commands](#commands)
- [CLI](#cli)
- [Others](#others)
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
| [ | to enter copy mode, <kbd>space</kbd> to start select visually, <kbd>enter</kbd> to end selection and copy |
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

### Others

##### To transfer a long running process from a terminal to tmux

Note that [reptyr](https://github.com/nelhage/reptyr) has to be installed and it
does not work on Mac yet.

1. <kbd>ctrl</kbd><kbd>z</kbd> in the terminal running the process to pause it
2. `bg` in the same terminal to continue the process in background
3. `ps` to find out the pid
4. start tmux or rejoin an existing session
5. in the tmux session, run `reptyr 9876` (assuming the pid is `9876`)
