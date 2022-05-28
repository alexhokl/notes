- [Reference](#reference)
- [Characteristics](#characteristics)
- [Basic guidelines](#basic-guidelines)
- [Help](#help)
- [Documentation](#documentation)
- [Output](#output)
- [Errors](#errors)
- [Arguments and flags](#arguments-and-flags)
- [Interactivity](#interactivity)
- [Subcommands](#subcommands)
- [Robustness](#robustness)
- [Future-proofing](#future-proofing)
- [Signals and control characters](#signals-and-control-characters)
- [Configuration](#configuration)
- [Environment varaibles](#environment-varaibles)
- [Naming](#naming)
- [Distribution](#distribution)
- [Analytics](#analytics)
____

### Reference

- [Command Line Interface Guidelines](https://clig.dev/)

### Characteristics

- embodied an accidental metaphor - a conversation
- types of conversation
  - trail-and-error
  - running several commands to set up an operation, and then a final command to
    run it
  - doing a dry-run of a complex operation before running it for real
- things can be done in a conversation
  - suggest possible correlations when user input is invalid
  - make the intermediate state clear when the user is going through
    a multi-step process
  - confirm for them that everything looks good before they do `something` scary
- Subjective robustness requires attention to detail and thinking hard about
  what can go wrong. It’s lots of little things: keeping the user informed about
  what’s happening, explaining what common errors mean, not printing
  scary-looking stack traces.
- Empathy means giving the user the feeling that you are on their side, that you
  want them to succeed, that you have thought carefully about their problems and
  how to solve them.

### Basic guidelines

- use a command-line argument parsing library where you can
  - bash
    - [argbash](https://github.com/matejak/argbash)
  - Go
    - [Corbra](https://github.com/spf13/cobra)
    - [cli](https://github.com/urfave/cli)
  - Node
    - [oclif](https://github.com/oclif/oclif)
  - Python
    - [argparse](https://docs.python.org/3/library/argparse.html)
    - [click](https://github.com/pallets/click)
    - [typer](https://typer.tiangolo.com/)
  - Rust
    - [clap](https://docs.rs/clap/latest/clap/)
- return zero exit code on success, non-zero on failure
- send output to `stdout`
- send messaging to `stderr`
  - this means that when commands are piped together, these messages are
    displayed to the user and not fed into the next command

### Help

- display help text when passed no options, the `-h` flag, or the `--help` flag
- display a concise help text by default
  - display help by default when `myapp` or `myapp subcommand` is run
  - help text including
    - a description of what your program does
    - one or two example invocations
    - descriptions of flags, unless there are lots of them
    - an instruction to pass the `--help` flag for more information
  - `jq` is a good example
- show full help when `-h` and `--help` is passed
- ignore any other flags and arguments that are passed
- do not overload `-h`
- provide a support path for feedback and issues
- in help text, link to the web version of the documentation
- lead with examples
- if you have got loads of examples, put them somewhere else
  - a cheat sheet command or a web page
    - it is useful to have exhaustive, advanced examples, but you don’t want to
      make your help text really long
- display the most common flags and commands at the start of the help text
  - it is fine to have lots of flags, but if you have got some really common
    ones, display them first
- use formatting in your help text
  - bold headings make it much easier to scan. But, try to do it in
    a terminal-independent way so that your users are not staring down a wall of
    escape characters.
- if the user did something wrong and you can guess what they meant, suggest it
  - example
    - `brew update jq` tells you that you should run `brew upgrade jq`
  - you can ask if they want to run the suggested command, but don’t force it on
    them
    - invalid input does not necessarily imply a simple typo — it can often mean
      the user has made a logical mistake, or misused a shell variable
    - forcing the suggestion would mean you are ruling that the way they typed
      it is valid and correct, and you’re committing to supporting that
      indefinitely
- if your command is expecting to have something piped to it and `stdin` is an
  interactive terminal, display help immediately and quit
  - This means it does not just hang, like `cat`. Alternatively, you could print
    a log message to `stderr`

### Documentation

- the purpose of help text is to give a brief, immediate sense of what your tool
  is, what options are available, and how to perform the most common tasks.
  Documentation, on the other hand, is where you go into full detail
- provide web-based documentation
- provide terminal-based documentation
- consider providing man pages
  - `man mycmd`
    - the document can be generated from markdown with tool like
      [ronn](https://rtomayko.github.io/ronn/ronn.1.html)
    - `git help add` is equivalent to `man git-add`

### Output

- human-readable output is paramount
  - humans come first, machines second
- have machine-readable output where it does not impact usability
- if human-readable output breaks machine-readable output, use `--plain` to
  display output in plain, tabular text format for integration with tools like
  `grep` or `awk`
- display output as formatted JSON if `--json` is passed
- display output on success, but keep it brief
  - `-q` option to suppress all non-essential output
- if you change state, tell the user
  - particularly if the result does not directly map to what the user requested
- make it easy to see the current state of the system
  - example
    - `git status`
- suggest commands the user should run
  - example
    - `git status` suggests commands you can run to modify the state you are
      viewing
- use colour with intention
- disable colour if your program is not in a terminal or the user requested it
  - `stdout` or `stderr` is not an interactive terminal
  - respect `NO_COLOR` environment variable
  - `TERM` environment variable has the value `dumb`
  - `--no-color`
  - environment variable `MYAPP_NO_COLOR`
- if `stdout` is not an interactive terminal, do not display any animations
- use symbols and emoji where it makes things clearer
- by default, do not output information that is only understandable by the
  creators of the software
- do not treat `stderr` like a log file, at least not by default
  - do not print log level labels (`ERR`, `WARN`, etc) or extraneous contextual
    information, unless in verbose mode
- use a pager if you are outputting a lot of text
  - using a pager can be error-prone, so be careful with your implementation
    such that you do not make the experience worse for the user. You should not
    use a pager if `stdin` or `stdout` is not an interactive terminal
  - a good sensible set of options to use for `less` is `less -FIRX`

### Errors

- catch errors and rewrite them for humans
  - example
    - "Can’t write to file.txt. You might need to make it writable by running
      ‘chmod +w file.txt’."
- signal-to-noise ratio is crucial
- consider where the user will look first
  - put the most important information at the end of the output. The eye will be
    drawn to red text, so use it intentionally and sparingly
- if there is an unexpected or unexplainable error, provide debug and traceback
  information, and instructions on how to submit a bug
  - consider writing the debug log to a file instead of printing it to the
    terminal
- make it effortless to submit bug reports
  - one nice thing you can do is provide a URL and have it pre-populate as much
    information as possible.

### Arguments and flags

- prefer flags to arguments
  - arguments are positional parameters to a command; the order of arguments is
    often important
  - flags are named parameters
- have full-length versions of all flags
- only use one-letter flags for commonly used flags
- if you have got two or more arguments for different things, you’re probably
  doing something wrong
  - exception
    - `cp <source> <destination>`
- use standard names for flags, if there is a standard
  - it is best to follow that existing pattern
  - commonly used options
    - `a`, `--all`
    - `-d`, `--debug`
    - `-f`, `--force`
    - `--json`
    - `-h`, `--help`
    - `--no-input`
    - `-o`, `--output`
    - `-p`, `--port`
    - `-q`, `--quiet`
    - `-u`, `--user`
    - `--version`
    - `-v`
- make the default the right thing for the most users
  - example
    - `ls -lhF`
- prompt for user input
- never require a prompt
  - always provide a way of passing input with flags or arguments
  - if `stdin` is not an interactive terminal, skip prompting and just require
    those flags/arguments
- confirm before doing anything dangerouss
  - a common convention is to prompt for the user to type `y` or `yes` if
    running interactively, or requiring them to pass `-f` or `--force` otherwise
- if input or output is a file, support `-` to read from `stdin` or write to
  `stdout`
  - example
    - `curl https://example.com/something.tar.gz | tar xvf -`
- if a flag can accept an optional value, allow a special word like `none`
- if possible, make arguments, flags and subcommands order-independent
- do not read secrets directly from flags
  - consider accepting sensitive data only via files or via `stdin`

### Interactivity

- only use prompts or interactive elements if `stdin` is an interactive terminal
  (a TTY)
- if `--no-input` is passed, do not prompt or do anything interactive
  - if the command requires input, fail and tell the user how to pass the
    information as a flag
- if you are prompting for a password, do not print it as the user types
  - this is done by turning off echo in the terminal
- let the user escape
  - if your program hangs on network I/O etc, always make Ctrl-C still work. If
  - it is a wrapper around program execution where Ctrl-C can’t quit, make it
    clear how to do that

### Subcommands

- be consistent across subcommands
  - use the same flag names for the same things, have similar output formatting,
    etc
- use consistent names for multiple levels of subcommand
  - either `noun verb` or `verb noun` ordering works, but `noun verb` seems to
    be more common
- do not have ambiguous or similarly-named commands
  - example
    - `update` and `upgrade`

### Robustness

- validate user input
- responsive is more important than fast
  - if you are making a network request, print something before you do it so it
    does not hang and look broken
- show progress if something takes a long time
  - libraries
    - [tqdm](https://github.com/tqdm/tqdm) for Python
    - [schollz/progressbar](https://github.com/schollz/progressbar) for Go
    - [node-progress](https://github.com/visionmedia/node-progress) for Node.js
- do stuff in parallel where you can, but be thoughtful about it
  - if you can use a library, do so; this is code you don’t want to write
    yourself
  - the upside is that it can be a huge usability gain
    - example
      - `docker pull`
  - hiding logs behind progress bars when things go well makes it much easier
    for the user to understand what is going on, but if there is an error, make
    sure you print out the logs
- make things time out
  - allow network timeouts to be configured, and have a reasonable default so it
    does not hang forever
- make it idempotent
- make it crash-only
  - if you can avoid needing to do any clean-up after operations, or you can
    defer that clean-up to the next run, your program can exit immediately on
    failure or interruption
- people are going to misuse your program
  - be prepare for that

### Future-proofing

- keep changes additive where you can
  - avoid breaking changes
- warn before you make a non-additive change
  - when they pass the flag you are looking to deprecate, tell them it’s going
    to change soon and tell the suggestion
- changing output for humans is usually OK
  - encourage your users to use `--plain` or `--json` in scripts to keep output
    stable
- do not have a catch-all subcommand
  - if you have a subcommand that is likely to be the most-used one, you might
    be tempted to let people omit it entirely for brevity’s sake
- do not allow arbitrary abbreviations of subcommands
- do not create a "time bomb"
  - will your command still run the same as it does today?

### Signals and control characters

- if a user hits Ctrl-C (the INT signal), exit as soon as possible
  - add a timeout to any clean-up code so it cannot hang forever
- if a user hits Ctrl-C during clean-up operations that might take a long time,
  skip them

### Configuration

- use flags if it is  likely to vary from one invocation of the command to the
  next
- use flags and probably environment variables if generally stable from one
  invocation to the next, but not always
- use a command-specific, version-controlled file if it is stable with
  a project, for all users
- follow the XDG-spec
  - `~/.config/`
- modify configuration that is not your program
  - prefer creating a new config file (for example `/etc/cron.d/myapp`)
  - if you have to append or modify to a system-wide config file, use a dated
    comment in that file to delineate your additions
- apply configuration parameters in order of precedence
  - flags
  - environment variables
  - project-level configuration
  - user-level configuration
  - system wide configuration

### Environment varaibles

- environment variables are for behaviour that varies with the context in which
  a command is run
- for maximum portability, environment variable names must only contain
  uppercase letters, numbers, and underscores
- aim for single-line environment variable values
- avoid commandeering widely used names
- check general-purpose environment variables for configuration values when
  possible
  - `NO_COLOR`
  - `DEBUG`
  - `EDITOR`
  - `HTTP_PROXY`, `HTTPS_PROXY`, `ALL_PROXY` and `NO_PROXY`
  - `SHELL`
  - `TERM`, `TERMINFO` and `TERMCAP`
  - `TMPDIR`
  - `HOME`
  - `PAGER`
  - `LINES` and `COLUMNS`
- read environment variables from `.env` where appropriate
- do not use `.env` as a substitute for a proper configuration file
  - a `.env` file is not commonly stored in source control
  - it often contains sensitive credentials & key material that would be better
    stored more securely
- do not read secrets from environment variables
  - exported environment variables are sent to every process, and from there can
    easily leak into logs or be exfiltrated
    - alternative
      - `cURL` offers the `-H @filename` alternative for reading sensitive
        headers from a file
  - everyone can do `docker inspect`
  - everyone can do `systemctl show`
  - secrets should only be accepted via credential files, pipes, `AF_UNIX`
    sockets, secret management services, or another IPC mechanism

### Naming

- make it a simple, memorable word
  - bad example
    - `convert` of ImageMagick
- use only lower-case letters, and dashes if you really need to
- keep it short
  - do not make too short
- make it easy to type

### Distribution

- if possible, distribute as a single binary
  - if you really cannot distribute as a single binary, use the platform’s
    native package installer so you are not scattering things on disk that
    cannot easily be removed
- make it easy to uninstall
  - if it needs instructions, put them at the bottom of the install instructions

### Analytics

- do not phone home usage or crash data without consent
  - homebrew sends metrics to Google Analytics and has a nice FAQ detailing
    their practices
  - Next.js collects anonymized usage statistics and is enabled by default
- consider alternatives to collecting analytics
  - instrument your web docs
  - instrument your downloads
  - talk to your users
    - reach out and ask people how they are using your tool

