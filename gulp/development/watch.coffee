
module.exports = (gulp) ->
  gulp.task 'build:watch', ->
    gulp.watch [
      'src/**/*.jade'
    ], ['build:jade']

    gulp.watch [
      'src/**/*.scss'
    ], ['build:scss']

    gulp.watch [
      'src/**/*.coffee'
      '!src/**/*.spec.coffee'
    ], [
      'build:coffee'
      'specs'
    ]

    gulp.watch [
      'src/contexts/**/*.spec.coffee'
    ], ['specs']
    return
