gulp = require 'gulp'
mocha = require 'gulp-mocha'
coffee = require 'gulp-coffee'
ctags = require './src'
pipe = require 'pipe-joint'

gulp.task 'default', ['build']
gulp.task 'build', ['test', 'coffee']

gulp.task 'coffee', -> pipe [
  gulp.src './src/**/*.coffee'
  coffee()
  gulp.dest './lib'
]

gulp.task 'watch', ->
  gulp.watch "./src/**/*.coffee", ['coffee']

gulp.task 'ctags', -> pipe [
  gulp.src './src/**/*.coffee'
  ctags name: 'coffee.tags'
  gulp.dest '.git/'
]

gulp.task 'test', -> pipe [
  gulp.src './spec/**/*-spec.coffee'
  mocha
    timeout: 2000
    reporter: 'spec'
]


