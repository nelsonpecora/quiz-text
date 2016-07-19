/*
 * Quiz Text
 * ==========================
 *
 * Generates JSON-formatted quiz questions from plaintext
 */

QuizText
 = q:Question* { return q; }

Question
  = n:Words nl a:Answers {
    var obj = {
        question: n,
        type: a[0].type, // grab type from first answer
      };

    if (a[0].type === 'range') {
      obj.answers = a[0].answer;
    } else {
      obj.answers = a.map(obj => obj.answer);
    }

    // add properties for ranges
    if (a[0].leftText) {
      obj.leftText = a[0].leftText
    }
    if (a[0].middleText) {
      obj.middleText = a[0].middleText
    }
    if (a[0].rightText) {
      obj.rightText = a[0].rightText
    }

    return obj;
  }

Answers
 = (o:Option nl? { return o; })+

Option
 = Radio / Check / Range

// radio buttons
Radio
  = r:(CorrectRadio / OtherRadio) { return { answer: r, type: 'radio' }}

CorrectRadio
  = '(' ws? '*' ws? v:Words? ')' ws? w:Words {
    if (v) {
      return { name: w, value: v, correct: true };
    } else {
      return { name: w, value: w.toLowerCase(), correct: true }
    }
  }

OtherRadio
  = '(' ws? v:Words? ')' ws? w:Words {
    if (v) {
      return { name: w, value: v};
    } else {
      return { name: w, value: w.toLowerCase() }
    }
  }

// checkboxes
Check
  = c:(CorrectCheck / OtherCheck) { return { answer: c, type: 'checkbox' }}

CorrectCheck
  = '[' ws? '*' ws? v:Words? ']' ws? w:Words {
    if (v) {
      return { name: w, value: v, correct: true };
    } else {
      return { name: w, value: w.toLowerCase(), correct: true }
    }
  }

OtherCheck
  = '[' ws? v:Words? ']' ws? w:Words {
    if (v) {
      return { name: w, value: v};
    } else {
      return { name: w, value: w.toLowerCase() }
    }
  }

// range
Range
  = '{' ws? v:RangeValues ws? '}' t:RangeText {
    var obj = {
      type: 'range',
      answer: v,
      leftText: t.leftText,
      rightText: t.rightText
    };

    if (t.middleText) {
      obj.middleText = t.middleText
    }

    return obj;
  }

// 1,3-5 => [1, 3, 4, 5]
RangeValues
  = v:(RangeValue / RangeNumber)+ {
    return v.reduce(function (arr, val) {
      return arr.concat(val);
    }, []);
  }

// 1-5 => [1, 2, 3, 4, 5]
RangeValue
  = a:Numbers '-' b:Numbers {
    var arr = [],
      aa = parseInt(a, 10),
      bb = parseInt(b, 10);

    if (bb >= aa) {
      for (;(bb + 1) - aa; aa++) {
        arr.push(aa);
      }
    } else {
      for (;aa - (bb - 1); aa--) {
        arr.push(aa);
      }
    }

    return arr;
  }

RangeNumber
  = a:(Numbers) ',' ws? { return [parseInt(a, 10)]; }

RangeText
  = LeftRightMiddleText / LeftRightText

LeftRightMiddleText
  = ws? a:Words ',' ws? b:Words ',' ws? c:Words { return { leftText: a, middleText: b, rightText: c }; }

LeftRightText
  = ws? a:Words ',' ws? b:Words { return { leftText: a, rightText: b }; }

Words
  = w:(Word / ws)+ { return w.join(''); }

Word
 = l:(Letter / Number / qm / apos)+ { return l.join(''); }

Letter
 = [a-zA-Z]

Numbers
  = n:Number+ { return n.join(''); }

Number
  = [0-9]

qm "QuestionMark"
  = '?'

apos "Apostrophe"
  = '\''

nl "New line"
 = "\n"

ws "Whitespace"
 = ' '
