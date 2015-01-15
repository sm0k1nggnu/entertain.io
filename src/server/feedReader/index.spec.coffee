{expect} = require('chai')
FeedReader = require('./')

describe module.filename, ->
  it 'should have a working feedReader', ->
    new FeedReader [{url:'http://www.drlima.net/feed/'}], (feedItem) ->
      console.log feedItem
