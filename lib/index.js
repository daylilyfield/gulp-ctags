(function() {
  var exec, path, through;

  path = require('path');

  exec = require('child_process').exec;

  through = require('through2');

  module.exports = function(options) {
    var files, flush, transform;
    files = [];
    transform = function(file, encode, callback) {
      this.push(file);
      if (file.isNull()) {
        callback();
        return;
      }
      if (file.path) {
        files.push(file.path);
      }
      return callback();
    };
    flush = function(callback) {
      var dest, src;
      dest = path.resolve(process.cwd(), options.dest);
      src = files.join(' ');
      return exec("ctags -a -f " + dest + " -R " + src, function(err, stdout, stderr) {
        return callback();
      });
    };
    return through.obj(transform, flush);
  };

}).call(this);
