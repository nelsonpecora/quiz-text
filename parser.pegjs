/*
 * Quiz Text
 * ==========================
 *
 * Generates JSON-formatted quiz questions from plaintext
 */

{
  // array => string
  function join(array) {
    return array.join('');
  }

  // string => number
  function int(str) {
    return parseInt(str, 10);
  }

  // parse correct radio/checkbox answer
  function correct(v, w) {
    w = w.trim();
    if (v) {
      v = v.trim();
      return { name: w, value: v, correct: true };
    } else {
      return { name: w, value: w.toLowerCase(), correct: true }
    }
  }

  // parse other radio/checkbox answer
  function other(v, w) {
    w = w.trim();
    if (v) {
      v = v.trim();
      return { name: w, value: v};
    } else {
      return { name: w, value: w.toLowerCase() }
    }
  }
}

QuizText
 = q:Question* { return q; }

Question
  = n:HTML nl a:Answers {
    var obj = {
        question: n.trim(),
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

    // adds property of category if there is one
    if (a[0].category) {
      obj.category = a[0].category
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
  = '(' ws? '*' ws? v:Words? ')' ws? w:HTML { return correct(v, w); }

OtherRadio
  = '(' ws? v:Words? ')' ws? w:HTML { return other(v, w); }

// checkboxes
Check
  = c:(CorrectCheck / OtherCheck) { return { answer: c, type: 'checkbox' }}

CorrectCheck
  = '[' ws? '*' ws? v:Words? ']' ws? w:HTML { return correct(v, w); }

OtherCheck
  = '[' ws? v:Words? ']' ws? w:HTML { return other(v, w); }

// range
Range
  = '{' ws? v:RangeValues ws? '}' t:RangeText nl? c:Category? {
    var obj = {
      type: 'range',
      answer: v,
      leftText: t.leftText.trim(),
      rightText: t.rightText.trim()
    };

    if (t.middleText) {
      obj.middleText = t.middleText.trim()
    }

    if (c) {
      obj.category = c.category.trim()
    }

    return obj;
  }

// category
Category
  = ws? dash c:Words? dash { return { category: c }; }

// 1,3-5 => [1, 3, 4, 5]
RangeValues
  = v:(RangeValue / RangeNumber)+ {
    return v.reduce(function (arr, val) {
      return arr.concat(val);
    }, []);
  }

// 1-5 => [1, 2, 3, 4, 5]
RangeValue
  = a:Numbers ws? '-' ws? b:Numbers cm? ws? {
    var arr = [],
      aa = int(a),
      bb = int(b);

    // loop through ranges, either forward or backward
    // e.g. 1-5, 5-1 (inclusive)
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
  = a:Numbers cm? ws? { return [int(a)]; }

RangeText
  = LeftRightMiddleText / LeftRightText

LeftRightMiddleText
  = ws? a:HTML pipe ws? b:HTML pipe ws? c:HTML { return { leftText: a, middleText: b, rightText: c }; }

LeftRightText
  = ws? a:HTML pipe ws? b:HTML { return { leftText: a, rightText: b }; }

Words
  = w:(Word / ws / cm)+ { return join(w); }

Word
 = l:(Letter / Number / qm / apos)+ { return join(l); }

HTML
  = c:Char+ { return join(c); }

Char
  = ![\n|] c:. { return c; }

Letter
 = [a-zA-Z]

Numbers
  = n:Number+ { return join(n); }

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

cm "Comma"
  = ','

pipe "Pipe"
  = '|'

dash "Dash"
  = '-'
