## Setup

### BASH completion

1. Get the completion file from `https://github.com/git/git/blob/master/contrib/completion/git-completion.bash`.
2. Copy the file to `/etc/bash_completion.d/` on Linux (on Mac, this requires a bit more work).
3. On Mac, source the file from the path in step 2 in `~/.bash_profile`.

## Concepts

- Git does not have a notion of "this commit was made on this branch".
- [GOTO 2019 • Knowledge is Power: Getting out of Trouble by Understanding Git • Steve Smith](https://www.youtube.com/watch?v=fHLcZGi3yMQ) - on `.git` directory

## Operations

Note that aliases used can be found in [.gitconfig](https://github.com/alexhokl/dotfiles/blob/master/.gitconfig).

### New repository

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

### Forking

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

### Rebase

##### Rebase for merge

To rebase a feature branch before merging into master (it involves re-writing the commits in the feature branch)

```sh
git fetch
git checkout feature_branch
git rebase -i origin/master

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

##### To rebase and test

```sh
git rebase -i origin/master --exec "make test"
```

Note that the rebase stops when the unit tests failed.

##### Checking a diffs after a rebase

Suppose `feature_branch` was branched out from `origin/master~10`,

```sh
git range-diff origin/master~10 origin/feature_branch origin/master feature_branch
```

### Commit

##### Amending the HEAD commit with current staged changes

```sh
git commit --amend
```

or without changing the commit message of the HEAD commit

```sh
git commit --amend --no-edit
```

##### Completing a merge with default commit message

```sh
git commit --no-edit
```

### Rollback

To rollback a particular file (abc.txt, for example) from the last commit (before it is pushed onto GitHub)

```sh
git reset --soft HEAD~
git reset HEAD abc.txt
git commit -m 'A new commit message.'
```

##### Branching

To create a branch from a particular commit

```sh
git branch feature_branch 7654321
```

##### Renaming a branch

```sh
git branch -m old_branch_name new_branch_name
```

##### Describing a branch

This is useful as the description will be made into merge commit message.

```sh
git branch --edit-description feature1
```

##### Cleanup working directory

To remove staged and un-staged files. (Clean working directory)

```sh
git reset HEAD
git clean -f
```

##### Cleanup

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

##### Remove a branch

```sh
git branch --unset-upstream UserStory1
git branch -D UserStory1
```

##### Remove unstaged files

```sh
git clean -f
```

##### To reset one file to the previous commit

```sh
git reset --hard HEAD~ path/to/file
```

##### Bisect

To find out the commit where unit tests are broken 

```sh
git bisect start
git bisect good your-parent-commit
git bisect run make test
```

##### Stash

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

##### Submodule

###### To add a submodule with an alias

```sh
git submodule add https://github.com/alexhokl/library path/to/library
```

###### To retrieve submodules from a new clone

```sh
git submodule init
```

This adds the submodules defined in `.gitmodules` to `.git/config` without
actually pulling the code yet.

###### To clone a repository and its submodules

```sh
git clone --recursive https://github.com/author/repo
```

###### To update submodules

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

###### To check status of all submodules

```sh
git submodule status
```

###### To execute for each submodule

```sh
git submodule forach git pull origin master
```

###### To deinit a submodule

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

###### To remove a submodule

1. `git submodule deinit path/to/module`
2. Remove the submodule section from `.gitmodules`

##### Tag

###### To add and push a tag

```sh
git tag my-tag-name && git push --tags
```

###### To remove a pushed tag

```sh
git push --delete origin my-tag-name
git tag --delete my-tag-name
```

##### To get the latest tag

```sh
git describe --abbrev=0 --tags
```

##### GPG signature

###### To show the signature

```sh
git verify-commit -v HEAD 
```

###### To show the raw signature

```sh
git verify-commit --raw HEAD
```

##### Revert

###### To revert a normal commit

```sh
git revert <sha-1 of the commit>
```

###### To revert a merge commit (or a merge)

```sh
git revert -m 1 <sha-1 of the merge commit>
```

##### Rerere (reuse recorded resolution) [reference](https://git-scm.com/blog/2010/03/08/rerere.html)

`git rerere`

If you want to make sure a long lived topic branch will merge cleanly but don't want to have a bunch of intermediate merge commits. With rerere turned on you can merge occasionally, resolve the conflicts, then back out the merge. If you do this continuously, then the final merge should be easy because rerere can just do everything for you automatically.

This same tactic can be used if you want to keep a branch rebased so you don't have to deal with the same rebasing conflicts each time you do it. Or if you want to take a branch that you merged and fixed a bunch of conflicts and then decide to rebase it instead - you likely won't have to do all the same conflicts again.

To enable, `git config --global rerere.enabled true`.

When there is a merge conflict, `git rerere status` shows the files to have resolution to be recorded. `git rerere diff` shows the current status of the resoltion. Resolve the conflict as usual and the resolution will be recorded automatically. The resolution will be applied in the subsequent conflicts.

##### Moving history of a directory of one repository to another

```sh
cd repo1
git subtree split --branch split-feature --prefix directory-to-split
cd ../repo2
git checkout -b split-feature
git remote add -f upstream https://github.com/alexhokl/repo1
git merge --allow-unrelated-histories upstream/split-feature
```

##### Remove old history

Assuming HEAD is at the commit where "history" begins

```sh
git checkout --orphan new_branch_name
```

##### Moving large files to LFS

- install git lfs
- initialise with `git lfs install`

- within a repository, apply `git lfs track` to add files to `.gitattribute`

```sh
git lfs track "*.webp
```

##### Configuration

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

### Queries

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

##### To show the SHA1 hash of a commit

```sh
git rev-parse origin/a-branch-name
```

To show the shorten version

```sh
git rev-parse --short origin/a-branch-name
```

##### Comparing files with certain extensions

```sh
git diff -- '*.c' '*.h'
```

##### To show diff with more lines of context

```sh
git diff --unified=10
```

This show 10 lines instead of 3 (default) of context.

##### To show the closest tag to a commit

```sh
git describe 0432432432
```

Note that this either shows the tag itself or the closest tag plus a suffix
with number commits on top of the tag.

##### Grep

To find a term in files with a specific extension

```sh
git grep search-term *.cs
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

##### Remotes

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

##### Branches

```sh
git branch -v
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

##### Ignore

To check file `abc.txt` would be ignored

```sh
git check-ignore abc.txt
```

##### Lines count

```sh
git log --author="_Your_Name_Here_" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
```

### GitHub

##### Closing an issue

A comment with any of the following keywords:
`close`, `closes`, `closed`, `fixes` or `fixed`

##### Line endings

- [Dealing with line endings](https://help.github.com/articles/dealing-with-line-endings/)

##### Pull request

- [How to write the perfect pull request](https://github.com/blog/1943-how-to-write-the-perfect-pull-request)
- [Issue and Pull Request templates](https://github.com/blog/2111-issue-and-pull-request-templates)
