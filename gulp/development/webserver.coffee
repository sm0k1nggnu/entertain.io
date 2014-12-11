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

    io.on 'connection', (socket) ->
      console.log "a user and stuff"
      socket.on 'disconnect', ->
        console.log "und weg issa"

      socket.on 'yeah', (msg) ->
        io.emit 'yeah', msg
