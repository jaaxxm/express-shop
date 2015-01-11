{ASSETS} = require './config/client.coffee'
front_path = 'public'
components_path = 'bower_components'
modules_path = 'node_modules'
dist_path = 'dist'
backapp_path = 'server'

gulp = require 'gulp'
template = require 'gulp-template'
jshint = require 'gulp-jshint'
livereload = require 'gulp-livereload'
nodemon = require 'gulp-nodemon'

log = require('gulp-util').log
path = require 'path'
rimraf = require 'rimraf'
es = require 'event-stream'
q = require 'q'

gulp.task 'clean', ->
  rimraf.sync(dist_path)

gulp.task 'jshint', ->
  gulp
    .src("#{front_path}/js/**/*.js")
    .pipe(jshint())
    .pipe(jshint.reporter('default'))

gulp.task 'copy', ['clean', 'jshint'], ->
  gulp.src(ASSETS.lib.js).pipe(gulp.dest("#{dist_path}/lib"))
  gulp.src("#{front_path}/js/**/*.js").pipe(gulp.dest("#{dist_path}/js"))
  gulp.src("#{front_path}/**/*.html").pipe(gulp.dest(dist_path))

gulp.task 'spa', ['copy'], ->

  unixifyPath = (p) ->
    regex = /\\/g
    p.replace regex, '/'

  includify = ->
    scripts = []

    bufferContents = (file) ->
      return if file.isNull()

      ext = path.extname file.path
      p = unixifyPath(path.join('', path.relative(file.cwd, file.path)))

      return if ext is '.js'
        scripts.push p

    endStream = ->
      payload = {scripts}
      @emit 'data', payload
      @emit 'end', payload

    es.through bufferContents, endStream

  getIncludes = ->
    deferred = q.defer()

    files = ASSETS.modules

    gulp
      .src files, cwd: front_path
      .pipe includify()
      .on 'end', (data) ->
        deferred.resolve data

    deferred.promise

  processTemplate = (files) ->
    deferred = q.defer()

    includes =
      libs: []
      modules: files.scripts

    for lib in ASSETS.lib.js
      # modifying libs includes path
      lib = lib.replace(/^.*[\\\/]/, '')
      includes.libs.push "lib/#{lib}"

    data =
      libs: includes.libs
      modules: includes.modules

    gulp
      .src "#{front_path}/index.html"
      .pipe template data
      .pipe gulp.dest dist_path
      .pipe livereload()
      .on 'end', ->
        deferred.resolve()

    deferred.promise

  getIncludes().then processTemplate

gulp.task 'build', ['clean', 'copy', 'css', 'js']

gulp.task 'server', ->
  nodemon(
    script: "#{backapp_path}/app.js"
    watch: [backapp_path]
    env:
      PORT: process.env.PORT or 3000
  )

gulp.task 'default', ['spa', 'server', 'watch']

gulp.task 'watch', ['copy'], ->
  livereload.listen()
  gulp.watch ["#{front_path}/**/*.js"], ['spa']
  gulp.watch ["#{front_path}/**/*.html"], ['spa']
