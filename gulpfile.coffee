gulp   = require 'gulp'
coffee = require 'gulp-coffee'
mocha  = require 'gulp-mocha'

gulp.task 'test', ->
  gulp.src('test/*.test.coffee', { read: false })
    .pipe( mocha({reporter: 'nyan'}))
