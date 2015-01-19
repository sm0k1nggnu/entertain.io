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

    # @_readFeeds()
    @_initializeEventric()




    # @db = [{name:'jiha',url:'http://www.drlima.net/feed/',items:[]}]

    @db = {
      feedSources: [{
        name: "WIRED - Top Stories"
        url: "http://feeds.wired.com/wired/index"
      }]
      feedItems: []
    }



    websocket.on 'connection', (socket) =>

      # @feedReader = new FeedReader @db, (item, dbItem) ->
      #   # runs when new content found
      #   dbItem.items.push item
      #   # console.log @db
      #   socket.broadcast.emit 'FeedContextUpdateDB', "as"
      #   console.log "feadReader runned"
      #   return

      console.log "USER CONNECTED"

      socket.on 'FeedContextGetFeedSources', (callback) =>
        console.log "FeedContextGetFeeds"
        # console.log @feedReader.allItems
        callback(@db.feedSources)

      socket.on 'FeedContextCreateFeedSource', () =>
        console.log "FeedContextCreateFeed"
        @db.feedSources.push {name:'',url:''}
        socket.broadcast.emit 'FeedContextFeedSourceCreated'


      socket.on 'FeedContextRemoveAllFeedSources', () =>
        console.log "FeedContextRemoveAllFeeds"
        @db.feedSources.splice(0,@db.feedSources.length)
        socket.broadcast.emit 'FeedContextFeedSourceRemoved'


      socket.on 'FeedContextChangeFeedSource', (payload) =>
        console.log "FeedContextChangeFeed"
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