webserver =  require 'gulp-webserver'


module.exports = (gulp) ->
  gulp.task 'build:webserver', ->
    gulp.src(
      "build/ui"
    )
    .pipe(
      webserver
        livereload: true
    )