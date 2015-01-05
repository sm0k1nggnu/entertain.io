sass    = require 'gulp-sass'
concat  = require 'gulp-concat'

module.exports = (gulp) ->
  gulp.task 'build:scss', ->
    gulp.src([
      'src/**/*.scss'
    ])
    .pipe(
      sass
        errLogToConsole: true
    )
    .on 'error', -> @emit 'end'
    .pipe(
      concat 'app.css'
    )
    .pipe(
      gulp.dest 'build/ui/styles'
    )