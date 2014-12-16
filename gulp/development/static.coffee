module.exports = (gulp) ->
  gulp.task 'static:images', ->
    gulp.src('src/ui/shared/**/*')
    .pipe(
      gulp.dest 'build/ui'
    )