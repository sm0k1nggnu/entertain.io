expect = require('chai').expect
Feeds = require './'

describe module.filename, ->
  describe 'Handle Storage', ->
    it 'set passed data ', ->
      console.log Feeds.store().set 'Feed', []
      console.log Feeds.store().add 'Feed', 'foo'
      console.log Feeds.store().add 'Feed', 'asd'
      console.log Feeds.store().add 'Feed', 'feafea'
      console.log Feeds.store().get 'Feed'





