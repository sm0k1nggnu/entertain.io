express   = require('express')
app       = express()
http      = require('http').Server(app)
io        = require('socket.io')(http)

module.exports = (gulp) ->
  gulp.task 'build:webserver', ->

    app.get '/', (req, res) ->
      res.sendFile(__projectdir + '/index.html')

    app.get '/feeds.json', (req, res) ->
      FeedParser = require("feedparser")
      request = require("request")
      req = request("http://feeds.wired.com/wired/index")
      feedparser = new FeedParser()
      req.on "error", (error) ->
      feedsCollection = []

      feedparser.on "end", (error) ->
        io.emit 'feedUpdate', feedsCollection

      feedparser.on "readable", ->
        stream = this
        item = undefined
        feedsCollection.push item while item = stream.read()


    app.use( express.static(__projectdir) )

    http.listen 63647, ->
      console.log "Server runs! -> localhost:63647"

    io.on 'connection', (socket) ->
      console.log "User Connected"
      socket.on 'disconnect', ->
        console.log "User disconnected"






