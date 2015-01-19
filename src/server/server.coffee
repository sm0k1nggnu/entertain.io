express                 = require 'express'
webserver               = express()
http                    = require('http').Server(webserver)
websocket               = require('socket.io')(http)
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

    # Eventric Stuff
    @_initializeEventric()



    # Instance-DB
    @db = {
      feedSources: [{
        name: "WIRED - Top Stories"
        url: "http://feeds.wired.com/wired/index"
      }]
      feedItems: []
    }


    # Handle User SocketRequests after connection
    websocket.on 'connection', (socket) =>

      feedReader = new FeedReader @db.feedSources, (item, dbItem) =>
        @db.feedItems.push item
        socket.broadcast.emit 'FeedSourceContextAddedFeedItem', item

      socket.on 'FeedContextGetFeedItems', (callback) =>
        console.log "FeedContextGetFeedItems"
        callback(@db.feedItems)

      socket.on 'FeedContextGetFeedSources', (callback) =>
        console.log "FeedContextGetFeedSources"
        callback(@db.feedSources)

      socket.on 'FeedContextCreateFeedSource', () =>
        console.log "FeedContextCreateFeedSource"
        @db.feedSources.push {name:'',url:''}
        socket.broadcast.emit 'FeedContextFeedSourceCreated'


      socket.on 'FeedContextRemoveAllFeedSources', () =>
        console.log "FeedContextRemoveAllFeedSources"
        @db.feedSources.splice(0,@db.feedSources.length)
        socket.broadcast.emit 'FeedContextFeedSourceRemoved'


      socket.on 'FeedContextChangeFeedSource', (payload) =>
        console.log "FeedContextChangeFeedSource"
        @db.feedSources[payload.feedId].name = payload.feedTitle
        @db.feedSources[payload.feedId].url = payload.feedURL
        socket.broadcast.emit 'FeedContextFeedSourceTitleChanged', payload



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