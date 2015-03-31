{expect} = require 'chai'
vfile = require 'vinyl-file'

ctags = require '../src/'

describe 'gulp-ctags', ->

  it 'should create tag file.', (done) ->

    plugin = ctags()

    readFixture = (item) -> vfile.readSync "spec/fixture/victim#{item}.js"

    [1, 2]
      .map readFixture
      .map plugin.write.bind(plugin)

    plugin.end()

    plugin.once 'data', (file) ->
      symbols = ['foo1', 'bar1', 'foo2', 'bar2']
      contents = file.contents.toString 'utf8'
      notStartWith = (v) -> (s) -> v.indexOf(s) isnt 0
      filter = (p) -> (rs, v) -> rs.filter p v

      rs = contents.split('\n').reduce (filter notStartWith), symbols

      expect(rs.length).equal 0

      done()
