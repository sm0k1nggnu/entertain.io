coffee       = require 'gulp-coffee'
concat       = require 'gulp-concat'
commonjsWrap = require 'gulp-wrap-commonjs'

module.exports = (gulp) ->
  gulp.task 'build:coffee', ->
    gulp.src([
      'src/**/*.coffee'
      '!./**/*.spec.coffee'
    ])
    .pipe coffee()
    .on 'error', -> @emit 'end'
    .pipe commonjsWrap
      pathModifier: (filePath) ->
        filePath = filePath.replace(process.cwd(), 'entertain.io-app').replace /.js$/, ''
        filePath
    .pipe concat 'app.js'
    .pipe gulp.dest 'build/ui/scripts'