jade = require 'gulp-jade'

module.exports = (gulp) ->
  gulp.task 'build:jade', ->
    gulp.src([
      'src/**/*.jade'
      '!src/app.jade'
    ])
    .pipe(
      jade()
    )
    .on 'error', -> @emit 'end'
    .pipe(
      gulp.dest 'build'
    )