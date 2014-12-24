{spawn} = require 'child_process'

module.exports = (gulp) ->
  gulp.task 'build:webserver', ->
    node.kill() if node
    node = spawn "coffee", ["src/server/server.coffee", '--port', '8000'],
      stdio: "inherit"
    node.on "close", (code) ->
      switch code
        when 8
          gulp.log "Error detected, waiting for changes..."