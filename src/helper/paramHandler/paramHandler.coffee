class ParamHandler
  all: (callback) ->

    process = 'src/server --port 8000 --env development'
    match = process.match /--[a-zA-Z]* ([a-zA-Z0-9]*)/g

    payload = {}

    match.map (found) ->
      parse = found.match(/--([a-zA-Z]*)\s/)
      payload[parse[1]] = found.replace parse[0], ''

    callback payload

    return



module.exports = new ParamHandler