gulp      = require 'gulp'
sequence  = require 'gulp-run-sequence'

require('./clean') gulp
require('./coffee') gulp
require('./jade') gulp
require('./scss') gulp
require('./vendor') gulp
require('./watch') gulp
require('./webserver') gulp
require('./specs') gulp


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