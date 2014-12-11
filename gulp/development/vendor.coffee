mainBowerFiles  = require 'main-bower-files'
concat          = require 'gulp-concat'
filter          = require 'gulp-filter'
commonjsWrap    = require 'gulp-wrap-commonjs'

pickFilesByExtension = (extension) -> filter (file) -> file.path.match new RegExp("." + extension + "$")

module.exports = (gulp) ->

  gulp.task 'build:bower', ->
    gulp.src mainBowerFiles()
    .pipe pickFilesByExtension 'js'
    .pipe commonjsWrap
      pathModifier: (filePath) ->
        matches = filePath.match /(bower_components|node_modules)\/(.*?)\//
        moduleName = matches[2]
        moduleName

    .pipe concat 'vendor.js'
    .pipe gulp.dest 'build/ui/scripts'

    gulp.src mainBowerFiles()
    .pipe pickFilesByExtension 'css'
    .pipe concat 'vendor.css'
    .pipe gulp.dest 'build/ui/styles'


  gulp.task 'build:copy:scripts', ->
    gulp.src 'node_modules/commonjs-require/commonjs-require.js'
      .pipe gulp.dest('build/ui/scripts')
    gulp.src 'bower_components/socket.io-client/socket.io.js'
      .pipe gulp.dest('build/ui/scripts')

