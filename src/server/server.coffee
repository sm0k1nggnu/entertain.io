# # # #
# Require Modules
# #
express                 = require 'express'
app                     = express()
http                    = require('http').Server(app)
io                      = require('socket.io')(http)
eventric                = require "eventric"
eventricMongoStore      = require "eventric-store-mongodb"

paramHandler            = require('./helper/paramHandler')
reader                  = require('./reader')
  app: app
  io: io



# # # #
# Initial Variables
# #
__PORT        = undefined
__ENVIROMENT = undefined
__projectdir  = "#{__dirname.replace('/src/server','')}/build/ui"


# - Define Vars From ProcessArguments
paramHandler.getArguments process, (payload) ->
  __PORT        = payload.port  or false
  __ENVIROMENT = payload.env   or false


# # # #
# Server Stuff
# #
http.listen __PORT, ->
  console.log "EntertainIO runs at: http://localhost:#{__PORT}"

# Respond index.html
app.get '/', (req, res) ->
  res.sendFile "#{__projectdir}/index.html"

# Static files like css, js and images
app.use express.static __projectdir




# # # #
# Eventric Feed Stuff
# #
if __ENVIROMENT is "development"
  eventric.log.setLogLevel "debug"
  eventric.addStore "mongodb", eventricMongoStore
  eventric.set "default domain events store", "mongodb"

  feedContext = require '../context/feed'
  feedContext.initialize()


  io.on 'connection', (socket) ->
    console.log "User Connected"
    socket.on 'disconnect', ->
      console.log "User disconnected"

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
    return


# feedContext.initialize().then ->
#   feedContext.enableWaitingMode()
#   feedContext.subscribe "projection:Feeds:changed", (event) ->

#   #console.log('HI', event.projection.feeds);
#   feedContext.command("CreateFeed",
#     caption: "Foo"
#   ).then(->
#     feedContext.command "CreateFeed",
#       caption: "Bar"
#     return
#   ).then(->
#     feedContext.query "getAllFeeds"
#     return
#   ).then (feeds) ->
#     console.log "zee feeds", feeds
#     io.emit 'feeds', feeds
#     return
#   return


module.exports = app