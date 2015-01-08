express                 = require 'express'
app                     = express()
http                    = require('http').Server(app)
io                      = require('socket.io')(http)
eventric                = require "eventric"
eventricMongoStore      = require "eventric-store-mongodb"


class Server
  run: ->
    @_paramHandler = require('./helper/paramHandler')
    @_paramHandler.getArguments process
    .then (payload) ->
      http.listen payload.port, ->
        console.log "EntertainIO runs at: http://localhost:#{payload.port}"

    @_projectdir = "#{__dirname.replace('/src/server','')}/build/ui"

    # Respond App
    app.get '/', (req, res) =>
      res.sendFile "#{@_projectdir}/index.html"

    # Handle static files
    app.use express.static @_projectdir

    @readFeeds()


  readFeeds: ->
    @_reader  = require('./reader')
      app: app
      io: io


  initializeEventric: ->
    eventric.log.setLogLevel "debug"
    eventric.addStore "mongodb", eventricMongoStore
    eventric.set "default domain events store", "mongodb"

    feedContext = require '../context/feed'
    feedContext.initialize()

    io.on 'connection', (socket) ->
      socket.on 'createFeed', ->
        feedContext.command("CreateFeed",
            caption: "Foo"
        )

    feedContext.subscribe "projection:Feeds:changed", (event) ->
      console.log "Feeds Projection Changed"
      feedContext.query "getAllFeeds"
      .then (feeds) ->
        console.log feeds
        io.emit 'mongoFeeds', feeds



module.exports = new Server