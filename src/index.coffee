path = require 'path'
{exec} = require 'child_process'

through = require 'through2'

module.exports = (options) ->

  files = []

  transform = (file, encode, callback) ->
    @push file

    if file.isNull()
      callback()
      return

    files.push file.path if file.path
    callback()

  flush = (callback) ->
    dest = path.resolve process.cwd(), options.dest
    src = files.join ' '
    exec "ctags -a -f #{dest} -R #{src}", (err, stdout, stderr) ->
      callback()

  through.obj transform, flush

