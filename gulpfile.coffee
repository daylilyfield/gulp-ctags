gulp = require 'gulp'
mocha = require 'gulp-mocha'
coffee = require 'gulp-coffee'
pipe = require 'pipe-joint'

gulp.task 'default', ['build']
gulp.task 'build', ['test', 'coffee']

gulp.task 'coffee', -> pipe [
  gulp.src './src/**/*.coffee'
  coffee()
  gulp.dest './lib'
]

gulp.task 'test', -> pipe [
  gulp.src './spec/**/*-spec.coffee'
  mocha reporter: 'spec'
]


