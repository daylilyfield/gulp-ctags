require('coffee-script').register()

fs = require 'fs'
path = require 'path'
{expect} = require 'chai'
es = require 'event-stream'
File = require 'vinyl'
rimraf = require 'rimraf'

ctags = require '../src/'

describe 'gulp-ctags', ->

  SPEC_WORK_DIR = '.spec-temp'

  before (done) ->
    rimraf SPEC_WORK_DIR, ->
      fs.mkdir SPEC_WORK_DIR, ->
        done()

  it 'should create tag file.', (done) ->

    plugin = ctags dest: "#{SPEC_WORK_DIR}/spec.tags"

    [1, 2].map (item) ->
      new File
        path: "spec/fixture/victim#{item}.js"
        contents: new Buffer('dummy')
    .forEach (file) ->
      plugin.write file

    plugin.end()

    # TODO how can i test it by much smarter way?
    plugin.once 'data', (file) ->
      count = 0
      watcher = fs.watch "#{SPEC_WORK_DIR}", (event, name) ->
        return unless ++count is 4
        expect(file.isBuffer()).to.be.ok
        fs.readFile "#{SPEC_WORK_DIR}/spec.tags", {encoding: 'utf8'},  (err, data) ->
          founds = foo1: false, bar1: false, foo2: false, bar2: false
          data.split('\n').map (line) ->
            for key of founds
              if line.indexOf(key) is 0
                founds[key] = true
          expect(founds.foo1).to.be.ok
          expect(founds.bar1).to.be.ok
          expect(founds.foo2).to.be.ok
          expect(founds.bar2).to.be.ok
          watcher.close()
          done()
