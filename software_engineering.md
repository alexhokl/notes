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

### Web App

#### [12-Factor App](https://12factor.net/)

- If there are multiple codebases, it’s not an app – it’s a distributed system. Each component in a distributed system is an app, and each can individually comply with twelve-factor.
- Multiple apps sharing the same code is a violation of twelve-factor. The solution here is to factor shared code into libraries which can be included through the dependency manager.

##### [Codebase](https://12factor.net/codebase)

##### [Dependencies](https://12factor.net/dependencies)

##### [Config](https://12factor.net/config)

##### [Backing Services](https://12factor.net/backing-services)

##### [Build, release, run](https://12factor.net/build-release-run)

##### [Processes](https://12factor.net/processes)

##### [Port binding](https://12factor.net/port-binding)

##### [Concurrency](https://12factor.net/concurrency)

##### [Disposability](https://12factor.net/disposability)

##### [Dev/prod parity](https://12factor.net/dev-prod-parity)

##### [Logs](https://12factor.net/logs)

##### [Admin processes](https://12factor.net/admin-processes)

