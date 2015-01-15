express                 = require 'express'
webserver               = express()
http                    = require('http').Server(webserver)
websocket               = require('socket.io')(http)
eventric                = require 'eventric'
eventric                = require 'eventric'
socketIORemoteEndpoint  = require 'eventric-remote-socketio-endpoint'
eventricMongoStore      = require 'eventric-store-mongodb'

class Server

  run: ->
    @_paramHandler = require('./helper/paramHandler')
    @_projectdir = "#{__dirname.replace('/src/server','')}/build/ui"

    # Get passed arguments and start server
    @_paramHandler.getArguments process
    .then (payload) ->
      http.listen payload.port, ->
        console.log "EntertainIO runs at: http://localhost:#{payload.port}"

    # Respond App
    webserver.get '/', (req, res) =>
      res.sendFile "#{@_projectdir}/index.html"

    # Handle static files
    webserver.use express.static @_projectdir

    @_readFeeds()
    @_initializeEventric()


    db = [{name:'jiha'}]

    websocket.on 'connection', (socket) ->
      console.log "USER CONNECTED"

      socket.on 'FeedContextGetFeeds', (func) ->
        func(db)

      socket.on 'FeedContextCreateFeed', () ->
        db.push {name:''}
        socket.broadcast.emit 'FeedContextFeedCreated'

      socket.on 'FeedContextRemoveAllFeeds', () ->
        db = [{}]
        socket.broadcast.emit 'FeedContextFeedsRemoved'

      socket.on 'FeedContextChangeFeedTitle', (payload) ->
        db[payload.feedId].name = payload.feedTitle
        socket.broadcast.emit 'FeedContextFeedTitleChanged', payload



  _readFeeds: ->
    @_reader  = require('./reader')( webserver: webserver, websocket: websocket )


  _initializeEventric: ->
    # eventric.log.setLogLevel "debug"
    eventric.addStore "mongodb", eventricMongoStore
    eventric.set "default domain events store", "mongodb"

    socketIORemoteEndpoint.initialize ioInstance: websocket, =>
      eventric.addRemoteEndpoint 'socketio', socketIORemoteEndpoint

      eventric.subscribeToDomainEvent (domainEvent) =>
        console.log "eventric subscribe to domain event"
        console.log domainEvent
        websocket.emit 'DomainEvent', domainEvent


module.exports = new Server