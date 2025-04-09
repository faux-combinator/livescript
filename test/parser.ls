# grr, todo move this ucfirst somewhere...
ucfirst = -> it[0].toUpperCase() + it.slice(1)
Parser = require '../src/parser'

const
  lparen-token = type: 'lparen' value: '('
  rparen-token = type: 'rparen' value: ')'
  id-token     = type: 'id'     value: 'a'
  num-token    = type: 'num'    value: 5
  str-token    = type: 'str'    value: "a string here"

parse = (klass, ast) -> (new klass(ast)).parse!

export function test-parser-expect(test)
  class ExpectParser extends Parser
    parse: ->
      @expect 'lparen'
      @expect 'rparen'
      true

  let
    # LEX: () 
    ast = [lparen-token, rparen-token]
    test.deep-equal parse(ExpectParser, ast), true,
      "can parse basic stuff"

  let
    # LEX: (
    ast = [lparen-token]
    test.throws !->
      parse(ExpectParser, ast)

  test.done!

export function test-parser-maybe(test)
  class MaybeParser extends Parser
    parse: ->
      @expect 'lparen'
      val = @maybe 'id'
      @expect 'rparen'
      val?value ? true

    parse-id: -> @expect 'id'

  let
    # LEX: ()
    ast = [lparen-token, rparen-token]
    test.deep-equal parse(MaybeParser, ast), true,
      "can still parse basic stuff"

  let
    # LEX: (a)
    ast = [lparen-token, id-token, rparen-token]
    test.deep-equal parse(MaybeParser, ast), 'a',
      "can parse maybe rules"

  let
    # LEX: (5)
    ast = [lparen-token, num-token, rparen-token]
    test.throws !->
      console.log parse(MaybeParser, ast)

  test.done!

export function test-parser-one-of(test)
  class OneOfParser extends Parser
    cases = <[id num str]>
    parse: ->
      @one-of ...cases .value

    for let cases => ::"parse#{ucfirst ..}" = -> @expect ..

  let
    # LEX: a
    ast = [id-token]
    test.deep-equal parse(OneOfParser, ast), 'a',
      "oneOf can match the first case"

  let
    # LEX: 5
    ast = [num-token]
    test.deep-equal parse(OneOfParser, ast), 5,
      "oneOf can match the second case"

  let
    # LEX: "a string here"
    ast = [str-token]
    test.deep-equal parse(OneOfParser, ast), "a string here",
      "oneOf can match the third case"

  let
    # LEX: (
    ast = [lparen-token]
    test.throws !->
      parse(OneOfParser, ast)

  test.done!

export function test-parser-any-of(test)
  class AnyOfParser extends Parser
    parse: ->
      @any-of 'num'

    parse-num: -> @expect 'num' .value

  let
    # LEX:
    ast = []
    test.deep-equal parse(AnyOfParser, ast), [],
      "can parse an empty number of occurences"

  let
    # LEX: 5
    ast = [num-token]
    test.deep-equal parse(AnyOfParser, ast), [5],
      "can parse an empty number of occurences"

  let
    # LEX: 5 5 5
    ast = [num-token] * 3
    test.deep-equal parse(AnyOfParser, ast), [5 5 5],
      "can parse an empty number of occurences"

  test.done!

export function test-parser-many-of(test)
  class ManyOfParser extends Parser
    parse: ->
      @many-of 'num'

    parse-num: -> @expect 'num' .value

  let
    # LEX:
    ast = []
    test.throws !->
      parse(ManyOfParser, ast)

  let
    # LEX: 5
    ast = [num-token]
    test.deep-equal parse(ManyOfParser, ast), [5],
      "can parse an empty number of occurences"

  let
    # LEX: 5 5 5
    ast = [num-token] * 3
    test.deep-equal parse(ManyOfParser, ast), [5 5 5],
      "can parse an empty number of occurences"

  test.done!
