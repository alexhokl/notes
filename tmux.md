### Prefixes

| Key | Functionality |
| --- | --- |
| d | detach the current session |
| ; | switch to the previous pane |
| c | create a new window |
| - | split the current window vertically |
| pipe | split the current window horizontally |
| , | rename the current window |

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
