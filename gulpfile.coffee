gulp  = require 'gulp'
gutil = require 'gulp-util'

gulp.on 'err', (e) ->
gulp.on 'task_err', (e) ->
  if process.env.CI
    gutil.log e
    process.exit 1


require('./gulp/development') gulp