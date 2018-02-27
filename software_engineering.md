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
- An app stores config in environment variables. Environment variables are easy to change between deploys without changing any code; unlike config files, there is little chance of them being checked into the code repo accidentally; and, they are a language- and OS-agnostic standard.
- Sometimes apps batch config into named groups, such as the `development`, `test`, and `production` environments. This method does not scale cleanly: as more deploys of the app are created, new environment names are necessary, such as `staging` or `qa`. As the project grows further, more environments are added, resulting in a combinatorial explosion of config which makes managing deploys of the app very brittle.

##### [Backing Services](https://12factor.net/backing-services)

- A backing service is any service the app consumes over the network as part of its normal operation. Examples include datastores, messaging/queueing systems, SMTP services for outbound email, and caching systems.
- The code for a twelve-factor app makes no distinction between local and third party services. A deploy of app should be able to swap out a local database with one managed by a third party without any changes to the app’s code. Only the resource handle in the config needs to change.

##### [Build, release, run](https://12factor.net/build-release-run)

- An app uses strict separation between the build, release, and run stages.
- The release stage takes the build produced by the build stage and combines it with the deploy’s current config.
- Every release should always have a unique release ID, such as a timestamp of the release or an incrementing number. A release cannot be mutated once it is created. Any change must create a new release.

##### [Processes](https://12factor.net/processes)

- Twelve-factor processes are stateless and share-nothing. Any data that needs to persist must be stored in a stateful backing service, typically a database.

##### [Port binding](https://12factor.net/port-binding)

- An app exports HTTP as a service by binding to a port, and listening to requests coming in on that port.

##### [Concurrency](https://12factor.net/concurrency)

- Processes in the twelve-factor app take strong cues from the unix process model for running service daemons. Using this model, the developer can architect their app to handle diverse workloads by assigning each type of work to a process type. For example, HTTP requests may be handled by a web process, and long-running background tasks handled by a worker process.
- An individual VM can only grow so large (vertical scale), so the application must also be able to span multiple processes running on multiple physical machines.
- An app processes should never daemonize or write PID files. Instead, rely on the operating system’s process manager to manage output streams, respond to crashed processes, and handle user-initiated restarts and shutdowns.

##### [Disposability](https://12factor.net/disposability)

- Processes should strive to minimise startup time.
- Processes shut down gracefully when they receive a SIGTERM signal from the process manager. For a web process, graceful shutdown is achieved by ceasing to listen on the service port (thereby refusing any new requests), allowing any current requests to finish, and then exiting. Implicit in this model is that HTTP requests are short, or in the case of long polling, the client should seamlessly attempt to reconnect when the connection is lost.
- For a worker process, graceful shutdown is achieved by returning the current job to the work queue. For example, on RabbitMQ the worker can send a `NACK`.Implicit in this model is that all jobs are reentrant, which typically is achieved by wrapping the results in a transaction, or making the operation idempotent.

##### [Dev/prod parity](https://12factor.net/dev-prod-parity)

- Keep development, staging, and production as similar as possible
- An app is designed for continuous deployment by keeping the gap between development and production small.
  - Make the time gap small: a developer may write code and have it deployed hours or even just minutes later.
  - Make the personnel gap small: developers who wrote code are closely involved in deploying it and watching its behavior in production.
  - Make the tools gap small: keep development and production as similar as possible.

##### [Logs](https://12factor.net/logs)

- An app never concerns itself with routing or storage of its output stream. It should not attempt to write to or manage logfiles. Instead, each running process writes its event stream, unbuffered, to `stdout`.
- In staging or production deploys, each process’ stream will be captured by the execution environment, collated together with all other streams from the app. The archival destinations are not visible to or configurable by the app, and instead are completely managed by the execution environment. Open-source log routers, such as Fluent, are available for this purpose.

##### [Admin processes](https://12factor.net/admin-processes)

- Run admin/management tasks as one-off processes

### One Bite At A Time: Partitioning Complexity

- See [post](https://www.facebook.com/notes/kent-beck/one-bite-at-a-time-partitioning-complexity/1716882961677894/)
- make sure the code is correct, then make it clean, then make it fast
- separate refactoring and logic change
- in case of changing an interface, change the code that this using that
  interface first before changing the implementation of the interface
- use TDD
- use the pattern of composed method; a method which composes of many method calls; this avoids a method contains too much logic
- use constants to replace complex computations to code other logics and make
  unit tests pass before getting back to replace that constant

### 10 ways to accelerate software development from Dave Thomas

- See [slides](http://yowconference.com.au/slides/yownights/SLIDES_YN201705DaveThomas_TenWays.pdf)
- development velocity is constrained by testing velocity
- a healthy software development environment contains
  - small high performance teams
  - alignment on practice and tools
  - automated everything
- activity-based estimation
  - collect statistics of time spent of an activity
  - activities includes
    - class creation
    - method creation
    - API endpoint creation
    - product/data definition
    - business rule creation and documentation
    - storyboard creation
  - come up with a grid of common scenarios and its estimates so that a risk window could be constructed
    - the window will have a dimension story-based estimation
- use PowerPoint for fast prototyping
- express architecture in terms of APIs
- Document NoSQL stuff
- try to keep data immutable
- use batching whenever possible (like what salesforce does with their APIs)
- data conversion between clients are expensive
- use decision tables
  - ends up with lookup tables which are easy to check and understand
- provide generic query API modelled on SQL
- make read-only relational replicas of important data for fast reporting
- modify interface to control units using TCP/IP
- implement HTTP and ATOM interfaces to automation system
- testing should comprise of 30%-50% of development time
- use property based testing
  - [example in c#](https://www.codit.eu/blog/2017/09/28/property-based-testing-with-c/)
  - [FsCheck](https://github.com/fscheck/FsCheck) in C#
  - [GOPTER](https://github.com/leanovate/gopter) in Go
  - [JSVerify](http://jsverify.github.io/) in Javascript
  - [John Hughes - Testing the Hard Stuff and Staying Sane](https://www.youtube.com/watch?v=zi0rHwfiX1Q)
- in case of significant UI changes
  - freeze the code changes
  - ask other developers to test the UI and find stupid bugs
  - once it is stable, code selenium tests (e2e tests)

### Others

- Keep variables immutable especially those in a loop
