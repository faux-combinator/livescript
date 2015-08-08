ucfirst = -> it[0].toUpperCase() + it.slice(1)

module.exports = class Parser
  (@tokens) ->

  expect: ->
    {type}:token = @tokens.shift!
    if it isnt type
      @error "Expected token #it, found #type"
    token

  maybe: ->
    tokens = [...@tokens] # dup
    try
      @"parse#{ucfirst it}"!
    catch
      @ <<< {tokens}
      false

  one-of: (...matchers) ->
    for matchers when @maybe ..
      return that
    @error "unable to match oneOf cases: #matchers"

  any-of: ->
    [that while @maybe it]

  many-of: -> [@maybe it; ...@any-of it]

  parse: -> ...

  error: -> throw new ParserError it

class ParserError extends Error
