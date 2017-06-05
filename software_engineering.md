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

##### [Codebase](https://12factor.net/codebase)

- If there are multiple codebases, it’s not an app – it’s a distributed system. Each component in a distributed system is an app, and each can individually comply with twelve-factor.
- Multiple apps sharing the same code is a violation of twelve-factor. The solution here is to factor shared code into libraries which can be included through the dependency manager.

##### [Dependencies](https://12factor.net/dependencies)

- An app never relies on implicit existence of system-wide packages.
  - for instance
    - no GAC dependency for a .NET application, or
    - no global packages for a node.js application
- An app uses a dependency isolation tool during execution to ensure that no implicit dependencies “leak in” from the surrounding system.
  - for instance
    - `virtualenv` in python
- An app does not rely on the implicit existence of any system tools.
  - for example
    - shelling out to ImageMagick or curl
  - if the app needs to shell out to a system tool, that tool should be vendored into the app.

##### [Config](https://12factor.net/config)

- Configuration of an app is everything that is likely to vary between deploys (staging, production, developer environments, etc).
- An app should not store config as constants in the code. Config varies substantially across deploys, code does not.
- A litmus test for whether an app has all config correctly factored out of the code is whether the codebase could be made open source at any moment, without compromising any credentials.
- An app stores config in environment variables.Env vars are easy to change between deploys without changing any code; unlike config files, there is little chance of them being checked into the code repo accidentally; and, they are a language- and OS-agnostic standard.

##### [Backing Services](https://12factor.net/backing-services)

##### [Build, release, run](https://12factor.net/build-release-run)

##### [Processes](https://12factor.net/processes)

##### [Port binding](https://12factor.net/port-binding)

##### [Concurrency](https://12factor.net/concurrency)

##### [Disposability](https://12factor.net/disposability)

##### [Dev/prod parity](https://12factor.net/dev-prod-parity)

##### [Logs](https://12factor.net/logs)

##### [Admin processes](https://12factor.net/admin-processes)

