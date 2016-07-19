'use strict';

const parse = require('./').parse,
  expect = require('chai').expect,
  question = 'Question?',
  radio = '() answer',
  checkbox = '[] answer',
  range = '{1-2} left, right',
  rangeWithMiddle = '{1-2} left, middle, right';

describe('Quiz Text', function () {
  it('parses radio questions', function () {
    expect(parse(`${question}\n${radio}`)[0].question).to.equal(question);
  });

  it('parses checkbox questions', function () {
    expect(parse(`${question}\n${checkbox}`)[0].question).to.equal(question);
  });

  it('parses range questions', function () {
    expect(parse(`${question}\n${range}`)[0].question).to.equal(question);
  });
});
