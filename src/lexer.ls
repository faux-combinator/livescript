/**
 * Lexes a piece of code
 *
 * @param Array<Array<String>> patterns
 *  formatted as is: [ [ regexp, name ], ... ]
 */
module.exports = (patterns, code) -->
  tokens = []
  :code while code
    code -= /^ +/ # skip whitespace

    # extract source property of the regexp to interpole it
    for [{source}, type] in patterns when code is //^(#{source})//
      value = that.1
      tokens.push {type, value}
      code.=substr value.length
      continue code
    throw new LexerError "unable to parse `#{code.substr 0, 15}`"
  tokens

class LexerError extends Error
