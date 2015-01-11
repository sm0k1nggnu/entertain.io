expect = require('chai').expect
Queue = require './'


describe "I", ->
  it 'should work ;)', ->
    Queue
    .loop [
      'www.feed-1.com'
      'www.feed-2.com'
    ]
    .job (item, next) ->
      console.log "get feed:", item
      setTimeout ->
        next()
      , 1000
    .done ->
      console.log "fertig"
    .times 2
    .run()