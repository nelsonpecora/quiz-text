'use strict';

const parse = require('./').parse,
  expect = require('chai').expect,
  question = 'Question?',
  radio = '() answer',
  checkbox = '[] answer',
  range = '{1-2} left, right',
  rangeWithMiddle = '{1-2} left, middle, right';

describe('Quiz Text', function () {
  it('parses checkbox questions', function () {
    expect(parse(`${question}\n${checkbox}`)[0].question).to.equal(question);
  });

  it('parses range questions', function () {
    expect(parse(`${question}\n${range}`)[0].question).to.equal(question);
  });

  describe('Radio', function () {
    const text = 'answer',
      answer = { name: text, value: text };

    it('parses question', function () {
      expect(parse(`${question}\n${radio}`)[0].question).to.equal(question);
    });

    it('parses single answer', function () {
      expect(parse(`${question}\n${radio}`)[0].answers).to.deep.equal([answer]);
    });

    it('parses multiple answers', function () {
      expect(parse(`${question}\n${radio}\n${radio}`)[0].answers).to.deep.equal([answer, answer]);
    });

    it('disregards whitespace', function () {
      expect(parse(` ${question} \n${radio}`)[0].question).to.equal(question);
      expect(parse(`${question}\n( ) answer`)[0].answers).to.deep.equal([answer]);
      expect(parse(`${question}\n()answer`)[0].answers).to.deep.equal([answer]);
      expect(parse(`${question}\n${radio} `)[0].answers).to.deep.equal([answer]);
    });
  });
});
