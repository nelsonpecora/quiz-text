/*
 * Quiz Text
 * ==========================
 *
 * Generates JSON-formatted quiz questions from plaintext
 */

QuizText
 = q:Question* { return q; }

Question
 = n:Words nl a:Answers { return { question: n, answers: a };}

Answers
 = (o:Option nl? { return o; })+

Option
 = Radio // Check / Range

Radio
  = CorrectAnswer / OtherAnswer

CorrectAnswer
  = '(*' ws? v:Words? ')' ws? w:Words {
    if (v) {
      return { name: w, value: v, correct: true };
    } else {
      return { name: w, value: w.toLowerCase(), correct: true }
    }
  }

OtherAnswer
  = '(' ws? v:Words? ')' ws? w:Words {
    if (v) {
      return { name: w, value: v};
    } else {
      return { name: w, value: w.toLowerCase() }
    }
  }

Words
  = w:(Word / ws)+ { return w.join(''); }

Word
 = l:(Letter / Number / qm / apos)+ { return l.join(''); }

Letter
 = [a-zA-Z]

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

EOF
  = !.
