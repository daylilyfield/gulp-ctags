{exec} = require 'child_process'
debug = require 'debug'

gutil = require 'gulp-util'
through = require 'through2'

File = require 'vinyl'
PluginError = gutil.PluginError
Promise = require 'bluebird'
Progress = require 'progress'

PLUGIN = 'gulp-ctags'

d = debug PLUGIN

# File -> Boolean
isFileAvailable = (file) -> not file.isNull() and file.path?

# Error -> PluginError
newCtagsCommandError = (err) ->
  s = JSON.stringify err
  new PluginError PLUGIN, "ctags command returned with errors: #{s}"

# Progress -> String -> Promise
genCtags = (progress) -> (path) ->
  d "generate ctags for path: #{path}"
  new Promise (resolve, reject) ->
    exec "ctags -f - #{path}", (err, stdout, stderr) ->
      if err?
        d "fail: #{JSON.stringify err}"
        reject (newCtagsCommandError err)
      else
        d "success: #{path}"
        progress.tick()
        resolve stdout

# String -> String -> String -> String
join = (sep) -> (l, r) -> l + sep + r

# String -> String -> File
makeFile = (path) -> (contents) ->
  d "make and locate a ctag file to: #{path}"
  new File
    path: path
    contents: new Buffer contents

module.exports = (options = {}) ->
  options.name ?= 'tags'
  options.concurrency ?= 1
  options.progress ?= true

  paths = []

  transform = (file, encode, cb) ->
    paths.push file.path if isFileAvailable(file)
    cb()

  flush = (cb) ->
    push = @push.bind @
    error = @emit.bind @, 'error'

    d 'begin to generate a ctag file'

    progress =
      if options.progress
        new Progress '           generate tags [:bar] :percent',
          total: paths.length + 1 # 1 for writing a tag file
          width: 20
      else
        tick: ->

    Promise
      .map paths, genCtags(progress), concurrency: options.concurrency
      .reduce join ''
      .then makeFile options.name
      .then push
      .then progress.tick.bind progress
      .catch error
      .done ->
        d 'finish generating a ctag file'
        cb()

  through.obj transform, flush

