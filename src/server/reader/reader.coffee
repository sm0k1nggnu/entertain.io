FeedParser              = require "feedparser"
request                 = require "request"
feedContext             = require "../../context/feed"

class Reader
  constructor: (@modules) ->
    @modules.webserver.get '/feeds.json', (req, res) =>
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
        feedContext.initialize().then ->
          feedContext.command 'TestCommand'
        res.send feedsCollection
        @modules.websocket.emit 'feedUpdate', feedsCollection

      feedparser.on "readable", ->
        stream = this
        meta = @meta
        item = undefined
        while item = stream.read()
          feedsCollection.push item


module.exports = (modules) ->
  new Reader modules