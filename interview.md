#### References

- [The Guerrilla Guide to Interviewing (version 3.0)](https://www.joelonsoftware.com/2006/10/25/the-guerrilla-guide-to-interviewing-version-30/)
- [The Joel Test: 12 Steps to Better Code](https://www.joelonsoftware.com/2000/08/09/the-joel-test-12-steps-to-better-code/)
- [The Phone Screen](https://www.joelonsoftware.com/2006/10/24/the-phone-screen-2/)

### Interview

#### Setup

- Have peer colleagues to interview or talk to them as well.
- Each interview should consist of one interviewer and one interviewee, in a room with a door that closes and a whiteboard.

#### Selection principles

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

#### The process

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
- 3 very easy programming questions to filter out stupid candidates. (note their timing as that is a good indicator for solving header questions)
  - examples
    - Write a function that determines if a string starts with an upper-case letter A-Z
    - Write a function that determines the area of a circle given the radius
    - Add up all the values in an array
- In coding test, try to find bug(s) and ask them to find it out. Check their responses to see whether they could be over diplomatic in their answers.
- Always leave about five minutes at the end of the interview to sell the candidate on the company and the job.

#### A good team setup

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

#### Interview questions

- Ask the candidate about his/her hobbies and follow up with a question on
    asking them to design and implement a thing related to the hobby
  - look for safety and security concerns
  - look for quality control
- Ask the candidate about a simple binary search

#### House-Tree-Person (HTP) test

- [basic interpretations](https://alexhokl.com/htp)
