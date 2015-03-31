gulp-ctags
==========

ctags plugin for [gulp](https://github.com/gulpjs/gulp/).

How to Install
---------------

```bash
npm install --save-dev gulp-ctags
```

Usage Example
-------------

if you would like to generate a tag file for *.coffee files located under ./src directory, you can write gulpfile.js like this:

```javascript
gulp = require('gulp');
ctags = require('gulp-ctags');

gulp.task('ctags', function() {
  return gulp.src('./src/**/*.coffee')
    .pipe(ctags({name: 'coffee.tags'}))
    .pipe(gulp.dest('.git/'));
});
```

API
----

``ctags(options)``

- options.name: String

  a tag file name which which gulp-ctags generates.
  default value is ``tags``.

- options.concurrency: Number

  number of workers (ctags processes) to generate tag files.
  default value is ``1``.

- options.progress: Boolean

  whether progress bar is shown or not.
  default value is ``true``.

License
-------

The MIT License (MIT)

Copyright (c) 2015 daylilyfield

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
