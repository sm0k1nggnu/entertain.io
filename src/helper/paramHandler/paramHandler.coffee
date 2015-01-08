class ParamHandler
  constructor: (@payload = {}) ->

  getArguments: (process, callback) ->
    match = process.argv.join(' ').match /--[a-zA-Z]* ([a-zA-Z0-9]*)/g
    match.map (found) =>
      parse = found.match(/-{1,2}([a-zA-Z]*)\s/)
      @payload[parse[1]] = found.replace parse[0], ''

    callback @payload


module.exports = new ParamHandler