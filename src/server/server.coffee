express                 = require 'express'
webserver               = express()
http                    = require('http').Server(webserver)
websocket               = require('socket.io')(http)
eventric                = require 'eventric'
eventric                = require 'eventric'
socketIORemoteEndpoint  = require 'eventric-remote-socketio-endpoint'
eventricMongoStore      = require 'eventric-store-mongodb'
FeedReader              = require './feedReader'

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

    # @_readFeeds()
    @_initializeEventric()

    @db = [{name:'jiha',url:'http://www.drlima.net/feed/',items:[]}]

    websocket.on 'connection', (socket) =>

      @feedReader = new FeedReader @db, (item, dbItem) ->
        dbItem.items.push item
        socket.broadcast.emit 'FeedContextUpdateDB', @db

      console.log "USER CONNECTED"

      socket.on 'FeedContextGetFeeds', (callback) =>
        console.log @feedReader.allItems
        callback(@db)

      socket.on 'FeedContextCreateFeed', () =>
        @db.push {name:'',url:'',items:[]}
        socket.broadcast.emit 'FeedContextFeedCreated'

      socket.on 'FeedContextRemoveAllFeeds', () =>
        @db.splice(0,@db.length)
        socket.broadcast.emit 'FeedContextFeedsRemoved'

      socket.on 'FeedContextChangeFeed', (payload) =>
        @db[payload.feedId].name = payload.feedTitle
        @db[payload.feedId].url = payload.feedURL
        socket.broadcast.emit 'FeedContextFeedTitleChanged', payload



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