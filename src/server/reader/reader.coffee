FeedParser              = require "feedparser"
request                 = require "request"

class Reader
  constructor: (@modules) ->
    @modules.app.get '/feeds.json', (req, res) =>
      feedsCollection = []
      req = request("http://www.drlima.net/feed/")


      feedparser = new FeedParser()
      req.on "error", (error) ->


      req.on "response", (res) ->
        stream = this
        return @emit("error", new Error("Bad status code"))  unless res.statusCode is 200
        stream.pipe feedparser
        return


      feedparser.on "end", =>
        res.send feedsCollection
        @modules.io.emit 'feedUpdate', feedsCollection


      feedparser.on "error", (error) ->
      # always handle errors


      feedparser.on "readable", ->
        stream = this
        meta = @meta
        item = undefined
        while item = stream.read()
          feedsCollection.push item


module.exports = (app) ->
  new Reader(app)