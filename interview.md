- [References](#references)
- [Interview](#interview)
  * [Setup](#setup)
  * [Selection principles](#selection-principles)
  * [The process](#the-process)
  * [A good team setup](#a-good-team-setup)
  * [Interview questions](#interview-questions)
  * [General approach](#general-approach)
  * [House-Tree-Person (HTP) test](#house-tree-person-htp-test)
  * [Other items](#other-items)
____

## References

- [The Guerrilla Guide to Interviewing (version
  3.0)](https://www.joelonsoftware.com/2006/10/25/the-guerrilla-guide-to-interviewing-version-30/)
- [The Joel Test: 12 Steps to Better
  Code](https://www.joelonsoftware.com/2000/08/09/the-joel-test-12-steps-to-better-code/)
- [The Pragmatic Engineer Test: 12 Questions on Engineering
  Culture](https://blog.pragmaticengineer.com/pragmatic-engineer-test/)
- [The Phone Screen](https://www.joelonsoftware.com/2006/10/24/the-phone-screen-2/)
- [Programmer Competency Matrix](http://sijinjoseph.com/programmer-competency-matrix/)
- [Preparing for the Systems Design and Coding
  Interview](https://blog.pragmaticengineer.com/preparing-for-the-systems-design-and-coding-interviews/)

## Interview

### Setup

- Have peer colleagues to interview or talk to them as well.
- Each interview should consist of one interviewer and one interviewee, in a room with a door that closes and a whiteboard.

### Selection principles

- Do not hire “maybes”.
- At the end of the interview, interviewer must be able make a sharp decision about the candidate, that is hire or not hire.
- Look for candidates who are
  - smart and
  - get things done
- Bad candidates
  - Smart but don’t Get Things Done
    - often have PhDs
    - usually able to point out the theoretical similarity between two widely divergent concepts
  - Get Things Done but are not Smart
    - will do stupid things seemingly without thinking about them and somebody else will have to come clean up their mess later
    - they soak up good people’s time

### The process

1. introduction
2. question about recent project candidate worked on
3. easy programming questions
4. pointer/recurring questions (or async questions in Javascript)
5. are you satisfied?
6. do you have any questions?


- Reassure candidates that interviewers are interested in how they go about solving problems, not the actual answer.
- Try to ask open-ended questions so that candidates get a chance to show off themselves.
- Make sure candidates explain things in layman terms.
- Look for candidates who have passion on their work
- Ask if the decision made by the interviewer were seemingly wrong, what would he/she do?
- 3 very easy programming questions to filter out stupid candidates. (note their timing as that is a good indicator for solving harder questions)
  - examples
    - Write a function that determines if a string starts with an upper-case letter A-Z
    - Write a function that determines the area of a circle given the radius
    - Add up all the values in an array
- In coding test, try to find bug(s) and ask them to find it out. Check their responses to see whether they could be over diplomatic in their answers.
- Always leave about five minutes at the end of the interview to sell the candidate on the company and the job.

### A good team setup

- Do you use source control?
- Can you make a build in one step?
  - otherwise, prone to errors
- Do you have continuous integration (make frequent builds)?
  - make sure everybody could work
- Do you have a bug database (issue tracker)?
- Do you fix bugs before writing new code?
  - the longer a developer wait to fix a bug, the costlier it is to fix
- Do you have an up-to-date schedule?
- Do you have a spec?
  - ensure better design and more manageable schedule
- Do programmers have quiet working conditions?
- Do you use the best tools money can buy?
  - including IDEs, build tools, debugging tools
- Do you have testers?
- Do new candidates write code during their interview?
- Do you do hallway usability (UX) testing?
- Do you do code review?

### Interview questions

- Ask the candidate about his/her hobbies and follow up with a question on
  asking them to design and implement a thing related to the hobby
  * look for safety and security concerns
  * look for quality control
- Ask the candidate about a simple binary search
- What are the major technical problem in your current and last job?
- What are the profiling tools you have used?
- What is the one thing that you like and one thing that you dislike about the
  engineering culture at your current (or previous) workplace?
- If you are given code of a legacy web application to maintain, how would you
  approach it if you need to understand it?
- present data of a couple of tables which are related to each other (such as
  work flow or other easier to understand concepts) and ask candidates to try to
  guess its usage
  * look for the ability to understand table relationships quickly
- how to count number of users of an API endpoint

### General approach

- whiteboarding can be useful for things like sketching out systems designs or
  it can be a handy way for people to explain their thinking on a problem
- it is important to give people a real problem to solve, regardless of the
  medium of the exercise. When you give people a real problem, you can get
  a better sense for how their brain works
- red flags of interviewee for interviewee
  * a lack of curiosity, not asking questions about the role, the company, the
    technology
  * candidates should spend time familiarising themselves with the company’s
    products and have some specific questions and ideas in mind
  * when someone gets really defensive about a question
- when the interview is over do not be afraid to give feedback on what candidates
  did well. Hopefully they can read between the lines and figure out what they
  did not do well.

### House-Tree-Person (HTP) test

- [basic interpretations](https://alexhokl.com/htp)

### Other items

- Travis CI doesn't do whiteboarding as the interviewers has already done their
  due diligence. Thus, the interview session is more about finding out how the
  candidate resolving conflicts and could be fitted into the team.
