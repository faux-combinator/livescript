require! {'../src/lexer': 'lex'}

export function test-lexer(test)
  const eq-token = type: 'eq' value: '='

  let
    rules = [
      [ /=/ 'eq' ]
    ]

    test.deep-equal lex(rules, '='), [eq-token], "can parse basic stuff"

  test.done!
