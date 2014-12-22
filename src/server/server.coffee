express   = require('express')
app       = express()
http      = require('http').Server(app)
io        = require('socket.io')(http)

_PORT_ = 63647

# Start server
http.listen _PORT_, ->
  console.log "App listening at http://localhost:#{_PORT_}"


# Respond index.html
app.get '/', (req, res) ->
  res.sendFile "#{__projectdir}/index.html"

# Static files like css, js and images
app.use express.static __projectdir


io.on 'connection', (socket) ->
  console.log "User Connected"
  socket.on 'disconnect', ->
    console.log "User disconnected"


module.exports = app