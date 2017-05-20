# Software Engineering

### Technical debts

##### Causes

- Inexperienced developers
- Insufficient or no code reviews
- Rushing for deadlines

##### Prevention

- Keep upgrading to the latest frameworks or libraries. It is likely that a cleaner way of writing the existing logics.
- Avoid using old technologies to build new projects.
- Add `TODO` to code to allow re-factoring later.

##### Debts

- Long method
- God object
- Tight coupling
- No unit test
- No documentation
- No code review
- No code comments
- Too many mutable variable
- Too much duplicated code
- Overly complicated logic

##### Others

- Run unit-tests before pushing any commit to source control
- Run unit-tests on each merge and push
- Even a commit is meant to be deployed immediately, it is better to make the commit onto a branch before merging it into master branch
- Requirements should be documented either in product or sprint (or both) backlog
- To name something (e.g. a variable) in code, avoid copy and paste without generalising and thinking of naming convention
- Check if any files should not be committed before creating a git commit
- Don't put un-related changes in to the same commit
