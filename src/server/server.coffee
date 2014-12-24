express   = require('express')
app       = express()
http      = require('http').Server(app)
io        = require('socket.io')(http)
FeedParser = require("feedparser")
request = require("request")

getParamFromArg = (param) -> process.argv[process.argv.indexOf(param)+1]

__PORT = getParamFromArg '--port'
__projectdir = "#{__dirname.replace('/src/server','')}/build/ui"


# Start server
http.listen __PORT, ->
  console.log "EntertainIO runs at: http://localhost:#{__PORT}"


# Respond index.html
app.get '/', (req, res) ->
  res.sendFile "#{__projectdir}/index.html"


# Static files like css, js and images
app.use express.static __projectdir


app.get '/feeds.json', (req, res) ->
  feedsCollection = []
  req = request("http://www.drlima.net/feed/")
  # req = request("http://feeds.wired.com/wired/index")
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
    res.send feedsCollection
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

io.on 'connection', (socket) ->
  console.log "User Connected"
  socket.on 'disconnect', ->
    console.log "User disconnected"


module.exports = app