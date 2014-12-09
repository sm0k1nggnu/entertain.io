jade = require 'gulp-jade'

module.exports = (gulp) ->
  gulp.task 'build:jade', ->
    gulp.src([
      'src/**/*.jade'
      '!src/app.ng.jade'
    ])
    .pipe(
      jade()
    )
    .pipe(
      gulp.dest 'build'
    )