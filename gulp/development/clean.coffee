rimraf = require 'gulp-rimraf'

module.exports = (gulp) ->
  gulp.task 'build:clean', ->
    gulp.src([
      'build'
    ])
    .pipe(
      rimraf()
    )