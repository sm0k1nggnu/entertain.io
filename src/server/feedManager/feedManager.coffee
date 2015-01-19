class FeedManager

  constructor : () ->
    @_db = {}

  store : () ->
    @

  set: (aggregate, value) ->
    @_db[aggregate] = value

  add: (aggregate, value) ->
    @_db[aggregate].push value

  get: (aggregate) ->
    @_db[aggregate]


module.exports = new FeedManager