require! {'../src/lexer': 'lex'}

export function test-lexer(test)
  const
    eq-token = type: 'eq' value: '='
    dash-token = type: 'dash' value: '-'
    under-token = type: 'under' value: '_'

  let
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

  let
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

  let
    rules = []

    test.throws -> lex(rules, 'anything')

  let
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
