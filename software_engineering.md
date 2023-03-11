- [Technical debts](#technical-debts)
- [Web App](#web-app)
  * [12-Factor App](#12-factor-app)
- [One Bite At A Time: Partitioning Complexity](#one-bite-at-a-time-partitioning-complexity)
- [10 ways to accelerate software development from Dave Thomas](#10-ways-to-accelerate-software-development-from-dave-thomas)
- [Product / Project Management](#product--project-management)
- [Quality Assurance and quality specialist](#quality-assurance-and-quality-specialist)
- [Analysis Paralysis](#analysis-paralysis)
- [Event Sourcing](#event-sourcing)
- [Microservices](#microservices)
- [Others](#others-1)
____

## Technical debts

##### Causes

- Inexperienced developers
- Insufficient or no code reviews
- Rushing for deadlines

##### Prevention

- Keep upgrading to the latest frameworks or libraries. It is likely that
  a cleaner way of writing the existing logics.
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
- Even a commit is meant to be deployed immediately, it is better to make the
  commit onto a branch before merging it into master branch
- Requirements should be documented either in product or sprint (or both)
  backlog
- To name something (e.g. a variable) in code, avoid copy and paste without
  generalising and thinking of naming convention
- Check if any files should not be committed before creating a git commit
- Don't put un-related changes in to the same commit

## Web App

### 12-Factor App

References

- [The Twelve-Factor App](https://12factor.net/)
- [12 Fractured
  Apps](https://medium.com/@kelseyhightower/12-fractured-apps-1080c73d481c)

##### [Codebase](https://12factor.net/codebase)

- If there are multiple codebases, it’s not an app – it’s a distributed system.
  Each component in a distributed system is an app, and each can individually
  comply with twelve-factor.
- Multiple apps sharing the same code is a violation of twelve-factor. The
  solution here is to factor shared code into libraries which can be included
  through the dependency manager.

##### [Dependencies](https://12factor.net/dependencies)

- An app never relies on implicit existence of system-wide packages.
  - for instance
    - no GAC dependency for a .NET application, or
    - no global packages for a node.js application
- An app uses a dependency isolation tool during execution to ensure that no
  implicit dependencies “leak in” from the surrounding system.
  - for instance
    - `virtualenv` in python
- An app does not rely on the implicit existence of any system tools.
  - for example
    - shelling out to ImageMagick or curl
  - if the app needs to shell out to a system tool, that tool should be vendored
    into the app.

##### [Config](https://12factor.net/config)

- Configuration of an app is everything that is likely to vary between deploys
  (staging, production, developer environments, etc).
- An app should not store config as constants in the code. Config varies
  substantially across deploys, code does not.
- A litmus test for whether an app has all config correctly factored out of the
  code is whether the codebase could be made open source at any moment, without
  compromising any credentials.
- An app stores config in environment variables. Environment variables are easy
  to change between deploys without changing any code; unlike config files,
  there is little chance of them being checked into the code repo accidentally;
  and, they are a language- and OS-agnostic standard.
- Sometimes apps batch config into named groups, such as the `development`,
  `test`, and `production` environments. This method does not scale cleanly: as
  more deploys of the app are created, new environment names are necessary, such
  as `staging` or `qa`. As the project grows further, more environments are
  added, resulting in a combinatorial explosion of config which makes managing
  deploys of the app very brittle.
- According to Kelsey Hightower's reference above
  - application should look for the environment variables rather than having
    `entrypoint.sh` to convert environment variables to a file and read by then
    application.
  - if reading a configuration is needed, it should be made optional and provide
    sane defaults.

##### [Backing Services](https://12factor.net/backing-services)

- A backing service is any service the app consumes over the network as part of
  its normal operation. Examples include datastores, messaging/queueing systems,
  SMTP services for outbound email, and caching systems.
- The code for a twelve-factor app makes no distinction between local and third
  party services. A deploy of app should be able to swap out a local database
  with one managed by a third party without any changes to the app’s code. Only
  the resource handle in the config needs to change.

##### [Build, release, run](https://12factor.net/build-release-run)

- An app uses strict separation between the build, release, and run stages.
- The release stage takes the build produced by the build stage and combines it
  with the deploy’s current config.
- Every release should always have a unique release ID, such as a timestamp of
  the release or an incrementing number. A release cannot be mutated once it is
  created. Any change must create a new release.

##### [Processes](https://12factor.net/processes)

- Twelve-factor processes are stateless and share-nothing. Any data that needs
  to persist must be stored in a stateful backing service, typically a database.

##### [Port binding](https://12factor.net/port-binding)

- An app exports HTTP as a service by binding to a port, and listening to
  requests coming in on that port.

##### [Concurrency](https://12factor.net/concurrency)

- Processes in the twelve-factor app take strong cues from the unix process
  model for running service daemons. Using this model, the developer can
  architect their app to handle diverse workloads by assigning each type of work
  to a process type. For example, HTTP requests may be handled by a web process,
  and long-running background tasks handled by a worker process.
- An individual VM can only grow so large (vertical scale), so the application
  must also be able to span multiple processes running on multiple physical
  machines.
- An app processes should never daemonize or write PID files. Instead, rely on
  the operating system’s process manager to manage output streams, respond to
  crashed processes, and handle user-initiated restarts and shutdowns.

##### [Disposability](https://12factor.net/disposability)

- Processes should strive to minimise startup time.
- Processes shut down gracefully when they receive a `SIGTERM` signal from the
  process manager. For a web process, graceful shutdown is achieved by ceasing
  to listen on the service port (thereby refusing any new requests), allowing
  any current requests to finish, and then exiting. Implicit in this model is
  that HTTP requests are short, or in the case of long polling, the client
  should seamlessly attempt to reconnect when the connection is lost.
- For a worker process, graceful shutdown is achieved by returning the current
  job to the work queue. For example, on RabbitMQ the worker can send
  a `NACK`. Implicit in this model is that all jobs are reentrant, which
  typically is achieved by wrapping the results in a transaction, or making the
  operation idempotent.
- According to Kelsey Hightower's reference above
  - in case an application requires database connection, exponential backoff and
    retry should be implemented to avoid dependency on specific ordering of
    startup of applications. If the connection cannot be made after a number of
    retries, an error message can be shown.

##### [Dev/prod parity](https://12factor.net/dev-prod-parity)

- Keep development, staging, and production as similar as possible
- An app is designed for continuous deployment by keeping the gap between
  development and production small.
  - Make the time gap small: a developer may write code and have it deployed
    hours or even just minutes later.
  - Make the personnel gap small: developers who wrote code are closely involved
    in deploying it and watching its behaviour in production.
  - Make the tools gap small: keep development and production as similar as
    possible.

##### [Logs](https://12factor.net/logs)

- An app never concerns itself with routing or storage of its output stream. It
  should not attempt to write to or manage logfiles. Instead, each running
  process writes its event stream, unbuffered, to `stdout`.
- In staging or production deploys, each process’ stream will be captured by the
  execution environment, collated together with all other streams from the app.
  The archival destinations are not visible to or configurable by the app, and
  instead are completely managed by the execution environment. Open-source log
  routers, such as Fluent, are available for this purpose.

##### [Admin processes](https://12factor.net/admin-processes)

- Run admin/management tasks as one-off processes

## One Bite At A Time: Partitioning Complexity

- See
  [post](https://www.facebook.com/notes/kent-beck/one-bite-at-a-time-partitioning-complexity/1716882961677894/)
- make sure the code is correct, then make it clean, then make it fast
- separate refactoring and logic change
- in case of changing an interface, change the code that this using that
  interface first before changing the implementation of the interface
- use TDD
- use the pattern of composed method; a method which composes of many method
  calls; this avoids a method contains too much logic
- use constants to replace complex computations to code other logics and make
  unit tests pass before getting back to replace that constant

## 10 ways to accelerate software development from Dave Thomas

- See
  [slides](http://yowconference.com.au/slides/yownights/SLIDES_YN201705DaveThomas_TenWays.pdf)
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
  - come up with a grid of common scenarios and its estimates so that a risk
    window could be constructed
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

## Product / Project Management

- [Engineering Productivity](https://medium.com/@skamille/engineering-productivity-b1ea12db02e4)
  - Breaking down the scope of projects to help your team ship frequently. An
    eye for the MVP, for sequencing work and for predicting likely risks and
    bottlenecks for project completion are the skills here. Project management
    is an important part of engineering leadership development. If the project
    does not cross teams or organisations, it is not necessary to have
    a professional project manager.
  - Balancing that product delivery with sustaining engineering so that you
    do not end up with code that cannot be maintained in the future. The amount
    you will invest here depends on the future certainty (like the stage of
    a startup)
  - Prioritizing, prioritizing, prioritizing. Implicit in the first two skills
    is the ability to figure out what is important, and prioritize it. If you
    over prioritize shipping, you might get a lot done for a while, and then
    slow down as the debt you have accumulated comes due. Over prioritize
    sustaining engineering and you don’t ship product. You may not start out
    with these instincts, but they can be developed, so don’t be afraid to start
    making judgment calls now and learning from the results.
- [Delivering on an architecture
  strategy](https://blog.thepete.net/blog/2019/12/09/delivering-on-an-architecture-strategy/)
  - By a sustainable balance between feature delivery and foundational
    architectural work by empowering teams with autonomy, and fostering a strong
    partnership between product and tech on within those teams.
  - To make coherent progress on architectural goals, teams also need to
    align behind a shared vision. The Strategic Architectural Initiatives
    framework delivers that alignment, allowing you to reap full benefit from
    your high-performing teams.
  - finding time for technical work
    - Besides feature work, architectural work is just as important to the
      success of a product. It does not directly deliver product value, but
      rather delivers the foundation upon which that product value is created.
    - It can be challenging to get architectural work prioritized appropriately,
      particularly when the person prioritizing the team’s backlog does not know
      about this technical work, or does not fully understand the value of the
      work. It results in an imbalanced prioritization of feature work over
      architectural work.
    - Managing technical work and feature work as a single backlog is much more
      effective. Pulling from a single backlog gives a team more flexibility in
      prioritizing and load-balancing across different tasks, and is a natural
      fit for teams that are product-oriented, as opposed to project-oriented.
    - Reserving a percentage of capacity for technical debt work or creating
      a new team for technical work does not work efficiently in a long run.
  - Enabling a balanced backlog
    - Product-oriented teams
      - When a product manager trusts that the engineers on the team have the
        interest of the product at heart, they also trust the engineer’s
        judgment when adding technical tasks to the backlog and prioritizing
        them. This enables the balanced mix of feature and technical work.
        However, this is only true if the team are empowered to manage their own
        backlog; if the team has autonomy.
    - Autonomous teams
      - Empowering teams to make tactical decisions.
      - Empowering teams to make decisions locally is only helpful if they also
        understand the broader context.
    - Aligned autonomy
  - Connecting technical work to business outcomes
    - A technical strategy does not exist in isolation. It should be in service
      of broader product- or business-level objectives. For example, a technical
      strategy to accelerate deployments might be driven by a product objective
      of responding more rapidly to feature requests from customers. Put another
      way, the technical strategy should be aligned with the business
      objectives, and one should be concerned if the technical work cannot be
      easily connect back to a broader business goal.
    - A technical strategy provides the “what”, but we also need the “how”.
      That is where an architectural initiative comes in, laying out the
      specifics of an architectural change which will move a technical strategy
      forward.
  - Strategic Architectural Initiatives
    - By stating the current state, the target state (within a year, two years
      or 5 years), and the next steps (a not so clear "how" to allow teams to
      figure out their own "how").
    - Deconstructing an initiative into Current State, Target State, and Next
      Steps ensures that people filling in the gaps for all the types of
      thinkers that need to get behind the initiative. Target State helps Doers
      to see beyond the tactical stuff that they tend to focus on, towards the
      broader strategy. Current State reminds Dreamers of the reality today,
      rather than what they think it should be in the future. Next Steps allow
      everyone to connect the dots between where we are today and where we want
      to get to, and ensure that the initial activities kicked off in pursuit of
      our strategy are coordinated and coherent.
    - [Creating and sharing Strategic Architectural
      Initiatives](https://blog.thepete.net/blog/2020/01/09/creating-and-sharing-strategic-architectural-initiatives/)
- [Gaining insight and preventing misalignment without
  micromanaging](https://leaddev.com/culture-engagement-motivation/gaining-insight-and-preventing-misalignment-without-micromanaging)
  - Introducing a monthly status update meeting when
    - You have a critical area that has some misalignment between the
      participants. This can happen when there is a disagreement across product,
      engineering management, and/or the tech leads, or among partner teams
      working on a project.
    - You have a manager who is not getting into the details enough and needs
      some forcing function to get themselves (and their team) organized. They
      should not only just have status updates, but have status updates that
      they can explain every month.
    - You have a strategic area where there is some uncertainty about where you
      should be going. You are learning new information month over month that
      can change the project focus and direction, and you need to hear about
      project status, but also how the team is taking in new information to
      inform future work.
- [Five Ways to Optimise Your Team Performance - Without having to go full Agile
  mode](https://medium.com/@danielapetruzalek/five-quick-wins-to-optimise-your-team-performance-21745a348c82)
  - Ticket creation
    - When passing a ticket from one stage to another, it’s important to remove
      yourself from the ticket so everyone know that they can pick them up to
      work on them. The whole process should be thought in a way that the
      tickets are independent from the person that wrote them or have worked on
      that particular task in the past.
  - Ticket template
    - https://gist.github.com/danicat/854de24dd88d57c34281df7a9cc1b215
    - Context
      - A brief description of what the feature or problem is. Telling how it
        worked before and how is supposed to work is a good thing. Also, include
        any reference material that is required for understanding the whole
        picture. It is not necessary to copy the whole scoping document here (if
        you have one), but also just linking to the scoping document without
        explaining anything is not a good practice. Ideally the ticket is self
        contained and the reference material is just for further clarification.
    - To Do
      - A list of items to be done in the ticket. Keep them small and self
        contained. If you have more than 4 items to be done in the same ticket
        it is a strong signal it must be broken down into smaller tasks.
    - Definition of Done
      - Ideally they would be a list that follow closely the To Do list above,
        to make sure every required was implemented correctly. It is not so
        useful to explain here how to test, but it is really important to tell
        what to test. Both happy and sad paths. Ideally anyone from the team
        should be able to test it, even non developers like the Product Manager.
  - Definition of Ready
    - The state when a ticket is ready to be worked on
  - Spike ticket
    - ticket for research or work with uncertainty
    - resist the temptation of implementing the spike ticket during the spike
      process
    - time-box should be applied
- [Independence, autonomy, and too many small
  teams](https://kislayverma.com/organizations/independence-autonomy-and-too-many-small-teams/)
  - autonomous team
    - aka two pizza team
    - to minimise communication between multiple teams and empowering a single
      team to be in complete control of delivering customer value
    - before this idea, teams were orangised as backend, UI, DBA, Ops, etc and
      it requires a lot of communication and alignment
    - a single team would be given the entirety of the problem statement and the
      tools it needed to solve it
    - this idea will go wrong if the teams are sliced into too small a problem
      space where it introduces dependency on other teams
      - an example is that what a team delivers is not valuable by itself
      - or the team’s work is not tied to a business objective any longer, so it
        gets tied to tightly defined execution scopes
    - collaboration is good in ideation and brainstorming but it is extremely
      costly once we reached the execution phase
    - [Amdahl’s law](https://en.wikipedia.org/wiki/Amdahl%27s_law) puts a finite
      upper limit on the increased output when an extra worker is added into the
      mix
    - if the outputs of our teams are arranged sequentially, they are not
      autonomous in delivery, no matter how independent they might be in their
      day to day work
    - a team that is authorized to solve a customer problem using any means at
      its disposal in essence owns the entire “pipeline” of tasks that need to
      be done
    - a team is autonomous when it “delivers value to the customer”
      independently
    - The core idea behind autonomy is not arranging teams to maximize outputs
      of steps in the value chain, but defining value chains in such a way that
      a single, tight-knit team can be unleashed upon it. Every team has to
      define its output in terms of customer success because that’s how the
      organizational boundary is drawn
- [Building an Effective Partnership Between Product
  & Engineering](https://www.platohq.com/resources/building-an-effective-partnership-between-product-engineering-666854236)
  by Paulo André
  - The organizational design should fundamentally be cross-functional and
    should include product, design, engineering, and data unless you have really
    strong reasons for a functional setup.
  - Alignment starts at the top: heads of product and engineering need to be
    (and remain) on the same page at all times. Nip issues in the bud, set and
    manage expectations continuously at that level and always overcommunicate.
    Make that part of the culture and ensure it downstream.
  - Culture of accountability and ownership: don't tolerate blame games.
    Everyone is trying to figure it out. At all levels (again, starting at the
    top), Engineering must understand the priorities, and Product must
    understand the trade-offs. If this is not solid, nothing else is.
  - Pursue the culture of objectivity and participation: remove gut feeling and
    opinion as much as possible. Experimentation and data level the playing
    field and democratize it, so everyone can contribute with ideas regardless
    of who they are.
  - Beware of [maker's schedule](http://www.paulgraham.com/makersschedule.html)

## Quality Assurance and quality specialist

Ref: [Faster, better, stronger: Building a high quality
product](https://www.thoughtworks.com/insights/blog/faster-better-stronger-building-high-quality-product)

- There is no work flow status of `QA testing`. Instead, the testing is embedded
  in the implementation. That means, implementation is not done and the
  developer should not take another task until testing is completed. Thus, the
  developer must ensure that the story is passed to an available QA. This forced
  handover facilitates direct communication. The QA receives valuable context
  from the developer; and the developer can make use of the conversation with
  the QA to check whether all the acceptance criteria of a particular story are
  actually fulfilled. This conversation is already a big win for quality.
- It is best when QAs and BAs are sitting side by side. When they work together
  on requirements and present them together to the team in short planning
  meetings. In this way, the knowledge about requirements (including "edge
  cases" and "sad paths") can be shared with the entire team before
  implementation. The QAs can be sure that the most important "sad paths" are
  already considered for the implementation and thus, also automatically tested
  for regression. In this way, the effort for manual testing is significantly
  reduced. In contrast to the code-freeze test under time pressure, we’re
  introducing our products with substantially better quality and much earlier to
  the market. The most cost effective way to detect defects as early as possible
  and deliver high quality right from the start is when drafting the
  requirements and analyzing the stories — and not only while testing.
- To increase quality from the beginning, every commit goes to production.
  Setting this rule increases the quality: When QAs are no longer the last
  guardians of possible mistakes, developers spend more time making sure that
  their tests cover the most important things. And as QAs are the experts for
  testing, the push-and-pull relationship between developers and QAs is reversed
  by this new rule. Previously, tickets have been pushed to the QAs for testing.
  Now, developers are asking QAs for advice on how best to structure the tests
  — especially before implementation.
- Enable new features in a very controlled manner using Feature Toggles.
- Pair programming helps to avoid slip ups - which are bound to happen
  sometimes. An effective damage control is the "pairing" of two people, mostly
  developers. But slip ups are not the only motivation for pairing. Do you know
  the "aha moment" that you have when you have tried something new and
  understood how something works? We try to make it as easy as possible for the
  team to experience such moments by "trying out" (= deliberately provoking
  mistakes) — and talking within the pair about it!
- Quality Specialists are usually the link between developers and business, we
  connect people and their perspectives, we help to build a culture of trust.
  Those are the small things that make up a great culture, and we Quality
  Specialists are usually in the middle of it.

## Analysis Paralysis

- it typically manifests itself through the waterfall model with exceedingly
  long phases of project planning, requirements gathering, program design, and
  data modeling, which can create little or no extra value by those steps and
  risk many revisions
- it can occur when there is a lack of experience on the part of workers such as
  systems analysts, project managers or software developers, and could be due to
  a rigid and formal organizational culture
- indecision in businesses is usually the result of not enough people acting or
  speaking up about the inefficiencies of the company
- Agile software development methodologies explicitly seek to prevent analysis
  paralysis, by promoting an iterative work cycle that emphasizes working
  products over product specifications

## Event Sourcing

#### References

- [Event Sourcing - Martin
  Fowler](https://martinfowler.com/eaaDev/EventSourcing.html)
- [Event Modelling](https://eventmodeling.org/)
- [Event Modelling: What is
  it?](https://eventmodeling.org/posts/what-is-event-modeling/)

#### Event Modelling

Event Modelling is a method of describing systems using an example of how
information has changed within them over time. Specifically this omits transient
details and looks at what is durably stored and what the user sees at any
particular point in time. These are the events on the timeline that form the
description of the system.

Due to storage is getting cheaper, the ability to be able to keep a history of
all that has happened allows systems to be more reliable by means of audit and
specification by example that literally translates to how the system is
implemented. We also have enough storage to have a cache of different views into
what has happened in the system.

## Microservices

#### References

- [Design Microservice Architectures the Right
  Way](https://www.youtube.com/watch?v=j6ow-UemzBc)

#### Tricks

- Number of adopted languages cannot be too many
- Generated code is okay
  - example
    - generate API from Swagger
    - generate clients from Swagger
    - generate mock client
- if event log may not be source of truth, using database sometimes is okay
- each service own its database
  - no other service is allowed to connect to the database
  - other services use only the service interface (API or events)
- use events over APIs
  - promoting asynchronous communications
  - consumers need to implement idempotency
- use of feature flag
  - so that features can be deployed and tested for a short while before
    releasing

## Others

- Always instrumenting the app; for instances, time taken of API calls or time
  taken for SQL queries
- Keep variables immutable especially those in a loop
- [Incident Review and Postmortem Best
  Practices](https://blog.pragmaticengineer.com/postmortem-best-practices/)
