gulp      = require 'gulp'
sequence  = require 'gulp-run-sequence'

require('./gulp/development/clean') gulp
require('./gulp/development/coffee') gulp
require('./gulp/development/jade') gulp
require('./gulp/development/scss') gulp
require('./gulp/development/vendor') gulp
require('./gulp/development/watch') gulp
require('./gulp/development/webserver') gulp
require('./gulp/development/specs') gulp


module.exports = (gulp) ->
  gulp.task 'build', ->
    sequence(
      'build:clean'
      [
        'build:scss'
        'build:jade'
        'build:coffee'
        'build:bower'
        'build:copy:scripts'
      ]
      'build:webserver'
      'build:watch'
    )

  gulp.task 'default', -> sequence 'build'