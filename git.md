- [Links](#links)
- [Setup](#setup)
  * [BASH completion](#bash-completion)
  * [Signing commits using SSH key](#signing-commits-using-ssh-key)
- [Operations](#operations)
  * [New repository](#new-repository)
  * [Forking](#forking)
  * [Cloning](#cloning)
  * [Rebase](#rebase)
  * [Add](#add)
  * [Remove](#remove)
  * [Commit](#commit)
  * [Rollback](#rollback)
  * [Branches](#branches)
  * [Cleaning up](#cleaning-up)
  * [Bisect](#bisect)
  * [Stash](#stash)
  * [Submodule](#submodule)
  * [Tags](#tags)
  * [GPG signature](#gpg-signature)
  * [Checkout](#checkout)
  * [Revert](#revert)
  * [Rerere](#rerere)
  * [Subtree](#subtree)
  * [LFS](#lfs)
  * [Configuration](#configuration)
  * [Operators](#operators)
  * [Queries](#queries)
    + [Logs](#logs)
    + [Commit](#commit-1)
    + [Diff](#diff)
    + [Text search](#text-search)
    + [Remotes](#remotes)
    + [Ignore](#ignore)
    + [Others](#others)
  * [Troubleshooting](#troubleshooting-1)
  * [GitHub](#github)
____

# Links

- [GitHub Blog](https://github.blog/)
- [Set up your YubiKey for Git signing with
  FIDO2](https://www.youtube.com/watch?v=2M2vKQwbCDk)
- [Popular git config
  options](https://jvns.ca/blog/2024/02/16/popular-git-config-options/)
- [GOTO 2019 • Knowledge is Power: Getting out of Trouble by Understanding Git
  • Steve Smith](https://www.youtube.com/watch?v=fHLcZGi3yMQ) - on `.git`
  directory

# Setup

## BASH completion

1. Get the completion file from `https://github.com/git/git/blob/master/contrib/completion/git-completion.bash`.
2. Copy the file to `/etc/bash_completion.d/` on Linux (on Mac, this requires a bit more work).
3. On Mac, source the file from the path in step 2 in `~/.bash_profile`.

## Signing commits using SSH key

Ensure the following configuration is set in `.gitconfig`.

```
[commit]
  gpgsign = true

[gpg]
  format = ssh

[user]
  signingkey = /path/to/some_ssh.pub

[gpg "ssh"]
  allowedSignersFile = /path/to/allowed_signers
```

where `allowed_signers` has the following format

```
someone@test.com,someoneelse@test.com ssh-ed25519 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFJ6
someone@test.com,someoneelse@test.com ssh-ed25519 AAAAF2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFJ6
```

# Operations

Note that aliases used can be found in [.gitconfig](https://github.com/alexhokl/dotfiles/blob/master/.gitconfig).

## New repository

To upload a local git repository onto GitHub, first create a repository on GitHub.

If the repository is dumped from another git remote,

```sh
git remote remove origin
```

To associate the repository with GitHub one

```sh
git remote add origin https://github.com/alexhokl/example.git
git push -u origin master
```

## Forking

To connect to the original repository of a forked repository,
check if the original repository is already stated in remotes.
If not, use `git remote add` to add "upstream".

```sh
git remote -v
git remote add upstream https://github.com/original/original.git
```

To update a forked repository from the original repository (`upstream` is just a name of a remote, see `git remote -v`)

```sh
git fetch upstream
git checkout master
git merge upstream/master
```

## Cloning

##### To clone a repository and its submodules

```sh
git clone --recursive https://github.com/author/repo
```

##### To clone a specific branch or tag

```sh
git clone -b your-branch https://github.com/author/repo
```

## Rebase

##### Rebase for merge

To rebase a feature branch before merging into `main` (it involves re-writing the commits in the feature branch)

```sh
git fetch
git checkout feature_branch
git rebase -i origin/main

(git shows a list of commits involved in an editor and quit the editor if the list looks good)

eit mergetool (upon any conflicts)
git rebase --continue (upon all conflicts has been resolved)
(repeat this process until all commits are rebased)
```

##### Rebase for cleaning history of a branch

To combine the last 10 commits into one

```sh
git rebase HEAD~10 -i
```

##### Rebase from the first commit

```sh
git rebase -i --root
```

##### Checking the current commit during a rebase process

```sh
git rebase --show-current-patch
```

##### To rebase and test every rebased commits

```sh
git rebase -i origin/master --exec "make test"
```

Note that the rebase stops when the unit tests failed.

##### Checking a diffs after a rebase

Suppose `feature_branch` was branched out from `origin/master~10`,

```sh
git range-diff origin/master~10 origin/feature_branch origin/master feature_branch
```

##### Split an existing commit

1. Use `git rebase -i <commit-sha>` and edit the commit in question.
2. Then, use `git reset HEAD~` to un-stage all the changes of that commit.
3. Create whatever commit(s) required.
4. If the remaining changes should be remained in the original commit, use `git
   commit -c ORIG_HEAD`.
5. `git rebase --continue`

##### Rebase stacked branches

Stacked branches are branches branched out from another branch. For example,
`feature1` is branched out from `main` and `feature2` is branched out from
`feature1`.

To rebase `feature2` and `feature1` against the latest version of `main`,

```sh
git fetch
git checkout feature2
git rebase -i origin/main --update-refs
```

Note that the list of commits shown could affect the commits of `main` (thus,
effectively rebase `main` as well).

This behaviour can be enabled by default by

```sh
git config --global rebase.updateRefs true
```

## Add

##### Staging some parts of a file

```sh
git add -p
```

To further split a patch into smaller chunks, answer `s` can be used.

## Remove

##### To remove a file from git index but not from file system

```sh
git rm --cached $FILE
```

## Commit

##### Amending the HEAD commit with current staged changes

```sh
git commit --amend
```

or without changing the commit message of the HEAD commit

```sh
git commit --amend --no-edit
```

##### Fix a commit by adding a commit after and squash the commits in rebase

```sh
git commit -a --fixup=HEAD~3
git rebase --autosquash -i HEAD~5
```

This adds the latest changes to the last (latest) commit of the history and,
hence, the commit to be fixed becomes `HEAD~4`. The rebase operation will
shuffle the latest commit and put it right after `HEAD~4`.

##### Completing a merge with default commit message

```sh
git commit --no-edit
```

## Rollback

To rollback a particular file (abc.txt, for example) from the last commit (before it is pushed onto GitHub)

```sh
git reset --soft HEAD~
git reset HEAD abc.txt
git commit -m 'A new commit message.'
```

## Branches

##### To list branches and its latest commit

```sh
git branch -v
```

##### to create a branch

To create a branch from a particular commit

```sh
git branch feature_branch 7654321
```

##### to rename a branch

```sh
git branch -m old_branch_name new_branch_name
```

##### to describe a branch

This is useful as the description will be made into merge commit message.

```sh
git branch --edit-description feature1
```

##### Remove a branch

```sh
git branch --unset-upstream UserStory1
git branch -D UserStory1
git push origin -d UserStory1
```

To remove the deleted branch in other machines

```sh
git fetch --all --prune
```

##### To replace one branch with another

```sh
git checkout new-master
git merge -s ours master
git checkout master
git merge new-master
```

## Cleaning up

##### to clean-up working directory

To remove staged and un-staged files. (Clean working directory)

```sh
git reset HEAD
git clean -f
```

##### to clean-up garbage collector

Cleanup unnecessary files and optimise the local repository and prune loose objects

```sh
git gc --prune=now
```

To prune a remote (dry-run)

```sh
git remote prune --dry-run origin
```

To prune a remote (for real)

```sh
git remote prune origin
```

##### Remove unstaged files

```sh
git clean -f
```

##### To reset one file to the previous commit

```sh
git reset --hard HEAD~ path/to/file
```

## Bisect

To find out the commit where unit tests are broken

```sh
git bisect start
git bisect good good-commit-ref
git bisect bad bad-commit-ref
make test
git bisect good # if tests passed
```

Once the commit is found, use `git bisect reset` to exit the bisect mode.

## Stash

To stash unstaged and staged files

```sh
git stash
```

To stash unstaged, staged and untracked files

```sh
git stash -u
```

To stash unstaged, staged, untracked and ignored files

```sh
git stash -a
```

To stash only unstaged files

```sh
git stash -k
```

To drop the second stash

```sh
git stash drop stash@{1}
```

To show stats of the second stash

```sh
git stash show stash@{1}
```

To show code changes of the second stash

```sh
git stash show -p stash@{1}
```

To stage the current stash

```sh
git stash apply
```

## Submodule

##### To add a submodule

```sh
git submodule add https://github.com/alexhokl/library path/to/library
```

##### To add a submodule of specific branch

```sh
git submodule add -b your-branch https://github.com/alexhokl/library path/to/library
```

##### To retrieve submodules from a new clone

```sh
git submodule init
```

This adds the submodules defined in `.gitmodules` to `.git/config` without
actually pulling the code yet.

##### To update submodules

```sh
git submodule update
```

To update submodules and its submodules

```sh
git submodule update --recursive
```

To push changes from submodule, create a commit in the directory of submodule

```sh
git push --recurse-submodules=on-demand
```

##### To check status of all submodules

```sh
git submodule status
```

This lists the commit hashes of submodules recursively.

##### To execute for each submodule

```sh
git submodule forach git pull origin master
```

##### To deinit a submodule

```sh
git submodule deinit path/to/module
```

Use this command if the user does not want to have a local checkout of the
submodule in your working tree anymore.

It removes the whole `submodule` section from `.git/config` together with
their work tree (files).

To remove local modifications as well

```sh
git submodule deinit -f path/to/module
```

To remove all submodules

```sh
git submodule deinit -f --
```

##### To remove a submodule

1. Remove the submodule section from `.gitmodules`
2. Create a commit with the change
3. `git submodule deinit path/to/module`
4. `git rm --cached path/to/module`
5. `rm -rf path/to/module`
6. `rm -rf .git/modules/path/to/module`

## Tags

##### To add and push a tag

```sh
git tag my-tag-name && git push --tags
```

##### To remove a pushed tag

```sh
git push --delete origin my-tag-name
git tag --delete my-tag-name
```

##### To get the latest tag

```sh
git describe --abbrev=0 --tags
```

## GPG signature

##### To show the signature

```sh
git verify-commit -v HEAD
```

##### To show the raw signature

```sh
git verify-commit --raw HEAD
```

##### Troubleshooting

In case the following error message is show, there are two major possible cases.

```sh
error: gpg failed to sign the data
fatal: failed to write commit object
```

1. No non-expired sub-keys are found. (that is, the subkeys were expired.)
2. More than one subkeys are found and `gpg --status-fd=2 -bsau $MASTER_KEY_ID`
   does not know what to do. (Untested: There is a chance specifying sub key ID
   may work)

To get trace lines during commit,

```sh
GIT_TRACE=1 git commit -m temp
```

## Checkout

##### To checkout (revert) a file from a specific commit

```sh
git checkout 0432432432 path/to/file
```

The file will be in staged state. To unstage the file,

```sh
git restore --staged path/to/file
```

##### Remove old history

Assuming HEAD is at the commit where "history" begins

```sh
git checkout --orphan new_branch_name
```

## Revert

##### To revert a normal commit

```sh
git revert <sha-1 of the commit>
```

##### To revert a merge commit (or a merge)

```sh
git revert -m 1 <sha-1 of the merge commit>
```

## Rerere

- reuse recorded resolution
- [reference](https://git-scm.com/blog/2010/03/08/rerere.html)

`git rerere`

If you want to make sure a long lived topic branch will merge cleanly but don't want to have a bunch of intermediate merge commits. With rerere turned on you can merge occasionally, resolve the conflicts, then back out the merge. If you do this continuously, then the final merge should be easy because rerere can just do everything for you automatically.

This same tactic can be used if you want to keep a branch rebased so you don't have to deal with the same rebasing conflicts each time you do it. Or if you want to take a branch that you merged and fixed a bunch of conflicts and then decide to rebase it instead - you likely won't have to do all the same conflicts again.

To enable, `git config --global rerere.enabled true`.

When there is a merge conflict, `git rerere status` shows the files to have resolution to be recorded. `git rerere diff` shows the current status of the resoltion. Resolve the conflict as usual and the resolution will be recorded automatically. The resolution will be applied in the subsequent conflicts.

## Subtree

##### Moving history of a directory of one repository to another

```sh
cd repo1
git subtree split --branch split-feature --prefix directory-to-split
cd ../repo2
git checkout -b split-feature
git remote add -f upstream https://github.com/alexhokl/repo1
git merge --allow-unrelated-histories upstream/split-feature
```

## LFS

##### Moving large files to LFS

- install git lfs
- initialise with `git lfs install`

- within a repository, apply `git lfs track` to add files to `.gitattribute`

```sh
git lfs track "*.webp
```

## Configuration

##### To edit configuration

To edit system git config

```sh
git config --system --edit
```

To edit user git config (`$HOME/.gitconfig`)

```sh
git config --global --edit
```

To edit repository git config (`repo/.git/config`)

```sh
git config --global --edit
```

To list all configurations (including system, global and local)

```sh
git config --list
```

##### User setup

```sh
git config user.email alex@some.other.org
git config user.name alex.some.other.org
```

## Operators

- `~` selects the first parent of a commit
  - `HEAD~~` means the first parent of the first parent of `HEAD`
  - `HEAD~` is equivalent to `HEAD~1`
  - `HEAD~~~` is equivalent to `HEAD~3`
- `^` selects a parent of a commit
  - `^1` selects the first parent of a commit
  - `^2` selects the second parent of a commit (in case the specified commit is
    a merge commit) and that is the last comment of the branch being merged)
  - `^3` is invalid as a commit can almost have two parents

## Queries

### Logs

##### Last commits from the current HEAD

To show the last 10 commits

```sh
git logs -10
```

##### History of a line(s)

```sh
git log -L 1001,1001:SomeFolder/SomeFile.go
```

```sh
git log -L 1001,+10:SomeFolder/SomeFile.go
```

or in one line

```sh
git log --pretty=format:'%h %s [%ad] [%cn]' --no-patch -L 22,22:plugin/git.lua --date=short
```

##### History of a function

```sh
git log -L SomeFunctionName:SomeFolder/SomeFile.go
```

Note that modification of `.gitattributes` may be needed to make `git`
understand the language.

```sh
*.cs diff=csharp
```

##### Comparing branches

Assuming one is on branch `feature`, to show the commits only exist on the
branch comparing to `master`,

```sh
git log --oneline master..feature
```

or

```sh
git log --oneline master..
```

or

```sh
git log --oneline feature ^master
```

To show the commits exist on `master` but not on feature branch,

```sh
git log --oneline ..master
```

To show how two branches are related to each other

```sh
git log --graph feature_a...feature_b
```

##### To show changes of the last commit with a specified comment

```sh
git show :/'search term'
```

To show only a particular file

```sh
git show :/'search term' -- path/to/file
```

##### Showing commits excluding merge commits

```sh
git log --oneline --no-merges
```

##### Showing the first line of commit message only

```sh
git log --pretty=format:'%s'
```

##### Showing the detail of commit message (third line and after) only

```sh
git log --pretty=format:'%b'
```

##### Showing the SHA1 hash of commit only

```sh
git log --pretty=format:'%h'
```

##### Showing commits in chronological order

```sh
git log -n 20 --reverse
```

Note that commits are shown in reverse chronological order by default.

##### Commits from a user from certain time

```sh
git log --all --author=alexhokl --since='9am yesterday' --format=%s
```
### Commit

##### To show the SHA1 hash of a commit

```sh
git rev-parse origin/a-branch-name
```

To show the shorten version

```sh
git rev-parse --short origin/a-branch-name
```

##### To show the closest tag to a commit

```sh
git describe 0432432432
```

Note that this either shows the tag itself or the closest tag plus a suffix
with number commits on top of the tag.

### Diff

##### Comparing files with certain extensions

```sh
git diff -- '*.c' '*.h'
```

##### To show diff with more lines of context

```sh
git diff --unified=10
```

This show 10 lines instead of 3 (default) of context.

##### To show diff with file paths only

```sh
git diff --name-only
```

### Text search

##### Grep

To find a term in files with a specific extension

```sh
git grep search-term *.cs
```

To exclude files

```sh
git grep search-term -- ':!*Test[s].cs'
```

To find a term in a commit (not just the changes involved)

```sh
git grep search-term 04312432432
```

To find a term in a range of commits

```sh
git grep search-term $(git rev-list origin/master..origin/feature-branch)
```

To find a term in staged files

```sh
git grep --cached search-term
```

To show files involved the search term

```sh
git grep -l search-term
```

To show lines before and after

```sh
git grep -C 3 search-term
```

To show function name related to the result line

```sh
git grep -p search-term
```

### Remotes

```sh
git remote -v
```

To get the url of a remote

```sh
git remote get-url origin
```

To set the url of a remote

```sh
git remote set-url origin https://github.com/auther/repo
```

##### To show commits of the two diverging branches

```sh
git range-diff origin/master origin/branch-a origin/branch-b
```

##### To show the local reference changes

```sh
git reflog
```

Note that the log is only available on a local machine.

##### Retrieving git objects

```sh
git fetch origin
```

### Ignore

To check file `abc.txt` would be ignored

```sh
git check-ignore abc.txt
```

### Others

##### Lines count

```sh
git log --author="_Your_Name_Here_" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
```

## Troubleshooting

For example, to see what underlying commands are used in signing a commit,

```sh
GIT_TRACE=1 git commit -m 'temp'
```

## GitHub

##### Closing an issue

A comment with any of the following keywords:
`close`, `closes`, `closed`, `fixes` or `fixed`

##### Line endings

- [Dealing with line endings](https://help.github.com/articles/dealing-with-line-endings/)

##### Pull request

- [How to write the perfect pull request](https://github.com/blog/1943-how-to-write-the-perfect-pull-request)
- [Issue and Pull Request templates](https://github.com/blog/2111-issue-and-pull-request-templates)

