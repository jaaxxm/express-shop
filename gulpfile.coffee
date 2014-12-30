gulp = require 'gulp'
gutil = require 'gulp-util'
livereload = require 'gulp-livereload'
nodemon = require 'gulp-nodemon'
rimraf = require 'rimraf'

front_path = "public"
components_path = "bower_components"
modules_path = "node_modules"
dist_path = "dist"
backapp_path = "app"

gulp.task 'clean', ->
  rimraf.sync(dist_path)

gulp.task 'copy', ['clean'], ->
  gulp.src("#{front_path}/**/*.html")
  .pipe(gulp.dest(dist_path))
  .pipe(livereload())

gulp.task 'build', ['clean', 'copy', 'css', 'js']

server_main = "server.coffee"
gulp.task 'server', ->
  nodemon
    script: server_main
    watch: [server_main, backapp_path]
    env:
      PORT: process.env.PORT or 3000

gulp.task 'default', ['clean', 'copy', 'server', 'watch']

gulp.task 'watch', ['copy'], ->
  livereload.listen()
  gulp.watch ["#{front_path}/**/*.html"], ['copy']
