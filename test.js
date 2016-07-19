'use strict';

var parse = require('./').parse,
  expect = require('chai').expect;

describe('Quiz Text', function () {
  it('parses questions', function () {
    var question = 'Is this a question?',
      val = question + '\n' + '( ) option';

    expect(parse(val)[0].question).to.equal(question);
  });
});
