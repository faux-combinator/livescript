require! {'../src/lexer': 'lex'}

const
  eq-token = type: 'eq' value: '='
  dash-token = type: 'dash' value: '-'
  under-token = type: 'under' value: '_'

export function test-lexer-basic(test)
  const rules = [
    * /=/ 'eq'
  ]

  test.deep-equal lex(rules, '='), [eq-token],
    "can parse basic stuff"

  test.deep-equal lex(rules, '=='), [eq-token, eq-token],
    "can parse multiple occurences"

  test.deep-equal lex(rules, '= ='), [eq-token, eq-token],
    "can parse multiple, space-separated occurences"

  test.deep-equal lex(rules)('='), [eq-token],
    "lex is curried"

  test.done!

export function test-lexer-many(test)
  const rules = [
    * /=/ 'eq'
    * /-/ 'dash'
    * /_/ 'under'
  ]

  test.deep-equal lex(rules, '='), [eq-token],
    "multiple rules can find first"

  test.deep-equal lex(rules, '-'), [dash-token],
    "multiple rules can find first"

  test.deep-equal lex(rules, '_'), [under-token],
    "multiple rules can find first"

  test.deep-equal lex(rules, '=-_'), [eq-token, dash-token, under-token],
    "multiple rules can match all"

  test.deep-equal lex(rules, '=  - _'), [eq-token, dash-token, under-token],
    "multiple rules can match all"

  test.done!

export function test-lexer-fail(test)
  rules = []

  test.throws -> lex(rules, 'anything')

  test.done!


export function test-lexer-capture(test)
  rules = [
    * /[a-z]+/ 'id'
  ]

  test.deep-equal lex(rules, 'abc def'), [
    * type: 'id' value: 'abc'
    * type: 'id' value: 'def'
  ], "captures values correctly"
  test.done!

/*
# TODO: implement/add tests for [ 'x', 'y', function($val){} ] form
*/
