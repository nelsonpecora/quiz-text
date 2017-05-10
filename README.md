# quiz-text

[![Greenkeeper badge](https://badges.greenkeeper.io/nelsonpecora/quiz-text.svg)](https://greenkeeper.io/)

[![CircleCI](https://circleci.com/gh/nelsonpecora/quiz-text.svg?style=svg)](https://circleci.com/gh/nelsonpecora/quiz-text)

💡Quick and easy markup for quizzes!

# Install

```
npm install --save quiz-text
```

# Usage

Loosely based on [Petr Trofimov's Quiztext](https://github.com/ptrofimov/quiztext), this is a library that allows you to write quizzes using a markdown-like syntax which gets parsed into JSON. It supports radio (one selection), checkbox (multi select), and range (one selection, with syntactical sugar) questions, and looks like this:

```
Question 1: Why would I use this?
( ) You want to easily write quizzes that can be parsed into JavaScript
(*) Some questions might have a right answer
(different-value) Answers might have different values than labels

What about checkboxes?
[ ] Write checkbox ("multi-select") questions with square brackets
[*] These can have...
[*] Multiple right answers, or just one
[*other-val] They can also have different values than labels

And Ranges? How cool are they on a scale of 1 to 10?
{1-10} Dad With a Rat Tail | Astronaut On A Skateboard
```

These would get parsed into friendly JSON:

```js
[{
  question: 'Question 1: Why would I use this?',
  type: 'radio',
  answers: [{
    name: 'You want to easily write quizzes that can be parsed into JavaScript',
    value: 'You want to easily write quizzes that can be parsed into JavaScript'
  }, {
    name: 'Some questions might have a right answer',
    value: 'Some questions might have a right answer',
    correct: true
  }, {
    name: 'Answers might have different values than labels',
    value: 'different-value'
  }]
}, {
  question: 'What about multi-select?',
  type: 'checkbox',
  answers: [{
    name: 'Write multi-select (colloquially "checkbox") questions with square brackets',
    value: 'Write multi-select (colloquially "checkbox") questions with square brackets'
  }, {
    name: 'These can have...',
    value: 'These can have...',
    correct: true
  }, {
    name: 'Multiple right answers, or just one',
    value: 'Multiple right answers, or just one',
    correct: true
  }, {
    name: 'They can also have different values than labels',
    value: 'other-val',
    correct: true
  }]
}, {
  question: 'And Ranges? How cool are they on a scale of 1 to 10?',
  type: 'range',
  leftText: 'Dad With a Rat Tail',
  rightText: 'Astronaut On A Skateboard'
  answers: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
}]
```

## Radio and Checkbox

Radio buttons and checkboxes are denoted by parenthesis `( )` and square brackets `[ ]`, respectively. Answers don't _need_ to be correct or incorrect, but you may denote one or more correct answers by putting an asterisk `*` inside the parenthesis/brackets.

**TIP:** Don't specify more than one correct answer for radio questions, unless you allow your users to select more than one answer in your UI. Radio questions are intended to be single-select, whereas checkbox questions are intended to be multi-select. Currently there's no difference in their parsed output, but this might change in a future major version.

You may optionally have a different value for an answer than the text to the right of the parenthesis/brackets. To do so, add those values inside them (_after_ the asterisk, for correct answers).

For multiple choice questions where you would select an answer and get a result of whether you selected a correct or incorrect answer, you may optionally have correct result text and incorrect result text fields. Correct result text is denoted by carets `^ ^`, and incorrect result text is denoted by less than symbols `< <`. These will come before the radio button answers.

```
Question
(* value1 ) Cool Label 1
(value2) Cool Label 2
```

```
Multiple choice question with correct and incorrect text
^That's the correct answer^
<Incorrect, the right answer was actually Cool Label 1<
(* value1 ) Cool Label 1
(value2) Cool Label 2
```

Don't worry about whitespace. All values and labels will be trimmed when parsed.

## Range

Range is similar to radio, but it's a syntactical sugar for specifying questions where the answers are simply a range between two numbers. They can go either direction, and you can also specify each number individually. Ranges are denoted by curly brackets `{ }` with pipe-delineated (`|`) text intended for the left side and right side (and optionally middle) of the question after them.

You may optionally have a `category` field that would be denoted by dashes (`-`). 

```
Simple one to five range
{1-5} Less | More

Reverse range, useful for doing different weighting in personality quizzes
{10-0} Cooler | Warmer

You can also add middle text
{1-5} Left | Center | Right

Mix and match commas and hyphens for weird ranges
{1, 1, 2, 3-5} Less | Fibonacci | More

A question with a category
{1-5} Less | More
-A Cool Category-
```

# Contributing

This is an ongoing project, and I'll add more fundamental quiz types as I think of them. The parser (`parser.pegjs`) uses [PEG.js](http://pegjs.org/) and gets compiled to `index.js` when testing (and with `npm run build`). If you find a bug, please submit a PR with a failing unit test (or write a new unit test that captures it) and I'll help diagnose the error.
