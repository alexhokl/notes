To upload a local git repository onto GitHub, first create a repository on GitHub.
If the repository is dumped from another git remote,
```sh
git remote remove origin
```
To associate the repository with GitHub one,
```sh
git remote add origin https://github.com/alexhokl/example.git
git push -u origin master
```

In case of rolling-back a particular file (abc.txt, for example) from the last commit (before it is pushed onto GitHub).
```sh
git reset --soft HEAD~
git reset HEAD abc.txt
git commit -m 'A new commit message.'
```

To remove staged and un-staged files. (Clean working directory)
```sh
git reset HEAD
```

To rebase a feature granch before merging into master (it involves re-writing the commits in the feature branch)
```sh
git checkout feature_branch
git rebase master
git checkout master
git merge feature_branch
```

To combine the last 10 commits into one
```sh
git rebase -i HEAD~10
```

To check what commits were in a branch
```sh
git reflog
```

To remove a branch locally and its connection to remote.
```sh
git branch --unset-upstream UserStory1
git branch -D UserStory1
```

To check connection remote repositories
```sh
git remote -v
```

To check branches and its last commit
```sh
git branch -v
```

To get branch information from remote
```sh
git fetch origin
```

To create a branch from a particular commit
```sh
git branch feature_branch 7654321
```

To rename a branch
```sh
git branch -m old_branch_name new_branch_name
```

To create a stash with un-tracked files
```sh
git stash -u
```

Cleanup unnecessary files and optimize the local repository and prune loose objects
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

To edit system git config
```sh
git config --system --edit
```

To edit user git config
```sh
git config --global --edit
```
