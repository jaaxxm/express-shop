express = require('express')
path = require('path')
logger = require('morgan')
bodyParser = require('body-parser')
session = require('express-session')
cookieParser = require('cookie-parser')

# for authentication and authorization
passport = require('passport')
connectFlash = require('connect-flash')

# set global objects
global.__appbase_dirname = __dirname
dist = path.join(__appbase_dirname, '/dist')

# load local modules
apiRouter = require('./app/api_server/router')
oauth2Router = require('./app/oauth2_server/router')
database = require('./app/models/database')
app = express()

# declaration of local middlewares
# TODO this should be changed to more generic implementation
# internal middleware for redirect to http with TLS (https)
redirectHttps = ->
  (req, res, next) ->
    unless req.secure
      console.log 'redirect secure http server'
      return res.redirect('https://' + req.host + ':3443' + req.url)
    next()
    return

# initialize database model handler and path route handler
# register middlewares
app.use logger('dev')
app.all '*', redirectHttps()
app.use bodyParser.json()
app.use bodyParser.urlencoded({extended: true})
app.use express.static(dist)
app.use cookieParser()
app.use session(
  secret: 'keyboard cat'
  key: 'sid'
  resave: true
  saveUninitialized: true
)
app.use passport.initialize()
app.use passport.session()
app.use connectFlash()

# add middleware for authentication
database.initialize()
apiRouter.initialize app
oauth2Router.initialize app


# start backend with functionalities of both of API server and OAuth2 Server)
https = require('https')
fs = require('fs')
debug = require('debug')('backend')

# This is just selfsigned certificate. 
# for product, you can replace this to own certificates  
privateKey = './config/ssl/key.pem'
publicCert = './config/ssl/public.cert'
publicCertPassword = '12345'
httpsConfig =
  key: fs.readFileSync(privateKey)
  cert: fs.readFileSync(publicCert)
  passphrase: publicCertPassword

# http protocol 
server = app.listen(3000, ->
  debug 'Express server listening on port ' + server.address().port
  return
)

# https protocol
sslServer = https.createServer(httpsConfig, app)
sslServer.listen 3443, ->
  debug 'Express SSL server listening on port ' + sslServer.address().port
  return
