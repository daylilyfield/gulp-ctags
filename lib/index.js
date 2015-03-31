(function() {
  var File, PLUGIN, PluginError, Progress, Promise, d, debug, exec, genCtags, gutil, isFileAvailable, join, makeFile, newCtagsCommandError, through;

  exec = require('child_process').exec;

  debug = require('debug');

  gutil = require('gulp-util');

  through = require('through2');

  File = require('vinyl');

  PluginError = gutil.PluginError;

  Promise = require('bluebird');

  Progress = require('progress');

  PLUGIN = 'gulp-ctags';

  d = debug(PLUGIN);

  isFileAvailable = function(file) {
    return !file.isNull() && (file.path != null);
  };

  newCtagsCommandError = function(err) {
    var s;
    s = JSON.stringify(err);
    return new PluginError(PLUGIN, "ctags command returned with errors: " + s);
  };

  genCtags = function(progress) {
    return function(path) {
      d("generate ctags for path: " + path);
      return new Promise(function(resolve, reject) {
        return exec("ctags -f - " + path, function(err, stdout, stderr) {
          if (err != null) {
            d("fail: " + (JSON.stringify(err)));
            return reject(newCtagsCommandError(err));
          } else {
            d("success: " + path);
            progress.tick();
            return resolve(stdout);
          }
        });
      });
    };
  };

  join = function(sep) {
    return function(l, r) {
      return l + sep + r;
    };
  };

  makeFile = function(path) {
    return function(contents) {
      d("make and locate a ctag file to: " + path);
      return new File({
        path: path,
        contents: new Buffer(contents)
      });
    };
  };

  module.exports = function(options) {
    var flush, paths, transform;
    if (options == null) {
      options = {};
    }
    if (options.name == null) {
      options.name = 'tags';
    }
    if (options.concurrency == null) {
      options.concurrency = 1;
    }
    if (options.progress == null) {
      options.progress = true;
    }
    paths = [];
    transform = function(file, encode, cb) {
      if (isFileAvailable(file)) {
        paths.push(file.path);
      }
      return cb();
    };
    flush = function(cb) {
      var error, progress, push;
      push = this.push.bind(this);
      error = this.emit.bind(this, 'error');
      d('begin to generate a ctag file');
      progress = options.progress ? new Progress('           generate tags [:bar] :percent', {
        total: paths.length + 1,
        width: 20
      }) : {
        tick: function() {}
      };
      return Promise.map(paths, genCtags(progress), {
        concurrency: options.concurrency
      }).reduce(join('')).then(makeFile(options.name)).then(push).then(progress.tick.bind(progress))["catch"](error).done(function() {
        d('finish generating a ctag file');
        return cb();
      });
    };
    return through.obj(transform, flush);
  };

}).call(this);
