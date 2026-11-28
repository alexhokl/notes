- [Links](#links)
- [Terminal](#terminal)
- [Shortcuts](#shortcuts)
- [Scripting](#scripting)
  * [command substitution](#command-substitution)
  * [process substitution](#process-substitution)
  * [glob](#glob)
  * [redirection](#redirection)
  * [string](#string)
  * [list and range](#list-and-range)
  * [for](#for)
  * [if](#if)
  * [function](#function)
  * [options](#options)
  * [variables](#variables)
- [Recipes](#recipes)
  * [Versions](#versions)
  * [Users](#users)
  * [Hardware](#hardware)
  * [Power](#power)
  * [WiFi](#wifi)
  * [Locales](#locales)
  * [Printing](#printing)
  * [Images](#images)
  * [Videos](#videos)
  * [Timezones](#timezones)
  * [Packages](#packages)
  * [Processes](#processes)
____

## Links

- [List of Linux bash commands](https://github.com/trinib/Linux-Bash-Commands)
- [Bashly](https://bashly.dannyb.co/) - a command line application (written in
  Ruby) to generate feature-rich bash command line tools
- [pure bash bible](https://github.com/dylanaraps/pure-bash-bible)
- [Terminal cheat sheet](https://wizardzines.com/terminal-cheat-sheet.pdf) - by
  Julia Evans (Wizard Zines)

## Terminal

| Combination                             | Functionality                                                             |
| ---                                     | ---                                                                       |
| <kbd>ctrl</kbd><kbd>a</kbd>             | to jump to the beginning of a line                                        |
| <kbd>ctrl</kbd><kbd>e</kbd>             | to jump to the end of a line                                              |
| <kbd>ctrl</kbd><kbd>w</kbd>             | to cut a word before the cursor                                           |
| <kbd>ctrl</kbd><kbd>k</kbd>             | to cut to the end of a line                                               |
| <kbd>ctrl</kbd><kbd>u</kbd>             | to cut to the beginning of a line                                         |
| <kbd>ctrl</kbd><kbd>y</kbd>             | to paste already cut text                                                 |
| <kbd>alt</kbd><kbd>b</kbd>              | to skip one word backward                                                 |
| <kbd>alt</kbd><kbd>f</kbd>              | to advance one word forward                                               |
| <kbd>ctrl</kbd><kbd>←</kbd>             | to skip one word backward (in some terminals)                             |
| <kbd>ctrl</kbd><kbd>→</kbd>             | to advance one word forward (in some terminals)                           |
| <kbd>ctrl</kbd><kbd>h</kbd>             | to delete a character backward (if <kbd>backspace</kbd> does not work)    |
| <kbd>alt</kbd><kbd>d</kbd>              | to delete until the end of the current word include the current character |
| <kbd>ctrl</kbd><kbd>x</kbd><kbd>e</kbd> | to edit the current command in default editor                             |
| <kbd>alt</kbd><kbd>.</kbd>              | to paste the last argument of the last command                            |
| <kbd>alt</kbd><kbd>2</kbd>              | to copy the 2nd argument of the last command                              |
| <kbd>ctrl</kbd><kbd>/</kbd>             | to undo                                                                   |
| <kbd>ctrl</kbd><kbd>_</kbd>             | to redo                                                                   |
| <kbd>ctrl</kbd><kbd>c</kbd>             | to quit the running program (SIGINT)                                      |
| <kbd>ctrl</kbd><kbd>z</kbd>             | to stop the running program (SIGTSTP); resume with `fg` or `bg`           |
| <kbd>ctrl</kbd><kbd>d</kbd>             | to send EOF; quits a REPL or the shell                                    |
| <kbd>ctrl</kbd><kbd>\\</kbd>            | to quit the running program and dump core (SIGQUIT)                       |
| <kbd>ctrl</kbd><kbd>l</kbd>             | to clear the screen                                                       |
| <kbd>ctrl</kbd><kbd>s</kbd>             | to freeze the screen                                                      |
| <kbd>ctrl</kbd><kbd>q</kbd>             | to unfreeze the screen                                                    |
| `clear`                                 | to clear the screen                                                       |
| `reset`                                 | to reset the terminal when its output is messed up                        |
| `fc`                                    | to edit the last command in the default editor                            |
| <kbd>ctrl</kbd><kbd>r</kbd>             | to search commands in history                                             |

## Shortcuts

##### To show the current process ID

```sh
echo $$
```

##### To repeat the last command

```sh
!!
```

##### To repeat the last command with sudo

```sh
sudo !!
```

##### To show command history

```sh
history
```

##### To repeat command 33 in history

```sh
!33
```

To repeat the last parameter of the last command (space delimited)

```sh
git clone https://github.com/cli/cli githubcli
cd !$
```

## Scripting

### command substitution

```sh
$EDITOR `rg -l some_word`
```

This opens all the files found by `rg` in the default editor.

This is similar to `$()`, which is bash-specific, but it is also different where
command substitution cannot be nested (which means substitution within
substitution).

### process substitution

One of the use cases is to avoid generate temporary files storing output of
a command.

```sh
delta <(cat a.txt) <(cat b.txt)
```

### string

##### replace string in a variable

```sh
${f/\.txt/\.pdf}
```

### glob

##### To expand file names

```sh
ls *.png
```

##### To expand file names in all sub-directories

```sh
shopt -s globstar
wc **/*.txt
```

`globstar` is off by default in bash; zsh and fish support `**` out of the box.

##### To expand file names starting with a dot

```sh
ls .*
```

### redirection

##### To redirect stdout to a file

```sh
cmd > file.txt
```

##### To append stdout to a file

```sh
cmd >> file.txt
```

##### To send a file to stdin

```sh
cmd < file.txt
```

##### To redirect stderr to a file

```sh
cmd 2> file.txt
```

##### To redirect both stdout and stderr to a file

```sh
cmd > file.txt 2>&1
cmd &> file.txt
```

##### To pipe both stdout and stderr

```sh
cmd1 2>&1 | cmd2
```

### list and range

##### expanding list or range

```sh
mkdir -p folder/{sub1,sub2}/temp
mkdir -p folder/{1..100}/temp
mkdir -p folder/{a..z}/temp
```

### for

##### To loop through some of the files in current folder (where it is harder to use `find`)

```sh
for f in ./production.*; do echo $f; done
```

##### To loop through a bash array

```sh
colours=(red green blue)
for c in ${colours[*]}; do echo $c; done
```

##### To indirect reference an array in a loop

```sh
fruits_red=(grapefruit)
fruits_green=(kiwi)
fruits_blue=(blueberries)
colours=(red green blue)
for c in ${colours[*]}; do
    eval fruits=('"${fruits_'${c}'[@]}"')
    for f in ${fruits[*]}; do
        echo $c - $f
    done
done
```

### if

- `[ <condition> ]` is an old test where it works on all *-nix environment
- `[[ <condition> ]]` is a new test where it works only on modern Linux
    environment
- `==` EQUAL operator (in new test only)
- `&&` AND operator
- `||` OR operator; for example `[ <condition1> ] || [ <condition2> ]`
- `[ $# -lt 2 ]` checks if number of arguments is less than 2
- `[ "$str1" = "$str2" ]` checks if `str1` equals `str2`
- `[ "$str1" != "$str2" ]` checks if `str1` not equals `str2`
- `[[ "$str1" == *"end" ]]` checks if `str1` ends with `end`
- `[[ "${str1,,}" != "${str2,,}" ]]` checks if `str1` equals `str2` in
  a case-insensitive way
- `[ -n "$str" ]` checks if `str` is not empty
- `[ -z "$str" ]` checks if `str` is empty
- `[ $int1 -eq $int2 ]` checks if `int1` equals `int2`
- `elif` else-if
- `[ -d some-directory ]` checks if directory `some-directory` exists
- `[ -f some-file ]` checks if file `some-file` exists
- `[ -c some-file ]` checks if file `some-file` has contents
- `[ -L some-link ]` checks if a symbolic link exists
- `[ ! -f some-file ]` checks if file `some-file` not exists
- `[ -f *suffix ]` checks if file with suffix `suffix` exists
- `[ -z "${MY_VAR:-}" ]` checks if variable `MY_VAR` exists

### function

- `$2` refers to second argument of a function
- `for arg in "$@"; do echo "$arg"; done` echo out all arguments

### options

##### set -x

- enables a mode of the shell where executed commands are printed to the
  terminal.
- example usage
  - `[[ -n $DEBUG ]] && set -x`
- `set +x` disables this functionality

##### set -euo pipefail

- `set -e` causes a bash script to exit immediately when a command fails
  - append `|| true` to a command if immediate exit is not expected
- `set -u` causes the bash shell to treat unset variables as an error and exit
  immediately
- `set -o pipefail` ensure exit in first of the piped command

### variables

##### To make indirect reference to another variable

```sh
sites=$(eval "echo \$${DEPLOYMENT_TYPE}_sites")
```

##### To list paths in PATH

```sh
echo $PATH | tr ':' '\n'
```

##### To set a variable for one command only

```sh
env NAME=value cmd
NAME=value cmd
```

`env` behaves the same in every shell (including fish).

##### to modify PATH

```sh
echo ${PATH} > t1
vi t1
export PATH=$(cat t1)
```

##### To add a directory to PATH

```sh
export PATH=$PATH:/my/dir
export PATH=/my/dir:$PATH
```

The first appends it at the end and the second prepends it at the beginning.

##### To list all possible paths of a program

```sh
which -a program
```

This also shows the order of the paths.

##### To check if a command is an alias, a function, a builtin or a program

```sh
type cmd
```

## Recipes

### Versions

##### To check the distribution of linux

```sh
cat /etc/*release
```

##### To check linux kernel version

```sh
uname -a
```

### Users

##### To show the user groups the current user belongs to

```sh
groups
```

##### To add user to a group

```sh
usermod -a -G your-group your-username
```

##### To check status of an account

```sh
passwd -S your-username
```

Note that this can check if an account has been locked.

### Hardware

##### To list all PCI devices

```sh
lspci -vnn
```

### Power

##### To disable suspend and hibernation

```sh
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

To enable suspend and hibernation

```sh
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

##### To check battery information

```sh
upower -i /org/freedesktop/UPower/devices/battery_BAT0
```

### WiFi

##### wpa_passphrase

To generate configuration for login

```sh
wpa_passphrase your-ssid your-strong-password
```

### Locales

##### To show all installed locales and its metadata

```sh
locale
```

##### To show just locale

```sh
locale -a
```

### Printing

##### To show CUPS status information

```sh
lpstat -a
```

### Images

##### To convert a PNG file to an ICO file

```sh
convert -background transparent image.png -define icon:auto-resize=16,32,48,64,256 favicon.ico
```

##### To convert a JPG file with a lower quality

```sh
convert source.jpg -q 80 destination.jpg
```

##### To convert a AVI file to MPEG-4 file

```sh
ffmpeg -i video.avi -b 100k video.mp4
```

##### To convert an image to webp format

```sh
cwebp -q 80 source.image.png -o destination.webp
```

### Videos

##### To record screen in a GIF

```sh
byzanz-record -d 20 -x 0 -y 0 -w 1920 -h 2160 ~/Pictures/screencast.gif
```

##### To record screen with mouse cursor in a GIF

```sh
byzanz-record -d 20 -x 0 -y 0 -w 1920 -h 2160 -c ~/Pictures/screencast.gif
```

##### To record screen with mouse cursor in a WebM

```sh
byzanz-record -d 20 -x 0 -y 0 -w 1920 -h 2160 ~/Pictures/screencast.webm
```

### Timezones

##### To set timezone

```sh
sudo unlink /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
```

### Packages

##### To reconfigure an installed package

```sh
sudo dpkg-reconfigure locale
```

to configure locale.

### Processes

#### Links

- [Sloth](https://github.com/sveinbjornt/Sloth) on Mac

##### To list process occupied a file

```sh
fuser -v /path/to/file
```

##### To list process occupied a port

```sh
fuser -v -n tcp 3000
```

##### To kill a process with SIGKILL (which cannot be ignored)

```sh
kill -9 PID
```

##### To kill all processes by name

```sh
killall your-program-name
```

##### To kill all processes with a name anywhere in its arguments

```sh
pkill python3
```

##### To manage jobs

```sh
jobs
fg %2
bg %2
```

- `jobs` lists numbered jobs which can be referred to as `%2`
- `fg` resumes a job in foreground and `bg` resumes it in background
- <kbd>ctrl</kbd><kbd>z</kbd> pauses the job running in foreground

##### To keep all processes running after exiting the current terminal

```sh
disown -a && exit
```

##### To keep a job running after the terminal is closed

```sh
nohup cmd
disown %1
```

##### To force a program not to buffer its output

```sh
unbuffer cmd
```

`unbuffer` (from `expect`) makes the output of the program a TTY.

##### To check available memory

```sh
free -h
```

##### current running processes memory usage

```sh
top
```

##### To list most of the current network ports (or sockets)

```sh
sudo netstat -tupln
```
