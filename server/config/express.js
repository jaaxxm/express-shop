/**
 * Express configuration
 */

'use strict';

var express = require('express');
// var favicon = require('serve-favicon');
var morgan = require('morgan');
var compression = require('compression');
var bodyParser = require('body-parser');
var methodOverride = require('method-override');
var cookieParser = require('cookie-parser');
var errorHandler = require('errorhandler');
var path = require('path');
var config = require('./environment');
var passport = require('passport');
var session = require('express-session');
var mongoStore = require('connect-mongo')(session);
var mongoose = require('mongoose');

var Lockit = require('lockit');
var Signup = require('lockit-signup');
var Login = require('lockit-login');
var lockitUtils = require('lockit-utils');
var lockitConfig = require('./users.js');

var usersDb = lockitUtils.getDatabase(lockitConfig);
var adapter = require(usersDb.adapter)(lockitConfig);

var lockit = new Lockit(lockitConfig);

module.exports = function(app) {
  var env = app.get('env');

  app.set('views', config.root + '/server/views');
  app.engine('html', require('ejs').renderFile);
  app.set('view engine', 'html');
  app.use(compression());
  app.use(bodyParser.urlencoded({ extended: false }));
  app.use(bodyParser.json());
  app.use(methodOverride());
  app.use(cookieParser());
  app.use(passport.initialize());

  // Persist sessions with mongoStore
  // We need to enable sessions for passport twitter because its an oauth 1.0 strategy
  app.use(session({
    secret: config.secrets.session,
    resave: true,
    saveUninitialized: true,
    store: new mongoStore({ mongooseConnection: mongoose.connection })
  }));

  // create new Login instance
  var login = new Login(lockitConfig, adapter);
  var signup = new Signup(lockitConfig, adapter);
  // user registration/reset/delete
  app.use(signup.router);
  app.use(login.router);
  app.use(lockit.router);
  
  if ('production' === env) {
    // app.use(favicon(path.join(config.root, 'public', 'favicon.ico')));
    app.use(express.static(path.join(config.root, 'dist')));
    app.set('appPath', config.root + '/dist');
    app.use(morgan('dev'));
  }

  if ('development' === env || 'test' === env) {
    app.use(require('connect-livereload')());
    app.use(express.static(path.join(config.root, 'dist')));
    app.set('appPath', 'dist');
    app.use(morgan('dev'));
    app.use(errorHandler()); // Error handler - has to be last
  }
};