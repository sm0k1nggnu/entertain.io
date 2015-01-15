mocha   = require 'gulp-mocha'
coffee  = require 'gulp-coffee'

module.exports = (gulp) ->
  gulp.task 'specs', ->
    gulp.src('src/**/*.spec.coffee',
      read: false
    )
    .pipe coffee()
    .pipe mocha()
