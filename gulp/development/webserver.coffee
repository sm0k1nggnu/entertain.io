# webserver =  require 'gulp-webserver'

express   = require('express')
# path      = require('path')
app       = express()
http      = require('http').Server(app)
io        = require('socket.io')(http)


module.exports = (gulp) ->
  gulp.task 'build:webserver', ->

    app.get '/', (req, res) ->
      res.sendFile(__projectdir + '/index.html')

    app.use( express.static(__projectdir) )

    http.listen 8001, ->
      console.log "yea listengin!"

    userAmount = 0
    io.on 'connection', (socket) ->
      ++userAmount
      console.log "a user and stuff"
      io.emit 'userAmount', userAmount
      socket.on 'disconnect', ->
        --userAmount
        io.emit 'userAmount', userAmount
        console.log "und weg issa"

      socket.on 'yeah', (msg) ->
        io.emit 'yeah', msg
