express   = require('express')
app       = express()
http      = require('http').Server(app)
io        = require('socket.io')(http)

module.exports = (gulp) ->
  gulp.task 'build:webserver', ->

    app.get '/', (req, res) ->
      res.sendFile(__projectdir + '/index.html')

    app.get '/feeds.json', (req, res) ->
      feedsCollection = []
      FeedParser = require("feedparser")
      request = require("request")
      req = request("http://feeds.wired.com/wired/index")
      feedparser = new FeedParser()
      req.on "error", (error) ->


      # handle any request errors
      req.on "response", (res) ->
        stream = this
        return @emit("error", new Error("Bad status code"))  unless res.statusCode is 200
        stream.pipe feedparser
        return

      feedparser.on "end", ->
        console.log "end"
        console.log feedsCollection
        io.emit 'feedUpdate', feedsCollection

      feedparser.on "error", (error) ->


      # always handle errors
      feedparser.on "readable", ->
        # This is where the action is!
        stream = this
        meta = @meta # **NOTE** the "meta" is always available in the context of the feedparser instance
        item = undefined
        while item = stream.read()
          feedsCollection.push item

    app.use( express.static(__projectdir) )

    http.listen 63647, ->
      console.log "Server runs! -> localhost:63647"

    io.on 'connection', (socket) ->
      console.log "User Connected"
      socket.on 'disconnect', ->
        console.log "User disconnected"






