# # # #
# Require Modules
# #
express                 = require 'express'
app                     = express()
http                    = require('http').Server(app)
io                      = require('socket.io')(http)
FeedParser              = require "feedparser"
request                 = require "request"
eventric                = require "eventric"
eventricMongoStore      = require "eventric-store-mongodb"



# # # #
# Helper (Todo, move into helper-structur)
# #
getParamFromArg = (param) ->
  process.argv[process.argv.indexOf(param)+1]



# # # #
# Initial Variables
# #
__PORT = getParamFromArg '--port'
__projectdir = "#{__dirname.replace('/src/server','')}/build/ui"
__Environment = if __PORT is 8000 then "production" else "dev"





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
# Get Feeds
# #
app.get '/feeds.json', (req, res) ->
  feedsCollection = []
  req = request("http://www.drlima.net/feed/")

  feedparser = new FeedParser()
  req.on "error", (error) ->

  req.on "response", (res) ->
    stream = this
    return @emit("error", new Error("Bad status code"))  unless res.statusCode is 200
    stream.pipe feedparser
    return

  feedparser.on "end", ->
    res.send feedsCollection
    io.emit 'feedUpdate', feedsCollection

  
  feedparser.on "error", (error) ->
  # always handle errors

  feedparser.on "readable", ->
    stream = this
    meta = @meta # **NOTE** the "meta" is always available in the context of the feedparser instance
    item = undefined
    while item = stream.read()
      feedsCollection.push item





# # # #
# Eventric Feed Stuff
# #
if __Environment is "dev"
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